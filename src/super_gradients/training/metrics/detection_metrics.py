from typing import List, Optional

import torch
from torchmetrics import Metric

import super_gradients
from super_gradients.training.utils.detection_utils import compute_detection_matching, compute_detection_metrics
from super_gradients.common.abstractions.abstract_logger import get_logger
logger = get_logger(__name__)

from super_gradients.training.utils.detection_utils import DetectionPostPredictionCallback, IouThreshold


class DetectionMetrics(Metric):
    """
    DetectionMetrics

    Metric class for computing F1, Precision, Recall and Mean Average Precision.

    Attributes:

         num_cls: number of classes.

         post_prediction_callback: DetectionPostPredictionCallback to be applied on net's output prior
            to the metric computation (NMS).

         iou_thres: Threshold to compute the mAP (default=IouThreshold.MAP_05_TO_095).

         normalize_targets: Whether to normalize bbox coordinates by image size (default=True).

         dist_sync_on_step: Synchronize metric state across processes at each ``forward()``
            before returning the value at the step. (default=False)
    """
    def __init__(self, num_cls: int,
                 post_prediction_callback: DetectionPostPredictionCallback = None,
                 iou_thres: IouThreshold = IouThreshold.MAP_05_TO_095,
                 recall_thres: Optional[torch.Tensor] = None,
                 score_thres: float = 0.1,
                 top_k_predictions: int = 100,
                 normalize_targets: bool = False,
                 dist_sync_on_step: bool = False):
        super().__init__(dist_sync_on_step=dist_sync_on_step)
        self.num_cls = num_cls
        self.iou_thres = iou_thres
        self.map_str = 'mAP@%.1f' % iou_thres[0] if not iou_thres.is_range() else 'mAP@%.2f:%.2f' % iou_thres
        self.component_names = ["Precision", "Recall", self.map_str, "F1"]
        self.components = len(self.component_names)
        self.post_prediction_callback = post_prediction_callback
        self.is_distributed = super_gradients.is_distributed()
        self.normalize_targets = normalize_targets
        self.world_size = None
        self.rank = None
        self.add_state("matching_info", default=[], dist_reduce_fx=None)

        self.iou_thresholds = iou_thres.to_tensor()
        self.recall_thresholds = torch.linspace(0, 1, 101) if recall_thres is None else recall_thres
        self.score_threshold = score_thres
        self.top_k_predictions = top_k_predictions

    def update(self, preds: List[torch.Tensor], target: torch.Tensor, device: str,
               inputs: torch.tensor, crowd_gts: Optional[torch.Tensor] = None):
        """
        Apply NMS and match all the predictions and targets of a given batch, and update the metric state accordingly.

        :param preds :    list (of length batch_size) of Tensors of shape (num_detections, 6)
                            format:  (x1, y1, x2, y2, confidence, class_label) where x1,y1,x2,y2 non normalized
        :param target:    targets for all images of shape (total_num_targets, 6)
                            format:  (index, x, y, w, h, label) where x,y,w,h are in range [0,1]
        :param device:    Device to run on
        :param inputs:    Input image tensor of shape (batch_size, n_img, height, width)
        :param crowd_gts: crowd targets for all images of shape (total_num_targets, 6)
                          format:  (index, x, y, w, h, label) where x,y,w,h are in range [0,1]
        :return:
        """
        self.iou_thresholds = self.iou_thresholds.to(device)

        _, _, height, width = inputs.shape
        targets = target.clone()
        if self.normalize_targets:
            targets[:, 2:] /= max(height, width)
        preds = self.post_prediction_callback(preds, device=device)

        new_matching_info = compute_detection_matching(
            preds, target, height, width, self.iou_thresholds, crowd_targets=crowd_gts, top_k=self.top_k_predictions)

        accumulated_matching_info = getattr(self, "matching_info")
        setattr(self, "matching_info", accumulated_matching_info + new_matching_info)

    def compute(self):
        precision, recall, mean_ap, f1 = -1, -1, -1, -1
        accumulated_matching_info = getattr(self, "matching_info")

        if len(accumulated_matching_info):
            matching_info_tensors = [torch.cat(x, 0) for x in list(zip(*accumulated_matching_info))]
            device = matching_info_tensors[0].device
            self.recall_thresholds = self.recall_thresholds.to(device)

            # shape (n_class, nb_iou_thresh)
            precision, recall, ap, f1, unique_classes = compute_detection_metrics(
                *matching_info_tensors, device=device, recall_thresholds=self.recall_thresholds,
                score_threshold=self.score_threshold)

            # Precision, recall and f1 are computed for smallest IoU threshold (usually 0.5), averaged over classes
            mean_precision, mean_recall, mean_f1 = precision[:, 0].mean(), recall[:, 0].mean(), f1[:, 0].mean()

            # MaP is averaged over IoU thresholds and over classes
            mean_ap = ap.mean()

        return {"Precision": mean_precision, "Recall": mean_recall, self.map_str: mean_ap, "F1": mean_f1}

    def _sync_dist(self, dist_sync_fn=None, process_group=None):
        """
        When in distributed mode, stats are aggregated after each forward pass to the metric state. Since these have all
        different sizes we override the synchronization function since it works only for tensors (and use
        all_gather_object)
        @param dist_sync_fn:
        @return:
        """
        if self.world_size is None:
            self.world_size = torch.distributed.get_world_size() if self.is_distributed else -1
        if self.rank is None:
            self.rank = torch.distributed.get_rank() if self.is_distributed else -1

        if self.is_distributed:
            local_state_dict = {attr: getattr(self, attr) for attr in self._reductions.keys()}
            gathered_state_dicts = [None] * self.world_size
            torch.distributed.barrier()
            torch.distributed.all_gather_object(gathered_state_dicts, local_state_dict)
            matching_info = []
            for state_dict in gathered_state_dicts:
                matching_info += state_dict["matching_info"]

            setattr(self, "matching_info", matching_info)
