clear all
close all
clc

%% ================== SETTINGS ========================
% added filepath for flann library functions
addpath '../../data/icp/'
addpath '/usr/local/share/flann/matlab'
% search type: 0 brute, 1 unif sampling, 2 knn treesearch
searchType = 0;
% frameSkip: how many frame it'll skip
frameSkip = 10; % 1,2,4,10
% merged:true -- Merge pointclouds to base and compare to target
% merged:false -- Merge pointclouds to baseMerged and compare base to target all the time 
merged = false; % true, false
% Max iterations of icp
maxIter = 50;
%% ================= END SETTINGS=======================

%% read arrays, clean Data
base = cleanData(readPcd(strcat(num2str(1,'%.10d'),'.pcd')));

