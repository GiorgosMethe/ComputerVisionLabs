clear all
close all
clc

matlabpool ('open',4);
set = [1 2 4 10];
parfor exp = 1:4
%================== SETTINGS ========================
%% added filepath for flann library functions
addpath '../../data/icp/'
addpath '/usr/local/share/flann/matlab'
%% search type: 1 brute, 2 unif sampling, 3 knn treesearch
searchType = 3;
%% frameSkip: how many frame it'll skip
frameSkip = set(exp);
%% merged:true -- Merge pointclouds to base and compare to target
%% merged:false -- Merge pointclouds to baseMerged and compare base to target all the time 
merged = true;
%% Max iterations of icp
maxIter = 50;
%================= END SETTINGS=======================

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

parsave(strcat('errors',num2str(set(exp)), '.mat'), errors);
parsave(strcat('tr',num2str(set(exp)), '.mat'), tr);
parsave(strcat('resultedPointCloud',num2str(set(exp)), '.mat'), resultedPointCloud);

end

matlabpool close;
