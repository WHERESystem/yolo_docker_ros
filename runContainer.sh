docker rm -f ros_noetic_yolov7
docker -D run --privileged -it -e  DISPLAY=$DISPLAY \
--privileged \
-v /dev/video0:/dev/video0 \
-v $(pwd)/images:/catkin_ws/src/yolov7/src/testImg \
-v $(pwd)/launch:/catkin_ws/src/launch \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v $XAUTH:/root/.Xauthority \
--gpus all \
--network host \
--env DISPLAY=$DISPLAY \
--env QT_X11_NO_MITSHM=1 \
--name=ros_noetic_yolov7 \
ros_noetic_yolov7:latest
