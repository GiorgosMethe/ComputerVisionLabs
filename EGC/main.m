clear all
clc

warning('off','all');
if(ismac)
    run('vlfeat/toolbox/vl_setup.m')
else
    run('vlfeat-0.9.18/toolbox/vl_setup.m')
end
addpath('TeddyBear')
addpath('House')

nrFrames = 49;
%Initialize Point-View Matrix
tempPVM = [];
PVM = [];


RansacMaxIt = 100;
RansacThreshold = 0.01;

frames = [ 1:nrFrames, 1];
iteration = 0;
for frame = 2:size(frames,2);
    %% Read images
    iteration = iteration+1;
    I1 = single(imread(strcat('frame',num2str(frames(frame-1),'%.8d'),'.png')));
    I2 = single(imread(strcat('frame',num2str(frames(frame),'%.8d'),'.png')));
    strcat('frame',num2str(frames(frame-1),'%.8d'),' <--> ', 'frame',num2str(frames(frame),'%.8d'))
    
    %% Sift
    [f1, d1] = vl_sift(I1);
    [f2, d2] = vl_sift(I2);
    
    %% Matches
    [matches, scores] = vl_ubcmatch(d1, d2);
    
    %% Ransac
    MaxInliersNum = -1;
    for it = 1:RansacMaxIt
        
        %% 8 random matches
        randomSelection = randsample(size(matches, 2), 8);
        matchesRan = matches(:,randomSelection);
        p1all = f1(1:2,matches(1,:));
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
        end
    end    
    
    tempPVM = getPVM(p1all,p2all,MaxInliersSet,tempPVM,PVM);
end





