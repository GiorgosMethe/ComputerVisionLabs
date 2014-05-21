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

disp('Loading images...')
for i = 1:size(frameList,1);
    img = imread(frameList(i).name);
    if size(img,3) == 3
        img = rgb2gray(img);
    end
    I(:,:,i) = single(img);
    disp([num2str(i) ,'/', num2str(size(frameList,1))]);
end
disp('Finish loading images...')

frames = [ 1:size(frameList,1), 1];
foreground = getForeground(I(:,:,1));

pvm = [];
pvmList = [];
for frame = 1:size(frames,2)-1;
    disp([num2str(frames(frame)), '-->', num2str(frames(frame+1))]);
    tic
    %% take the two images
    currFrame = I(:,:,frames(frame));
    nextFrame = I(:,:,frames(frame+1));
    
    %% Compute Sift
    [fcurr, dcurr] = vl_sift(currFrame);
    [fnext, dnext] = vl_sift(nextFrame);
    
    %% Filter matches
%     [fcurr, dcurr] = getForegroundPoints(fcurr, dcurr, foreground);
%     [fnext, dnext] = getForegroundPoints(fnext, dnext, foreground);
    
    %% Compute matches
    [matches, scores] = vl_ubcmatch(dcurr, dnext);
    
    %% Matches coordinates for the two images -- without not matched points
    currAll = fcurr(1:2,matches(1,:));
    nextAll = fnext(1:2,matches(2,:));
    
    %% Ransac with eight point
    normalized = true;
    maxInlierSet = ransacEightPoint(currAll, nextAll, normalized, 1000, 1.9);
    
    %% Make 
    [pvm, pvmList] = getPvm(currAll, nextAll, maxInlierSet, pvm, pvmList);
    toc
    
    disp(['inliers number is:', num2str(size(maxInlierSet,1))]);
%     showMatches(currFrame, nextFrame, currAll, nextAll, maxInlierSet);
end

pvmListImg = mat2gray(pvmList, [0 1]);
pvmListImg = imresize(pvmListImg, [800 size(pvmList,2)]);
figure
imshow(pvmListImg);

%% Show points that follow enough frames -- chaining
pointScores = sum(pvmList,1);
bestPointsIndexes = find(pointScores>40);

for frame = 1:size(frames,2)-1;
    currFrame = I(:,:,frames(frame));
    figure()
    imshow(uint8(currFrame));
    hold on;
    plot(pvm((2*(frame))-1,bestPointsIndexes),pvm((2*(frame)),bestPointsIndexes),'bo');
    hold off;
    pause(0.5);
end



