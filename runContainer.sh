docker rm -f ros_noetic_yolo
docker -D run --privileged -it \
-v /dev/video0:/dev/video0 \
-v $(pwd)/launch:/catkin_ws/src/launch  \
--gpus all \
--network host \
--name=ros_noetic_yolo \
ros_noetic_yolo:latest