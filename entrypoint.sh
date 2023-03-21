#!/bin/sh
python3 /catkin_ws/src/yolov7/src/export.py --weights /catkin_ws/src/yolov7/src/weights/yolov7-tiny.pt --grid --end2end --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 320 320 --max-wh 320
python3 /catkin_ws/src/yolov7/src/export.py --weights /catkin_ws/src/yolov7/src/weights/yolov7.pt --grid --end2end --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 320 320 --max-wh 320 
mv /catkin_ws/src/yolov7/src/weights/yolov7-tiny.onnx  /catkin_ws/src/yolov7/src/weights/yolov7-tiny.torchscript.pt  /catkin_ws/src/yolov7/src/weights/yolov7-tiny.torchscript.ptl /catkin_ws/src/yolov7/src/weights/onnx_yv7
mv /catkin_ws/src/yolov7/src/weights/yolov7.onnx  /catkin_ws/src/yolov7/src/weights/yolov7.torchscript.pt  /catkin_ws/src/yolov7/src/weights/yolov7.torchscript.ptl /catkin_ws/src/yolov7/src/weights/onnx_yv7
# python3 /catkin_ws/src/yolov7/src/onnxInferenceRos.py