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


frameList = dir('TeddyBear');
frameList = frameList(~[frameList.isdir]);

disp('loading')
for i = 1:size(frameList,1);
    img = imread(frameList(i).name);
    if size(img,3) == 3
        img = rgb2gray(img);
    end
    I(:,:,i) = single(img);
    disp([num2str(i) ,'/', num2str(size(frameList,1))]);
end
disp('Done')

frames = [ 1:size(frameList,1), 1];
foreground = getForeground(I(:,:,1));

for frame = 1:size(frames,2)-1;
    disp([num2str(frames(frame)), '-->', num2str(frames(frame+1))])
    tic
    %% take the two images
    currFrame = I(:,:,frames(frame));
    nextFrame = I(:,:,frames(frame+1));
    
    %% Compute Sift
    [fcurr, dcurr] = vl_sift(currFrame);
    [fnext, dnext] = vl_sift(nextFrame);
    
    %% Filter matches
    [fcurr, dcurr] = getForegroundPoints(fcurr, dcurr, foreground);
    [fnext, dnext] = getForegroundPoints(fnext, dnext, foreground);
    
    %% Compute matches
    [matches, scores] = vl_ubcmatch(dcurr, dnext);
    
    %% Matches coordinates for the two images -- without not matched points
    currAll = fcurr(1:2,matches(1,:));
    nextAll = fnext(1:2,matches(2,:));
    
    %% Ransac with eight point
    maxInlierSet = ransacEightPoint(currAll, nextAll, 100, 0.01);
    toc
    
    disp(['inliers number is:', num2str(size(maxInlierSet,1))]);
    showMatches(currFrame, nextFrame, currAll, nextAll);
end
