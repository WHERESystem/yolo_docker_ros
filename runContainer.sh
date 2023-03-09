docker rm -f ros_noetic_yolov7
docker -D run --privileged -it \
-v /dev/video0:/dev/video0 \
-v $(pwd)/launch:/catkin_ws/src/launch  \
--gpus all \
--network host \
--name=ros_noetic_yolov7 \
ros_noetic_yolov7:latest
