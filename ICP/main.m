clear all
close all
clc

% read arrays
base = readPcd('data/0000000001.pcd');
target = readPcd('data/0000000002.pcd');
%clean Data
base = cleanData(base);
target = cleanData(target);
base = base(1:1000,:);
target = target(1:1000,:);
%% Iterative procedure
[R, T] = icp(base, target);










