% resnet_1 = load('YOLOv2_MBSize_32_MaxEpoch_25_InitLearnRate_1e-3_NumAnchors_25_Acc_7.mat');
% resnet_1 = resnet_1.detector;
% resnet_2 = load('YOLOv2_MBSize_10_MaxEpoch_20_InitLearnRate_1e-3_NumAnchors_15_Acc_11.mat');
% resnet_2 = resnet_2.detector;
%% Make table with made detectors
Detectors = ["resnet50_1";"resnet50_2";"resnet50_3";"googlenet_4";"googlenet_5"];
Solver = ["sgdm";"sgdm";"sgdm";"sgdm";"sgdm"];
DatasetSize = [300;300;8000;8000;8000];
SplitSize = [.7;.7;.7;.7;.9];
InputImageSize = [[224 224];[224 224];[224 224];[224 224];[224 224]];
ActivationLayer = ["activation_40_relu";"activation_40_relu";"activation_40_relu";"inception_5b-output";"inception_5b-output"];
MiniBatchSize = [32;10;10;4;16];
LearningRate = [1e-3;1e-3;1e-3;1e-3;1e-3];
AnchorBoxes = [23;15;23;23;23];
Accuracy = [7;11;57;23;19];
ap = [0.0012;0.0082;0.0811;0.0232;0.0103];
trecall = [NaN; NaN; NaN; NaN; NaN];
precision = [NaN; NaN; NaN; NaN; NaN];
variable_names = {'Detectors','Solver','DatasetSize','SplitSize','InputImageSize','ActivationLayer','MiniBatchSize', 'LearningRate', 'AnchorBoxes', 'Accuracy', 'ap', 'trecall', 'precision'};
% var_names = {'Network' 'Layer of Activation' 'Mini Batch Size' 'Iteration Rate' 'Anchor Box Number' 'Layer' 'ap' 'recall' 'precision'};
detector_table = table(Detectors,Solver,DatasetSize,SplitSize, InputImageSize, ActivationLayer, MiniBatchSize, LearningRate, AnchorBoxes, Accuracy, ap, trecall, precision)

%% Add another row to an existing table
% this will be exported since all variable names between tables have to be the same 
% add_on = {"resnet_3","activation_40_relu",40,0.001,4,54,NaN,NaN,NaN}; %ex
% this will be the way we will append the cell in the script but we have to
% make sure that the strrings are indeed strings and use " " vs ' ' 
%% Convert Cell into Table
% add_Table = cell2table(add_on,'VariableNames', variable_names)
%% Append two tables together
% detector_table = [detector_table;add_Table]
%% Save table and variable names
save('detector_table_info.mat', 'detector_table', 'variable_names');