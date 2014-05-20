clear all
close all
clc

warning('off','all');
if(ismac)
    run('vlfeat/toolbox/vl_setup.m')
else
    run('vlfeat-0.9.18/toolbox/vl_setup.m')
end
addpath('TeddyBear')
addpath('House')

nrFrames = 16;
%Initialize Point-View Matrix
tempPVM = [];
PVM = [];


RansacMaxIt = 100;
RansacThreshold = 1.0;

frames = [ 1:nrFrames, 1];
iteration = 0;
matrix = zeros(0,8);
for frame = 2:size(frames,2);
    %% Read images
    iteration = iteration+1;
    I1 = single(rgb2gray(imread(strcat('obj02_',num2str(frames(frame-1),'%.3d'),'.png'))));
    I2 = single(rgb2gray(imread(strcat('obj02_',num2str(frames(frame),'%.3d'),'.png'))));
    %     I1 = single(imread(strcat('frame',num2str(frames(frame-1),'%.8d'),'.png')));
    %     I2 = single(imread(strcat('frame',num2str(frames(frame),'%.8d'),'.png')));
    strcat(num2str(frames(frame-1),'%.8d'),'<-->',num2str(frames(frame),'%8d'))
    
    %% Sift
    [f1, d1] = vl_sift(I1);
    [f2, d2] = vl_sift(I2);
    
    %% Eliminate background
%     foreground1 = getForeground(I1);
%     foreground2 = getForeground(I2);
%     [f1, d1] = getForegroundPoints(f1, d1, foreground1);
%     [f2, d2] = getForegroundPoints(f2, d2, foreground2);
    
    %% Matches
    [matches, scores] = vl_ubcmatch(d1, d2);
    
    figure
    imshow(uint8(I1));
    hold on;
    plot(f1(1,matches(1,:)),f1(2,matches(1,:)),'b*');
    
    figure
    imshow(uint8(I2));
    hold on;
    plot(f2(1,matches(2,:)),f2(2,matches(2,:)),'g*');
    
    %% Ransac
    MaxInliersNum = -1;
    p1best = zeros(2,8);
    p2best = zeros(2,8);
    for it = 1:RansacMaxIt
        
        %% 8 random matches
        randomSelection = randsample(size(matches, 2), 8);
        matchesRan = matches(:,randomSelection);
        p1all = f1(1:2,matches(1,:));
        randomSelection = randsample(size(matches, 2), 8);
        matchesRan = matches(:,randomSelection);
        p1all = f1(1:2,matches(1,:));
        p2all = f2(1:2,matches(2,:));
        p1 = f1(1:2,matchesRan(1,:));
        p2 = f2(1:2,matchesRan(2,:));
        p2all = f2(1:2,matches(2,:));
        p1 = f1(1:2,matchesRan(1,:));
        p2 = f2(1:2,matchesRan(2,:));
        
        %% A
        A = getA(p1, p2);
        
        %% EightPoint
        F = eightPoint(A);
        F = normalizedEightPoint(p1, p2);
        
        %% Sampson distance
        D = sampsonDistance(p1all, p2all, F);
        inliers  = checkInliers(D, RansacThreshold);
        n = size(inliers, 1);
        if(n > MaxInliersNum)
            MaxInliersSet = inliers;
            MaxInliersNum = n;
            F_best(:,:,iteration) = F;
            p1best = p1;
            p2best = p2;
        end
    end
    MaxInliersNum
    [tempPVM,PVM] = getPVM(p1all,p2all,MaxInliersSet,tempPVM,PVM,frame);
end

    
% load('PVM.mat');
% load('tempPVM.mat');

pointScores = sum(PVM,1);
bestPointsIndexes = find(pointScores>3);

for frame = 2:size(frames,2);
    %% Read images
    iteration = iteration+1;
    %     I2 = single(imread(strcat('frame',num2str(frames(frame),'%.8d'),'.png')));
    I2 = single(rgb2gray(imread(strcat('obj02_',num2str(frames(frame),'%.3d'),'.png'))));
    figure()
    imshow(uint8(I2));
    hold on;
    plot(tempPVM((2*(frame-1))-1,bestPointsIndexes),tempPVM((2*(frame-1)),bestPointsIndexes),'b*');
end

