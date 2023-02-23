# Darknet ROS Using Docker

## Image Size:

## Dependencies: 

## Tested on: Ubuntu 20.04, Nvidia Jetson
COCO update rate at 640x640 on Jetson:

COCO update rate at 640x640 on Nvida 3080: 40 Hz

## Will need to change:
Weights, config, camera mounting in docker, and refernce in launch file for darknet_ros

In ./runcontainer.sh, change -v /dev/video0:/dev/video0 to the mounted camera on your system.

In /usb_cam/launch/, create a .launch file for your camera, or copy and modify one already there. 
Change [param name="video_device" value="/dev/video0"] to match mounted camera. 

If you have a calibration file you would like to use for your camera intrinsic parameters,
pass it here: [param name="camera_info_url" value="file:///$(find usb_cam)/calibration_config/3-12A-FHD/3-12A-FHD.yaml"/].

In /darknet_ros/darknet_ros/launch/yolo_v3.launch, check that published usb_cam topic matches subscriber.

Default weights for yolo_v3.lauch are from the COCO dataset for 80 objects, but can changed in /config/yolov3.yaml, parameters will also need updated in the /yolo_network_config/ weights and cfg.

You will need to change the ROS_MASTER URI in the docker file to match your ground station/main computer.
