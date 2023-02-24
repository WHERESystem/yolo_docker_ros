FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
# install ros dependencies

SHELL ["/bin/bash", "-c"]

RUN apt-get update 
RUN apt-get update --no-install-recommends \
    && apt-get install curl -y\
    && apt-get install -y lsb-release\
    && apt-get install -y tzdata\
    && echo "deb http://packages.ros.org/ros/ubuntu focal main" | tee /etc/apt/sources.list.d/ros-focal.list\
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# # install ros
# RUN apt-get update\
#     && apt-get install -y ros-noetic-ros-base

ENV TZ=America/NewYork
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# SHELL ["/bin/bash", "-c"]
# install ros packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends ros-noetic-perception \
    && apt-get install ros-noetic-roslint\
    && apt-get install ros-noetic-diagnostics -y \
    && apt-get install iputils-ping -y\
    && apt-get install wget -y\
    && apt-get install net-tools -y\
    && apt-get install ros-noetic-velodyne -y \
    && apt-get install v4l-utils -y\
    && rm -rf /var/lib/apt/lists/*
    
# install python packages
RUN apt-get update \
    && apt-get install -y python3-pip python3-rospkg nano\
    && pip3 install defusedxml netifaces\
    && apt-get install python3-numpy\
    && apt-get install -y python3-opencv\
    && apt-get install libpcap-dev -y\
    && apt-get install -y git python3 build-essential python3-zmq python3-matplotlib python3-scipy libev-dev libevdev2\
    && apt-get install python3-catkin-tools python3-osrf-pycommon -y

# SHELL ["/bin/bash", "-c"]

RUN pip3 install setuptools==49.6.0
RUN pip3 install imutils pyserial rpi.gpio

RUN mkdir -p catkin_ws/src
WORKDIR /catkin_ws/src

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

ARG CACHEBUST=1
# RUN git clone https://github.com/OUIDEAS/velodyne.git
RUN git clone --recursive https://github.com/WHERESystem/usb_cam.git
RUN git clone --recursive https://github.com/WHERESystem/darknet_ros.git 

RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /catkin_ws; catkin build'

WORKDIR /catkin_ws/src/darknet_ros/darknet_ros/yolo_network_config/weights
RUN wget http://pjreddie.com/media/files/yolov3.weights
RUN wget https://github.com/WHERESystem/darknet_ros/releases/download/1.1.1/deer_logos.weights
WORKDIR /catkin_ws/src/

# ENV LD_LIBRARY_PATH = $LD_LIBRARY_PATH:/usr/local/cuda/lib64

RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN echo "export ROS_MASTER_URI=http://192.168.1.3:11311/" >> ~/.bashrc
# RUN echo "export ROS_IP=192.168.1.3" >> ~/.bashrc