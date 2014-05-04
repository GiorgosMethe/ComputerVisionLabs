clear all
close all
clc

addpath /usr/local/share/flann/matlab/

% read arrays
base = readPcd('data/0000000001.pcd');
%clean Data
base = cleanData(base);

tr = eye(4);
for i = 2:4:99
    i
    %% load target point cloud
    target = cleanData(readPcd(strcat('data/',num2str(i,'%.10d'),'.pcd')));
    %% Iterative procedures
    R = tr(1:3, 1:3);
    T = (tr(1:3,4))';
    target = (R * target(:,1:3)')' + repmat(T,size(target,1),1);
    [R, T] = icp(base, target);
    tr = [R,T';0,0,0,1] * tr;
    base = cat(1, base, target);
end

figure
p = base';
plot3(p(1,:),p(2,:),p(3,:),'bo');
