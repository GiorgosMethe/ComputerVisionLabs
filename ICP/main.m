clear all
close all
clc

%% added filepath for flann library functions
addpath /usr/local/share/flann/matlab/

%% read arrays, clean Data
base = cleanData(readPcd(strcat('data/',num2str(1,'%.10d'),'.pcd')));
base1 = base;
tr = eye(4);
for frame = 2:2:98
    frame
    %% load target point cloud
    target = cleanData(readPcd(strcat('data/',num2str(frame,'%.10d'),'.pcd')));
    %% Iterative procedures
    [R, T, tr, target] = icp(tr, base, target);
    %% Merge the two point clouds
    base = target;
    base1 = cat(1, base1, target);
end

figure
p = base1';
plot3(p(1,:),p(2,:),p(3,:),'b.');
