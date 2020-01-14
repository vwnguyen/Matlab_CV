clear all;
clc;
%%
cam = webcam;
cam.AvailableResolutions
%cam.Resolution = '640x480';
inputSize = [224 224 3];
YOLO_Object_Classifier = load('YOLOv2_MBSize_10_MaxEpoch_20_InitLearnRate_1e-3_NumAnchors_15.mat');
%%
figure;
for  i = 1:10000
    img = snapshot(cam);
    img = imresize(img,inputSize(1:2));
    [bboxes,scores] = detect(YOLO_Object_Classifier.detector,img);
    if(~isempty(bboxes))
        img = insertObjectAnnotation(img,'rectangle',bboxes,scores); 
    end
%     figure;
%     img = imresize(img,[720 1080]); Martin's camera
    imshow(img);
end 
%%
clear cam;
    