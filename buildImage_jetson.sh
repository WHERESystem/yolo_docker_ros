#!/bin/sh
docker build -f jetson_noetic_yolov7.dockerfile -t jetson_noetic_yolov7 --build-arg CACHEBUST=$(date +%s) .