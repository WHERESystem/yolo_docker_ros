#!/bin/sh
docker build -f jetson_noetic_yolo.dockerfile -t jetson_noetic_yolo --build-arg CACHEBUST=$(date +%s) .