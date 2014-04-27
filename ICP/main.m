clear all
close all
clc

% read arrays
base = readPcd('data/0000000001.pcd');
target = readPcd('data/0000000002.pcd');
%clean Data
base = cleanData(base);
target = cleanData(target);
%Plot data-optional
% plot3(base(1,:),base(2,:),base(3,:),'bo');

%% Iterative procedure
[R, T] = icp(base, target);










