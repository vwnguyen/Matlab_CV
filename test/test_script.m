% test_with_val2014
%% Purpose
% this script loads in the best detector that we have so far and test them
% against the val2014 dataset. The results will showcase the most robust
% detectors.
clc;
clear all;

%% Load in detectors and dataset

best_detectors = {'resnet101_1','resnet50_4'};
load('val2014_dataset.mat');
valDataset = images_val_2014;
val_files = dir('../Downloads/val2014'); %finds directory with file names
val_folder_path = val_files(1).folder;
fullImageName = fullfile(val_folder_path,valDataset(:,1));
valDataset(:,1) = fullImageName;
ap_report = [];
recall_report = [];
precision_report = [];
inputSize = [224 224]
for i = 1:length(best_detectors)
        detector_file = strcat(best_detectors{i},'.mat');
        load(detector_file);
        testDataTbl = cell2table(valDataset,...
        'VariableNames',{'imageFilename' 'bottle'});
        % create datastores for images labels and bounding boxes
        imdsTest = imageDatastore(testDataTbl{:,'imageFilename'});
        bldsTest = boxLabelDatastore(testDataTbl(:,'bottle'));
        testData = combine(imdsTest,bldsTest);
        preprocessedTestData = transform(testData,@(data)preprocessData(data,inputSize));
        detectionResults = detect(detector, preprocessedTestData);
        [ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData);
        ap_report = [ap_report ap];
        recall_report = [recall_report recall];
        precision_report = [precision_report recall];
        
        
end
  
% check to see if the file exists
% if exist('resnet101_1.mat')
% display('works')
% else
% display('lol')
% end
% works

%% Function prototyping
function data = preprocessData(data,targetSize)
% Resize image and bounding boxes to the targetSize.
scale = targetSize(1:2)./size(data{1},[1 2]);
data{1} = imresize(data{1},targetSize(1:2));
data{2} = floor(data{2});
%data{2}(2) = 1;
data{2} = correctData(data{2});
data{2} = bboxresize(data{2},scale); 
end

function data = correctData(data)

D = size(data);
length = D(1) * D(2);
if min(data,[],'all') == 0 
   for i=1:length
       if data(i) == 0 
           data(i) = 1;
       end
   end
end

end