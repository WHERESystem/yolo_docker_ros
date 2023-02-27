docker rm -f jetson_noetic_yolo
docker -D run --privileged -it \
-v /dev/video0:/dev/video0 \
-v $(pwd)/launch:/catkin_ws/src/launch  \
--gpus all \
--network host \
--name=jetson_noetic_yolo \
jetson_noetic_yolo:latest