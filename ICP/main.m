clear all
close all
clc

% read arrays
base = readPcd('data/0000000001.pcd');
target = readPcd('data/0000000002.pcd');
%clean Data
base = cleanData(base);
target = cleanData(target);
base = base(1:3000,:);
target = target(1:3000,:);
%% Iterative procedure
[R, T] = icp(base, target);

target = (R * target(:,1:3)')' + repmat(T,size(target,1),1);
base = cat(1, base, target);