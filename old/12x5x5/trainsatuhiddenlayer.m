clearvars;
close all;
clc;

%% READ FILE
fileName = uigetfile('*.csv', 'Pilih file CSV yang berisi data training');
file = csvread(fileName);
[X, Y] = size(file);
class = categorical(file(:,1));
data = file(: , 2:Y);
numFeatures = size(data, 2);
numClasses = 2;


%% SETUP NEURAL NETWORK LAYERS
layers = [
    %input layer (360 Total Features)
    featureInputLayer(numFeatures)
    %hidden layer 1 (100 Neurons)
    fullyConnectedLayer(480)
    batchNormalizationLayer
    reluLayer
    %hidden layer 2 (50 Neurons)
%     fullyConnectedLayer(50)
%     batchNormalizationLayer
%     reluLayer
    %hidden layer 3 (50 Neurons)
%     fullyConnectedLayer(50)
%     batchNormalizationLayer
%     reluLayer
    %output neurons (Sesuai Jumlah Class : 2 Neurons)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

miniBatchSize = 16;

options = trainingOptions(...
    'adam', ... %Optimizer Function
    'MaxEpochs',100, ... %Training Cycle
    'MiniBatchSize',miniBatchSize, ... %Processed data per run
    'Shuffle','every-epoch', ... %Randomize data order every epoch
    'Plots','training-progress', ... %Display training progress window
    'Verbose',1 ... %Display Result on command window
    );

net = trainNetwork(data,class,layers,options);
network = net;
save('network.mat', 'network');

