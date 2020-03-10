%% Script to split video from the facility and export into detector files.
clear vars
clc

%% Load in test video footage and save to a folder directory
dir_str = '..\test_facility_video_feed' %%
if ~exist(dir_str)
    mkdir(dir_str)
    gTruth_1 = load("test\video_facility_test_short.mat");
    gTruth_1 = gTruth_1.gTruth
    oldpath = "C:\Users\Visitor\Desktop\good_train_footage\GP040676_Trim.mp4"; %% old data source
    newpath = "..\GP040676_Trim.MP4"; %% if switching computers, this is the path where the video is
    alterpaths = {[oldpath newpath]};
    unresolved = changeFilePaths(gTruth_1,alterpaths);
    VideoTable = objectDetectorTrainingData(gTruth_1, "WriteLocation", dir_str, 'NamePrefix','facility');
        %% Split into Val and Test 
    split_index = floor(0.5*height(VideoTable));
    ValDataTable = VideoTable(1:split_index,:);
    TestDataTable = VideoTable(split_index+1:end,:);
    save('facility_val_test_data', 'ValDataTable', 'TestDataTable');
end

%% Load in full video GP050676 lables
dir_str = '..\training_footage' %%
if ~exist(dir_str)
    mkdir(dir_str)
end
% Load in GP050676 footage
gTruth_1 = load("GP050676_labeled.mat");
gTruth_1 = gTruth_1.gTruth
% oldpath = "D:\GP050676.MP4"; %% old data source
% newpath = "..\GP050676.MP4"; %% if switching computers, this is the path where the video is
% alterpaths = {[oldpath newpath]};
% unresolved = changeFilePaths(gTruth,alterpaths);
GP_50676_table = objectDetectorTrainingData(gTruth_1, "WriteLocation", dir_str, 'NamePrefix','facility_50676_');
height(GP_50676_table)

%% Load in GP060676 footage in two parts

gTruth_1 = load("GP60676_labels_part_1.mat");
gTruth_1 = gTruth_1.gTruth
% oldpath = "D:\GP050676.MP4"; %% old data source
% newpath = "..\GP050676.MP4"; %% if switching computers, this is the path where the video is
% alterpaths = {[oldpath newpath]};
% unresolved = changeFilePaths(gTruth,alterpaths);
GP_60676_table_pt1 = objectDetectorTrainingData(gTruth_1, "WriteLocation", dir_str, 'NamePrefix','facility_60676_1_');
height(GP_60676_table_pt1)

%%
gTruth_2 = load("GP60676_labels_part_2.mat");
gTruth_2 = gTruth_2.gTruth
oldpath = "C:\Users\Visitor\Desktop\good_train_footage\GP060676_Trim (2).mp4"
newpath = "..\GP060676_Trim (2).mp4"; %% if switching computers, this is the path where the video is
alterpaths = {[oldpath newpath]};
unresolved = changeFilePaths(gTruth_2,alterpaths);
GP_60676_table_pt2 = objectDetectorTrainingData(gTruth_2, "WriteLocation", dir_str, 'NamePrefix','facility_60676_2_');
height(GP_60676_table_pt2)

%% Combine both parts
GP_60676_table = [GP_60676_table_pt1;GP_60676_table_pt2];

%% Add in any other footage here
% . ........... %

%% Combine both videos in one table and save

training_table = [GP_50676_table;GP_60676_table];
height(training_table)
save_str = "facility_training_footage";
save(save_str, 'training_table');





