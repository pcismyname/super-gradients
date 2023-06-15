unit_tests:
	python -m unittest tests/deci_core_unit_test_suite_runner.py

integration_tests:
	python -m unittest tests/deci_core_integration_test_suite_runner.py

yolo_nas_integration_tests:
	python -m unittest tests/integration_tests/yolo_nas_integration_test.py

recipe_accuracy_tests:
	python3.8 src/super_gradients/examples/convert_recipe_example/convert_recipe_example.py --config-name=cifar10_conversion_params experiment_name=shortened_cifar10_resnet_accuracy_test
	python3.8 src/super_gradients/train_from_recipe.py --config-name=coco2017_pose_dekr_w32_no_dc experiment_name=shortened_coco2017_pose_dekr_w32_ap_test epochs=1 batch_size=4 val_batch_size=8 training_hyperparams.lr_warmup_steps=0 training_hyperparams.average_best_models=False training_hyperparams.max_train_batches=1000 training_hyperparams.max_valid_batches=100 multi_gpu=DDP num_gpus=4
	python3.8 src/super_gradients/train_from_recipe.py --config-name=cifar10_resnet               experiment_name=shortened_cifar10_resnet_accuracy_test   epochs=100 training_hyperparams.average_best_models=False multi_gpu=DDP num_gpus=4
	python3.8 src/super_gradients/train_from_recipe.py --config-name=coco2017_yolox               experiment_name=shortened_coco2017_yolox_n_map_test      epochs=10  architecture=yolox_n training_hyperparams.loss=yolox_fast_loss training_hyperparams.average_best_models=False multi_gpu=DDP num_gpus=4
	python3.8 src/super_gradients/train_from_recipe.py --config-name=cityscapes_regseg48          experiment_name=shortened_cityscapes_regseg48_iou_test   epochs=10 training_hyperparams.average_best_models=False multi_gpu=DDP num_gpus=4
	coverage run --source=super_gradients -m unittest tests/deci_core_recipe_test_suite_runner.py
#
## Not working
#coco2017_yolox_compile_tests:
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolox architecture=yolox_s experiment_name=coco2017_yolox_s_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperimentsV2 +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolox architecture=yolox_s experiment_name=coco2017_yolox_s_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperimentsV2 +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ssd_lite_mobilenet_v2 experiment_name=coco2017_ssd_lite_mobilenet_v2_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperimentsV2 +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai   multi_gpu=OFF num_gpus=1
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ssd_lite_mobilenet_v2 experiment_name=coco2017_ssd_lite_mobilenet_v2_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperimentsV2 +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai   multi_gpu=OFF num_gpus=1
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_s experiment_name=coco2017_ppyoloe_s_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai  multi_gpu=OFF num_gpus=1 training_hyperparams.ema=False
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_s experiment_name=coco2017_ppyoloe_s_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai  multi_gpu=OFF num_gpus=1
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_m experiment_name=coco2017_ppyoloe_m_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_m experiment_name=coco2017_ppyoloe_m_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_l experiment_name=coco2017_ppyoloe_l_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_l experiment_name=coco2017_ppyoloe_l_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_x experiment_name=coco2017_ppyoloe_x_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_ppyoloe_x experiment_name=coco2017_ppyoloe_x_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#
#detection_compile_tests:
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolo_nas_s experiment_name=coco2017_yolo_nas_s_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolo_nas_s experiment_name=coco2017_yolo_nas_s_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolo_nas_m experiment_name=coco2017_yolo_nas_m_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolo_nas_m experiment_name=coco2017_yolo_nas_m_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolo_nas_l experiment_name=coco2017_yolo_nas_l_compile_enabled  epochs=5 training_hyperparams.torch_compile=True   training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai
#	python -m super_gradients.train_from_recipe --config-name=coco2017_yolo_nas_l experiment_name=coco2017_yolo_nas_l_compile_disabled epochs=5 training_hyperparams.torch_compile=False  training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai

LOGGING_PARAMETERS = training_hyperparams.sg_logger=wandb_sg_logger +training_hyperparams.sg_logger_params.project_name=TorchCompileExperiments +training_hyperparams.sg_logger_params.entity=super-gradients  +training_hyperparams.sg_logger_params.api_server=https://wandb.research.deci.ai

# We disable SyncBN & EMA and enable AMP for all experiments
# Also we disable loading the backbone weights for all experiments (it's irrelevant for performance testing)
DEFAULT_TRAINING_PARAMETERS = epochs=5 training_hyperparams.ema=False training_hyperparams.sync_bn=False training_hyperparams.mixed_precision=True checkpoint_params.load_backbone=False

SINGLE_GPU = multi_gpu=OFF num_gpus=1
MULTIPLE_GPUS = multi_gpu=DDP num_gpus=8

segmentation_compile_tests:
	# cityscapes_pplite_seg75
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_pplite_seg75 experiment_name=cityscapes_pplite_seg75_compile_enabled_ddp   training_hyperparams.torch_compile=True  $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_pplite_seg75 experiment_name=cityscapes_pplite_seg75_compile_enabled_1gpu  training_hyperparams.torch_compile=True  $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_pplite_seg75 experiment_name=cityscapes_pplite_seg75_compile_disabled_ddp  training_hyperparams.torch_compile=False $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_pplite_seg75 experiment_name=cityscapes_pplite_seg75_compile_disabled_1gpu training_hyperparams.torch_compile=False $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)

	# cityscapes_regseg48
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_regseg48 experiment_name=cityscapes_regseg48_compile_enabled_ddp   training_hyperparams.torch_compile=True  $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_regseg48 experiment_name=cityscapes_regseg48_compile_enabled_1gpu  training_hyperparams.torch_compile=True  $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_regseg48 experiment_name=cityscapes_regseg48_compile_disabled_ddp  training_hyperparams.torch_compile=False $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_regseg48 experiment_name=cityscapes_regseg48_compile_disabled_1gpu training_hyperparams.torch_compile=False $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)

	# cityscapes_segformer
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_segformer experiment_name=cityscapes_segformer_compile_enabled_ddp   training_hyperparams.torch_compile=True  $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_segformer experiment_name=cityscapes_segformer_compile_enabled_1gpu  training_hyperparams.torch_compile=True  $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_segformer experiment_name=cityscapes_segformer_compile_disabled_ddp  training_hyperparams.torch_compile=False $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_segformer experiment_name=cityscapes_segformer_compile_disabled_1gpu training_hyperparams.torch_compile=False $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)

	# cityscapes_stdc_seg75
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_stdc_seg75 experiment_name=cityscapes_stdc_seg75_compile_enabled_ddp   training_hyperparams.torch_compile=True  $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_stdc_seg75 experiment_name=cityscapes_stdc_seg75_compile_enabled_1gpu  training_hyperparams.torch_compile=True  $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_stdc_seg75 experiment_name=cityscapes_stdc_seg75_compile_disabled_ddp  training_hyperparams.torch_compile=False $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_stdc_seg75 experiment_name=cityscapes_stdc_seg75_compile_disabled_1gpu training_hyperparams.torch_compile=False $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)

	# cityscapes_stdc_seg75
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_ddrnet experiment_name=cityscapes_ddrnet_compile_enabled_ddp   training_hyperparams.torch_compile=True  $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
#	python -m super_gradients.train_from_recipe --config-name=cityscapes_ddrnet experiment_name=cityscapes_ddrnet_compile_enabled_1gpu  training_hyperparams.torch_compile=True  $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
	python -m super_gradients.train_from_recipe --config-name=cityscapes_ddrnet experiment_name=cityscapes_ddrnet_compile_disabled_ddp  training_hyperparams.torch_compile=False $(MULTIPLE_GPUS) $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
	python -m super_gradients.train_from_recipe --config-name=cityscapes_ddrnet experiment_name=cityscapes_ddrnet_compile_disabled_1gpu training_hyperparams.torch_compile=False $(SINGLE_GPU)    $(DEFAULT_TRAINING_PARAMETERS) $(LOGGING_PARAMETERS)
