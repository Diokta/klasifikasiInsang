close all;
clearvars;
clc;

load network.mat;
[file,path] = uigetfile('*.csv', 'PILIH CSV FILE (KOLOM PERTAMA ADALAH CLASS NYA)');
rawData = csvread([path, file]);
[X, Y] = size(rawData);
class = categorical(rawData(:,1));
data = rawData(: , 2:Y);

err = crossval('mse', data, class, 'Predfun',);

function YPred = pred(network, data)
    YPred = classify(network,data);
end    