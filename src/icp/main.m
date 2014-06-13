clear all
close all
clc

% matlabpool ('open',4);
set = [1 2 4 10 1 2 4 10];
me = [true false];

%parfor exp = 1:8
%% ================== SETTINGS ========================
% added filepath for flann library functions
addpath '../../data/icp/'
addpath '/usr/local/share/flann/matlab'
% search type: 0 brute, 1 unif sampling, 2 knn treesearch
searchType = 1;
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
baseMerged = base;
tr = eye(4);
errors = [];
disp(['Starting icp...']);
for frame = 1+frameSkip:frameSkip:99
    disp(['frame:',num2str(frame)]);
    %% load target point cloud
    target = cleanData(readPcd(strcat(num2str(frame,'%.10d'),'.pcd')));
    %% Iterative procedures
    tic
    [R, T, tr, target,avgRMS] = icp(tr, base, target, searchType, maxIter);
    toc
    %% For question 2.1 -- create a merged point cloud with all frames
    if (merged == false)
        base = target;
        baseMerged = cat(1, baseMerged, target);
    %% For question 2.2 -- merge the two point clouds
    else
        base = cat(1, base, target);
    end
    errors = [errors avgRMS];
end
%% Set final result
if (merged == false)
    resultedPointCloud = baseMerged';
else
    resultedPointCloud = base;
end
% figure()
% bar(errors)
%% Visualize pointcloud
% figure()
% plot3(resultedPointCloud(1,:),resultedPointCloud(2,:),resultedPointCloud(3,:),'b.');
% disp(['Done']);

parsave(strcat('errors',num2str(set(exp)),'_',num2str(merged), '.mat'), errors);
parsave(strcat('tr',num2str(set(exp)),'_',num2str(merged), '.mat'), tr);
parsave(strcat('resultedPointCloud',num2str(set(exp)),'_',num2str(merged), '.mat'), resultedPointCloud);

% end

matlabpool close;
