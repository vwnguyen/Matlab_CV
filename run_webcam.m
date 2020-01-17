
%%
clear cam;
cam = webcam
cam.Resolution = '640x480';
inputSize = [224 224 3];
YOLO_Object_Classifier = load('YOLOv2_MBSize_10_MaxEpoch_20_InitLearnRate_1e-3_NumAnchors_23_Acc_NaN.mat');
bboxAreaThreshold = 200;
%%
for  i = 1:10000
    img = snapshot(cam);
    size(img)
    img = imresize(img,inputSize(1:2));
    [bboxes,scores] = detect(YOLO_Object_Classifier.detector,img);
   
    bboxAreas = bboxes(:,3) .* bboxes(:,4);
    invalidAreaArray = bboxAreas < bboxAreaThreshold;  
    indicesToRemove = find(invalidAreaArray);
    
    bboxes(indicesToRemove,:) = [];
    scores(indicesToRemove,:) = [];
    
    if (~isempty(bboxes) && (length(bboxes)>0))
        

        
        img = insertObjectAnnotation(img,'rectangle',bboxes,scores); 
    end
    imshow(img);
end 
%%
clear cam;
    