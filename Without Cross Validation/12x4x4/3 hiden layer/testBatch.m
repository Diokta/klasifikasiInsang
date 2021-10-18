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

tp = sum((YPred == "1")&(YPred == class)); %benar segar
fp = sum((YPred == "1")&(YPred ~= class)); %salah segar
tn = sum((YPred == "2")&(YPred == class)); %benar tidak segar
fn = sum((YPred == "2")&(YPred ~= class)); %salah tidak segar

matrix = [tp, fn; fp, tn];
cm= confusionchart(matrix, {'Segar','Tidak Segar'});
cm.Title = 'Confusion Matrix';
