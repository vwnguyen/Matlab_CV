% test_with_val2014
%% Purpose
% this script loads in the best detector that we have so far and test them
% against the val2014 dataset. The results will showcase the most robust
% detectors.
clc;
clear all;

%% Load in detectors 
folder_string = "tinyYOLO Detectors";
folder_struct = dir(folder_string);
folder_info = struct2cell(folder_struct);
folder_info = folder_info(1,:)'
folder_info = folder_info(4:end,1)

ap_report = [];
for i = 1:length(folder_info)
   %Load in test table
    load(strcat('tinyYOLO Detectors\',folder_info{i}))

    load('facility_val_test_data.mat');
    test_data = TestDataTable;
    test_data.Properties.VariableNames{'cans'} = 'can'
    imdsTest = imageDatastore(test_data{:,'imageFilename'});
    bldsTest = boxLabelDatastore(test_data(:,(2:5)));
    test_data = combine(imdsTest,bldsTest);
    preprocessedTestData = transform(test_data,@(data)preprocessData(data, detector.TrainingImageSize))
    detectionResults = detect(detector, preprocessedTestData)
    [ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData)
    ap_report = [ap_report ap];
    
    
end
%%

load('..\facility_val_test_data.mat');
test_data = TestDataTable;
imdsTest = imageDatastore(testDataTbl{:,'imageFilename'});
bldsTest = boxLabelDatastore(testDataTbl(:,'bottle'));
test_data = combine(imdsTest,bldsTest);
preprocessedTestData = transform(test_data,@(data)preprocessData(data,inputSize));

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
        test_data = combine(imdsTest,bldsTest);
        preprocessedTestData = transform(test_data,@(data)preprocessData(data,inputSize));
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