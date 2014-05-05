clear all
close all
clc

addpath /usr/local/share/flann/matlab/

% read arrays, clean Data
base = cleanData(readPcd('data/0000000001.pcd'));

tr = eye(4);
for frame = 2:2:98
    frame
    %% load target point cloud
    target = cleanData(readPcd(strcat('data/',num2str(frame,'%.10d'),'.pcd')));
    %% Iterative procedures
    [R, T, tr, target] = icp(tr, base, target);
    %% Merge the two point clouds
    base = cat(1, base, target);
end

figure
p = base';
plot3(p(1,:),p(2,:),p(3,:),'b.');
