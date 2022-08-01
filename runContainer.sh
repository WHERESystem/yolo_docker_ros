docker rm -f ros_ubuntu
docker container prune -a
docker image prune -a
docker -D run --privileged -it \
-v /dev/video0:/dev/video0 \
--gpus all \
--network host \
--name=ros_ubuntu \
ros_ubuntu:latest