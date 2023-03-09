#
# this dockerfile roughly follows the 'Installing from source' from:
#   http://wiki.ros.org/noetic/Installation/Source
#
ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r32.5.0
FROM ${BASE_IMAGE}

ARG ROS_PKG=ros_base
ENV ROS_DISTRO=melodic
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PYTHON_VERSION=3
ENV DEBIAN_FRONTEND=noninteractive

# add the ROS deb repo to the apt sources list
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nano \
        git \
		cmake \
		build-essential \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
        iputils-ping\
        net-tools\
        v4l-utils\
    && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

#
# install bootstrap dependencies
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
          libpython3-dev \
          python3-rosdep \
          python3-rosinstall-generator \
          python3-vcstool \
          python3-catkin-pkg\
          python3-catkin-tools\
          build-essential && \
          && apt-get install -y python3-pandas python3-tqdm python3-seaborn\
    rosdep init && \
    rosdep update && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-perception \
    && apt-get install ros-${ROS_DISTRO}-roslint\
    && apt-get install ros-${ROS_DISTRO}-diagnostics -y \
    && apt-get install ros-${ROS_DISTRO}-catkin \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install imutils pyserial rpi.gpio\
    && pip3 install torchvision\
    && pip3 install numpy==1.21\
    && pip3 install setuptools==49.6.0

WORKDIR /catkin_ws/src

RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash' >> /root/.bashrc

# ARG CACHEBUST=1
# RUN git clone https://github.com/OUIDEAS/velodyne.git
RUN git clone https://github.com/WHERESystem/usb_cam.git
# RUN git clone --recursive https://github.com/WHERESystem/darknet_ros.git 
RUN git clone https://github.com/TravisMoleski/yolov7.git

RUN /bin/bash -c '. /opt/ros/${ROS_DISTRO}/setup.bash; cd /catkin_ws; catkin build'

# WORKDIR /catkin_ws/src/darknet_ros/darknet_ros/yolo_network_config/weights
# RUN wget http://pjreddie.com/media/files/yolov3.weights
# RUN wget https://github.com/WHERESystem/darknet_ros/releases/download/1.1.1/deer_logos.weights
WORKDIR /catkin_ws/src/

# ENV LD_LIBRARY_PATH = $LD_LIBRARY_PATH:/usr/local/cuda/lib64

RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
# RUN echo "export ROS_MASTER_URI=http://192.168.1.3:11311/" >> ~/.bashrc
# RUN echo "export ROS_IP=192.168.1.16" >> ~/.bashrc
