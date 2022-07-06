docker rm -f ros_ubuntu
docker -D run --privileged -it \
-v /dev/video0:/dev/video0 \
--gpus all \
--network host \
--name=ros_ubuntu \
ros_ubuntu:latest