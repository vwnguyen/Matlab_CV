% resnet_1 = load('YOLOv2_MBSize_32_MaxEpoch_25_InitLearnRate_1e-3_NumAnchors_25_Acc_7.mat');
% resnet_1 = resnet_1.detector;
% resnet_2 = load('YOLOv2_MBSize_10_MaxEpoch_20_InitLearnRate_1e-3_NumAnchors_15_Acc_11.mat');
% resnet_2 = resnet_2.detector;
%% Make table with made detectors
Detectors = ["resnet_1";"resnet_2"]
ActivationLayer = ['activation_40_relu';'activation_40_relu'];
MiniBatchSize = [32;10];
IterationRate = [1e-3;1e-3];
AnchorBoxes = [25;15];
Accuracy = [7;11];
ap = [NaN;NaN];
trecall = [NaN; NaN];
precision = [NaN; NaN];
variable_names = {'Detectors','ActivationLayer','MiniBatchSize', 'IterationRate', 'AnchorBoxes', 'Accuracy', 'ap', 'trecall', 'precision'};
% var_names = {'Network' 'Layer of Activation' 'Mini Batch Size' 'Iteration Rate' 'Anchor Box Number' 'Layer' 'ap' 'recall' 'precision'};
detector_table = table(Detectors, ActivationLayer, MiniBatchSize, IterationRate, AnchorBoxes, Accuracy, ap, trecall, precision)

%% Add another row to an existing table
% this will be exported since all variable names between tables have to be the same 
variable_names = {'Detectors','ActivationLayer','MiniBatchSize', 'IterationRate', 'AnchorBoxes', 'Accuracy', 'ap', 'trecall', 'precision'};
% add_on = {"resnet_3","activation_40_relu",40,0.001,4,54,NaN,NaN,NaN}; %ex
% this will be the way we will append the cell in the script but we have to
% make sure that the 
%% Convert Cell into Table
% add_Table = cell2table(add_on,'VariableNames', var_names)
%% Append two tables together
% detector_table = [detector_table;add_Table]