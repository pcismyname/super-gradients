# Fails at torch.compile
coco2017_ppyoloe_s:
	python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=coco2017_ppyoloe_s_compile_enabled multi_gpu=Off num_gpus=1
	python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=coco2017_ppyoloe_s_compile_disabled multi_gpu=Off num_gpus=1

# Fails at torch.compile (Complaining around multi
coco2017_ssd_lite_mobilenet_v2:
	python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=coco2017_ssd_lite_mobilenet_v2_compile_enabled multi_gpu=Off num_gpus=1
	python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=coco2017_ssd_lite_mobilenet_v2_compile_disabled multi_gpu=Off num_gpus=1

# Crashes at first forward attempt with CUDA error (misaligned address)
coco2017_yolox:
	python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=coco2017_yolox_compile_enabled multi_gpu=Off num_gpus=1
	python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=coco2017_yolox_compile_disabled multi_gpu=Off num_gpus=1

# Works
# Training batch time improvement - 26.6% faster
# Validation batch time - N/A (recipe crashes on last batch of training due use of Mixup & drop_last=True not handled properly)
imagenet_resnet50:
	CUDA_VISIBLE_DEVICES=0 python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=imagenet_resnet50_compile_enabled multi_gpu=Off num_gpus=1 &
	CUDA_VISIBLE_DEVICES=1 python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=imagenet_resnet50_compile_disabled multi_gpu=Off num_gpus=1 &

# Works
# Training batch time improvement - 19.7% faster
# Validation batch time improvement - 9.3% faster
cityscapes_ddrnet:
	CUDA_VISIBLE_DEVICES=2 python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=cityscapes_ddrnet_compile_enabled multi_gpu=Off num_gpus=1 &
	CUDA_VISIBLE_DEVICES=3 python src/super_gradients/examples/train_from_recipe_example/train_from_recipe.py --config-name=cityscapes_ddrnet_compile_disabled multi_gpu=Off num_gpus=1 &


all: imagenet_resnet50 cityscapes_ddrnet
