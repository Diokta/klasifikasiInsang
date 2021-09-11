close all;
clearvars;
clc;

load network.mat;
[file,path] = uigetfile('*.csv', 'PILIH CSV FILE (KOLOM PERTAMA ADALAH CLASS NYA)');
rawData = csvread([path, file]);
[X, Y] = size(rawData);
class = categorical(rawData(:,1));
data = rawData(: , 2:Y);

YPred = classify(network,data);
gab = [class , YPred];
acc = sum(YPred == class)/numel(class);

Test_File = [path, file]
Total_Data = X
Accuracy = [num2str(acc*100), '%']


