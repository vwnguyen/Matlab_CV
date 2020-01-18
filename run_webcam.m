
%%
clear cam;
cam = webcam
cam.Resolution = '640x480';
inputSize = [224 224 3];
YOLO_Object_Classifier = load('googleNet_stoppedNetwork.mat');
bboxAreaThreshold = 200;
%%
for  i = 1:10000
    img = snapshot(cam);
    size(img);
    img = imresize(img,inputSize(1:2));
    [bboxes,scores] = detect(YOLO_Object_Classifier.detector,img);
   
    bboxAreas = bboxes(:,3) .* bboxes(:,4);
    invalidAreaArray = bboxAreas < bboxAreaThreshold;  
    indicesToRemove = find(invalidAreaArray);
    
    bboxes(indicesToRemove,:) = [];
    scores(indicesToRemove,:) = [];
    
    xLeftTop = bboxes(:,1)   + (bboxes(:,3)/2) ;
    yLeftTop = bboxes(:,2)  + (bboxes(:,4)/2);
    
    if (~isempty(bboxes) && (length(bboxes)>0))
        
        img = insertObjectAnnotation(img,'rectangle',bboxes,scores); 
    end
    
    
    % display image and any centroids if there are any
    imshow(img);
    if length(xLeftTop) > 0 
        hold on;
        plot(xLeftTop , yLeftTop  , 'r*', 'LineWidth', 1, 'MarkerSize', 5);
    end 
    %hold on;
    
    
end 
%%
clear cam;
    