clear all 
clc
%%
% clear cam;
cam = webcam;
cam.Resolution = '640x480';
inputSize = [224 224 3];
YOLO_Object_Classifier = load('resnet50_6.mat');
bboxAreaThreshold = 1000;
%%
for  i = 1:10000
    img = snapshot(cam);
    size(img);
    
    img = imresize(img,inputSize(1:2));
    [bboxes,scores] = detect(YOLO_Object_Classifier.detector,img);
    
    % filter by selecting the strongest bounding box in the case of
    % overlapping ones
    
    [bboxes,scores] = selectStrongestBbox(bboxes,scores,'OverlapThreshold',0.2);
    bboxAreas = bboxes(:,3) .* bboxes(:,4);
    invalidAreaArray = bboxAreas < bboxAreaThreshold;  
    indicesToRemove = find(invalidAreaArray);
    
    bboxes(indicesToRemove,:) = [];
    scores(indicesToRemove,:) = [];
    
    xLeftTop = bboxes(:,1)   + (bboxes(:,3)/2) ;
    yLeftBottom = bboxes(:,2)  + (bboxes(:,4)/2);
    
    % plot the initial annotations
    if (~isempty(bboxes) && (length(bboxes)>0))
        img = insertObjectAnnotation(img,'rectangle',bboxes,scores); 
    end
    % display image and any centroids if there are any
    imshow(img);
    
    
    
    if length(xLeftTop) > 0 
        hold on;
        plot(xLeftTop , yLeftBottom  , 'r*', 'LineWidth', 1, 'MarkerSize', 2);
    end 
    %hold on;
    
    
end 
%% 
clear cam;

%% Supporting Functions
% arguments: 
% the vector from camera to the robot reference frame origin,
% the vector from camera frame to the target
% angles: theta, psi, phi, in angles
% outputs:
% 3x1 vector describing targets position in robot reference frame, P_r_t

function P_A = mapForRobotPose(theta,phi,psi,P_B,P_A_BORG)

pixelToInches = 0.1497; % constant subject to change, dependant on the how
                        % you place the camera and its measurements
theta = 0;
phi = 0;
psi = 0;

xInInches = xLeftTop * pixelToInches
yInInches = yLeftBottom * pixelToInches

P_B = [ xInInches; yInInches; 0; 1]; % vector from camera to target
P_A_BORG = [ 30; -30; 0 ]; % vector from robot to camera

Rx = [ 1 0 0;
     0 cosd(theta) -sind(theta) ;
     0 sind(theta) cosd(theta) ];
Ry = [ cosd(phi) 0 sind(phi);
    0 1 0;
    -sind(phi) 0 cosd(phi)];
Rz = [ cosd(psi) -sind(psi) 0 ;
     sind(psi) cosd(psi) 0;
     0 0 1];
% roatation from camera to robot
R_A_B =  Rz * Ry * Rx;
T_A_B(1:3,1:3) = R_A_B;
T_A_B(1:3,4) = P_A_BORG;
P_A = T_A_B * P_B;
end
    