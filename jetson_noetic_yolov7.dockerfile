#
# this dockerfile roughly follows the 'Installing from source' from:
#   http://wiki.ros.org/noetic/Installation/Source
#
# ARG BASE_IMAGE=nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3
FROM nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3

ARG ROS_PKG=ros_base
ENV ROS_DISTRO=melodic
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PYTHON_VERSION=3
ENV DEBIAN_FRONTEND=noninteractive

# add the ROS deb repo to the apt sources list
#
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 42D5A192B819C5DA
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

# RUN apt-get purge -y '*opencv*'
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

#
# install bootstrap dependencies
# #
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
          libpython3-dev \
          python3-rosdep \
          python3-rosinstall-generator \
          python3-vcstool \
          python3-catkin-pkg\
          python3-catkin-tools\
          build-essential \
          python3-pandas \
          python3-tqdm \
          python3-requests\
          python3-tk\
          python3-opencv\
          python3-seaborn &&\
    rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-perception \
    && apt-get install ros-${ROS_DISTRO}-roslint\
    && apt-get install ros-${ROS_DISTRO}-diagnostics -y \
    && apt-get install ros-${ROS_DISTRO}-catkin \
    && apt-get install ros-${ROS_DISTRO}-image-transport -y\
    && apt-get install ros-${ROS_DISTRO}-camera-info-manager -y\
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt install libprotobuf-dev protobuf-compiler -y
# RUN apt-get update && apt-get install python3-rospkg -y
# RUN pip3 install tk
RUN pip3 install imutils pyserial rpi.gpio\
    && pip3 install setuptools==49.6.0\
    && pip3 install scipy==1.1.0
    # && pip3 install scikit-learn==0.21.3\
    # && pip3 install onnx onnxruntime onnxsim onnx-tf onnxruntime-gpu

RUN pip3 install --upgrade pip
# RUN pip3 install numpy==1.23.1
# RUN pip3 install onnx onnxruntime onnxsim onnx-tf
RUN pip3 install onnx==1.10.0
# RUN pip3 install onnxsim
# RUN pip3 onnxruntime-gpu
RUN wget https://nvidia.box.com/shared/static/jy7nqva7l88mq9i8bw3g3sklzf4kccn2.whl -O onnxruntime_gpu-1.10.0-cp36-cp36m-linux_aarch64.whl
RUN pip3 install onnxruntime_gpu-1.10.0-cp36-cp36m-linux_aarch64.whl
# RUN pip3 install protobuf==3.20 && pip3 install numpy==1.23.1

WORKDIR /catkin_ws/src

RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash' >> /root/.bashrc


ARG CACHEBUST=1
# RUN git clone https://github.com/OUIDEAS/velodyne.git
# RUN git clone https://github.com/WHERESystem/usb_cam.git
# RUN git clone --recursive https://github.com/WHERESystem/darknet_ros.git 

RUN git clone https://github.com/TravisMoleski/yolov7.git

# RUN apt-get update && rosdep install --from-paths . -y

RUN /bin/bash -c '. /opt/ros/${ROS_DISTRO}/setup.bash; cd /catkin_ws; catkin build'

WORKDIR /catkin_ws/src/yolov7/src

RUN mkdir weights
WORKDIR /catkin_ws/src/yolov7/src/weights
RUN wget https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7.pt
RUN wget https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7-tiny.pt

# WORKDIR  /catkin_ws/src/yolov7/src
ENV LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64
# RUN python3 /catkin_ws/src/yolov7/src/export.py --weights /catkin_ws/src/yolov7/src/weights/yolov7-tiny.pt --grid --end2end  \
# --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 640 640 --max-wh 640

RUN mkdir /catkin_ws/src/yolov7/src/weights/onnx_yv7

# "mv yolov7-tiny.onnx  yolov7-tiny.torchscript.pt  yolov7-tiny.torchscript.ptl /catkin_ws/src/yolov7/src/weights/onnx_yv7"]

# RUN mkdir /catkin_ws/src/yolov7/src/weights/onnx_yv7
# RUN mkdir /catkin_ws/src/yolov7/src/weights/tf
# RUN mkdir /catkin_ws/src/yolov7/src/weights/tf_lite

# WORKDIR /catkin_ws/src/yolov7/src/weights
# RUN mv yolov7-tiny.onnx  yolov7-tiny.torchscript.pt  yolov7-tiny.torchscript.ptl /catkin_ws/src/yolov7/src/weights/onnx_yv7
# RUN onnx-tf convert -i /catkin_ws/src/yolov7/src/weights/onnx_yv7/yolov7-tiny.onnx -o  /catkin_ws/src/yolov7/src/weights/tf

# WORKDIR /catkin_ws/src/yolov7/src

# WORKDIR /catkin_ws/src/darknet_ros/darknet_ros/yolo_network_config/weights
# RUN wget http://pjreddie.com/media/files/yolov3.weights
# RUN wget https://github.com/WHERESystem/darknet_ros/releases/download/1.1.1/deer_logos.weights
# WORKDIR /catkin_ws/src/

# ENV LD_LIBRARY_PATH = $LD_LIBRARY_PATH:/usr/local/cuda/lib64

RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "export ROS_MASTER_URI=http://192.168.1.3:11311/" >> ~/.bashrc
RUN echo "export ROS_IP=192.168.55.1" >> ~/.bashrc


WORKDIR /catkin_ws/src/yolov7/src
COPY ./entrypoint.sh /catkin_ws/src/yolov7/src
RUN chmod +x ./entrypoint.sh
# ENTRYPOINT [ "./entrypoint.sh"]
# CMD ["/bin/bash", "-c", "python3 /catkin_ws/src/yolov7/src/export.py --weights /catkin_ws/src/yolov7/src/weights/yolov7-tiny.pt \
# --grid --end2end --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 320 320 --max-wh 320;python3 /catkin_ws/src/yolov7/src/export.py \ 
# --weights /catkin_ws/src/yolov7/src/weights/yolov7-tiny.pt --grid --end2end --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 320 320 --max-wh 320; \ 
# mv /catkin_ws/src/yolov7/src/weights/yolov7-tiny.onnx  /catkin_ws/src/yolov7/src/weights/yolov7-tiny.torchscript.pt  /catkin_ws/src/yolov7/src/weights/yolov7-tiny.torchscript.ptl \ 
# /catkin_ws/src/yolov7/src/weights/onnx_yv7"]
