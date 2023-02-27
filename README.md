# Darknet ROS Using Docker

## Image Size: 8 GB

## Building: 
On x86_64 architecture: use ros_noetic_yolo.dockerfile with ./buildImage.sh

On amd64 architecture (jetson): use jetson_noetic_yolo.dockerfile with ./buildImage_jetson.sh

You may need to set the default docker runtime to "nvidia" if missing cublas when building on jetson: https://forums.developer.nvidia.com/t/nvidia-l4t-base-missing-cublas-v2-h/174582/4

In /etc/docker/daemon.json add at beginning of file: "default-runtime": "nvidia" to give build environment GPU access.

<!-- Docker with buildx. Needed for Jetson to solve "The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested". https://github.com/docker/buildx#installing


On host (may not be necessary to build, but it was on my docker build on the jetson nano), for Docker 19.03+ exectute:

DOCKER_BUILDKIT=1 docker build --platform=local -o . "https://github.com/docker/buildx.git"

mkdir -p ~/.docker/cli-plugins

mv buildx ~/.docker/cli-plugins/docker-buildx -->

## Tested on: Ubuntu 20.04, Nvidia Jetson
COCO update rate at 640x640 (YOLO) on Jetson with 1920x1080 res:

COCO update rate at 640x640 (YOLO) on Nvida  3080 1920x1080 res: 45 Hz

## Will need to change:
Weights, config, camera mounting in docker, and refernce in launch file for darknet_ros

In ./runcontainer.sh, change -v /dev/video0:/dev/video0 to the mounted camera on your system.

In /usb_cam/launch/, create a .launch file for your camera, or copy and modify one already there. 
Change [param name="video_device" value="/dev/video0"] to match mounted camera. 

If you have a calibration file you would like to use for your camera intrinsic parameters,
pass it here: [param name="camera_info_url" value="file:///$(find usb_cam)/calibration_config/3-12A-FHD/3-12A-FHD.yaml"/].

In /darknet_ros/darknet_ros/launch/yolo_v3.launch, check that published usb_cam topic matches subscriber.

Default weights for yolo_v3.lauch are from the COCO dataset for 80 objects, but can changed in /config/yolov3.yaml, parameters will also need updated in the /yolo_network_config/ weights and cfg.

You will need to change the ROS_MASTER URI in the docker file to match your ground station/main computer. Easiest to throw this at the end of the dockerfile.
