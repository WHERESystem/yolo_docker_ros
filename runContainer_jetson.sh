docker rm -f jetson_noetic_yolov7
docker -D run --privileged -it \
-v /dev/video0:/dev/video0 \
-v $(pwd)/launch:/catkin_ws/src/launch  \
--gpus all \
--network host \
--name=jetson_noetic_yolov7 \
jetson_noetic_yolov7:latest