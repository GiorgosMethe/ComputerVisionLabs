clear all
close all
clc

% read arrays
base = readPcd('data/0000000001.pcd');
target = readPcd('data/0000000002.pcd');
%remove 4th column
base(:,4) = [];
target(:,4) = [];
% filter base array
filterIndexBase = find(base(:,3) < 2);
base = base(filterIndexBase,:);
% filter target array
filterIndexTarget = find(target(:,3) < 2);
target = target(filterIndexTarget,:);

%ta evala se function xous
%[R, T, RMS] = icp(base, target);
cp =importdata('cp.mat');










