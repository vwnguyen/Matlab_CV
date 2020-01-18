% resnet_1 = load('YOLOv2_MBSize_32_MaxEpoch_25_InitLearnRate_1e-3_NumAnchors_25_Acc_7.mat');
% resnet_1 = resnet_1.detector;
% resnet_2 = load('YOLOv2_MBSize_10_MaxEpoch_20_InitLearnRate_1e-3_NumAnchors_15_Acc_11.mat');
% resnet_2 = resnet_2.detector;
%% Make table with made detectors
Detectors = ["resnet50_1";"resnet50_2";"resnet50_3"];
Solver = ["sgdm";"sgdm";"sgdm"];
DatasetSize = [300;300;8000];
InputImageSize = [[224 224];[224 224];[224 224]];
ActivationLayer = ["activation_40_relu";"activation_40_relu";"activation_40_relu"];
MiniBatchSize = [32;10;10];
IterationRate = [1e-3;1e-3;1e-3];
AnchorBoxes = [25;15;23];
Accuracy = [7;11;57];
ap = [NaN;NaN;NaN];
trecall = [NaN; NaN; NaN];
precision = [NaN; NaN; NaN];
variable_names = {'Detectors','Solver','DatasetSize','InputImageSize','ActivationLayer','MiniBatchSize', 'IterationRate', 'AnchorBoxes', 'Accuracy', 'ap', 'trecall', 'precision'};
% var_names = {'Network' 'Layer of Activation' 'Mini Batch Size' 'Iteration Rate' 'Anchor Box Number' 'Layer' 'ap' 'recall' 'precision'};
detector_table = table(Detectors,Solver,DatasetSize,InputImageSize, ActivationLayer, MiniBatchSize, IterationRate, AnchorBoxes, Accuracy, ap, trecall, precision)

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