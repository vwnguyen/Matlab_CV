%% Script to split video from the facility and export into detector files.
clear vars
clc

%% Load in test video footage and save to a folder directory
dir_str = '..\test_facility_video' %%
if ~exist(dir_str)
    mkdir(dir_str)
end
gTruth = load("test\video_facility_test_short.mat");
gTruth = gTruth.gTruth
oldpath = "C:\Users\Visitor\Desktop\good_train_footage\GP040676_Trim.mp4"; %% old data source
newpath = "..\GP040676_Trim.MP4"; %% if switching computers, this is the path where the video is
alterpaths = {[oldpath newpath]};
unresolved = changeFilePaths(gTruth,alterpaths);
VideoTable = objectDetectorTrainingData(gTruth, "WriteLocation", dir_str, 'NamePrefix','facility');

%% Split into Val and Test 
split_index = floor(0.5*height(VideoTable));
ValDataTable = VideoTable(1:split_index,:);
TestDataTable = VideoTable(split_index+1:end,:);
save('facility_val_test_data', 'ValDataTable', 'TestDataTable');

%% Load in full video GP050676 lables
dir_str = '..\GP050676_images' %%
if ~exist(dir_str)
    mkdir(dir_str)
end
gTruth = load("GP050676_labeled.mat");
gTruth = gTruth.gTruth
oldpath = "D:\GP050676.MP4"; %% old data source
newpath = "..\GP050676.MP4"; %% if switching computers, this is the path where the video is
alterpaths = {[oldpath newpath]};
unresolved = changeFilePaths(gTruth,alterpaths);
GP_50676_table = objectDetectorTrainingData(gTruth, "WriteLocation", dir_str, 'NamePrefix','facility');
save('GP_50676_table', 'GP_50676_table');
