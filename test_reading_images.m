clc;
clear all;

%% Read all files in the folder
folder_string = "test_images";
folder_struct = dir(strcat('../',folder_string));
folder_info = struct2cell(folder_struct);
folder_info = folder_info(1,:)'; % rows are struct categories
load('facility_val_test_data.mat');
facility_footage = [ValDataTable;TestDataTable];
index = 3;
% folder_info{89} = '..\test_images\facility3784.png'
%% sort through 
for i = 1:height(facility_footage) 
%     parsed_string = strsplit(folder_info{89}, '\');
    temp = facility_footage{i,1};
    temp = strsplit(temp{1}, '\');
    if strcmp(temp{3}, folder_info{index})
        test_images(index,:) = facility_footage(i,:);
%         test_images{index,1} = folder_info(89);
        test_images{index,1} = folder_info(index);
        test_images{index,1} = strcat('..\test_images\',test_images{index,1});
        index = index + 1;
    end
    if index == 100
        break;
    end
end

if length(folder_info)-2 == height(test_images)
    save('test_images_table', 'test_images');
end


    

    
