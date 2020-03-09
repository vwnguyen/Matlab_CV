clc;
clear all;

%% Read all files in the folder
folder_string = "??";
folder_struct = dir(strcat('../',folder_string));
folder_info = struct2cell(folder_struct);
folder_info = folder_info(1,:)'; % rows are struct categories
load('facility_val_test_data.mat');
facility_footage = [TestDataTable;ValDataTable];
index = 1;
%% sort through 
for i = 1:height(facility_footage)     
    if strcmp(facility_footage{i,1}, folder_info{89})
        test_images(index,:) = facility_footage(i,:); 
        index = index + 1;
    end
end

save('test_images', 'test_images');

    
