clear all 
clc
%%
% clear cam;
cam = webcam(2);
cam.Resolution = '320x240';
inputSize = [331 331 3];
YOLO_Object_Classifier = load('resnet101_3.mat');
bboxAreaThreshold = 1000;
theta = 0;
phi = 0;
psi = 0;
P_A_BORG = [ 0; 0; 0 ];
origLength = 0;
%%
for  i = 1:10000
    img = snapshot(cam);
    img = imresize(img,inputSize(1:2));
    [bboxes,scores] = detect(YOLO_Object_Classifier.detector,img);
    % filter by selecting the strongest bounding box in the case of
    % overlapping ones
    [bboxes,scores] = selectStrongestBbox(bboxes,scores,'OverlapThreshold',0.2);
    
    % area filtering
%     bboxAreas = bboxes(:,3) .* bboxes(:,4);
%     invalidAreaArray = bboxAreas < bboxAreaThreshold;  
%     indicesToRemove = find(invalidAreaArray);
%     bboxes(indicesToRemove,:) = [];
%     scores(indicesToRemove,:) = [];
    
    
    xCenter = bboxes(:,1)   + (bboxes(:,3)/2) ; % note bboxes(:,1) = LHS X
    yCenter = bboxes(:,2)  + (bboxes(:,4)/2); % note bboxes(:,2) = Y from bottom
    
    % plot the initial confidence annotations
    if (~isempty(bboxes) && (length(bboxes)>0))
        img = insertObjectAnnotation(img,'rectangle',bboxes,scores); 
        %imshow(img);
        if length(xCenter) > 0 
            hold on;
            %plot(xCenter , yCenter  , 'r*', 'LineWidth', 2, 'MarkerSize', 3);
            for j = 1:length(xCenter)
                P_A(j,:) = mapToRobotBase(theta,phi,psi,xCenter(j,1),yCenter(j,1),P_A_BORG);
                coordinates(j) = cellstr(strcat(int2str(P_A(j,1)),',',int2str(P_A(j,2))));
            end
            % replace this with sending coordinates later
            
            % update last length
        end 
        % clear the coordinate array    
    else
        %imshow(img);
    end
    % replace display to output coordinates instead
    % when you need to modularize this code
    disp(coordinates);
    disp("\n");
    coordinates = {};
end 
%% 
clear cam;

function P_A = mapToRobotBase(theta,phi,psi,xCenter,yCenter,P_A_BORG)

xPixelToInches = 0.1919; % constant subject to change, dependant on the how
yPixelToInches = 0.1094;
% you place the camera and its measurements
xInInches = xCenter * xPixelToInches;
yInInches = yCenter * yPixelToInches;

P_B = [ xInInches; yInInches; 0; 1]; % vector from camera to target

Rx = [ 1 0 0;
     0 cosd(theta) -sind(theta) ;
     0 sind(theta) cosd(theta) ];
Ry = [ cosd(phi) 0 sind(phi);
    0 1 0;
    -sind(phi) 0 cosd(phi)];
Rz = [ cosd(psi) -sind(psi) 0 ;
     sind(psi) cosd(psi) 0;
     0 0 1];
 
% rotation from camera to robot
R_A_B =  Rz * Ry * Rx;
T_A_B(1:3,1:3) = R_A_B;
T_A_B(1:3,4) = P_A_BORG;
P_A = T_A_B * P_B;
end
    