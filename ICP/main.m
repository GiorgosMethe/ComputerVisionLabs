clear all
close all
clc

%% added filepath for flann library functions
addpath /usr/local/share/flann/matlab/
addpath flann

%% read arrays, clean Data
base = cleanData(readPcd(strcat('data/',num2str(1,'%.10d'),'.pcd')));
base1 = base;
tr = eye(4);
for frame = 2:5:98
    frame
    %% load target point cloud
    target = cleanData(readPcd(strcat('data/',num2str(frame,'%.10d'),'.pcd')));
    %% Iterative procedures
    [R, T, tr, target] = icp(tr, base, target);
    %% New target
    base = target;
    %% For question 2.1 -- create a merged point cloud with all frames
    base1 = cat(1, base1, target);
    %% For question 2.2 -- merge the two point clouds
    %base = cat(1, base, target);
end
%% Show final result
figure
p = base1';
plot3(p(1,:),p(2,:),p(3,:),'b.');
