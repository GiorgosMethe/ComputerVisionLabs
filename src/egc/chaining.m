function [ pvm, pvmList ] = chaining(frames_dir, frameStep, ransacMaxIter, ransacThres)

%% Choose folder you want to run chaining
addpath(strcat('../../data/',frames_dir));
frameList = dir(strcat('../../data/',frames_dir));
frameList = frameList(~[frameList.isdir]);

%% Load images
tic
disp('Loading images...')
for i = 1:6;
    img = imread(frameList(i).name);
    if size(img,3) == 3
        img = rgb2gray(img);
    end
    Im(:,:,i) = single(img);
    disp([num2str(i) ,'/', num2str(size(frameList,1))]);
end
disp('Finish loading images...')
toc

%% Extract foreground via active contour
disp('Extracting foreground...')
foreground = getForeground(Im(:,:,1));
disp('Finish extracting foreground...')

tic
disp('Extracting sift features...')
for frame=1:6;
    disp([num2str(frame) ,'/', num2str(size(frameList,1))]);
    %% take the image
    currFrame = Im(:,:,frame);
    %% Compute Sift
    [fcurr, dcurr] = vl_sift(currFrame,'edgethresh', 30, 'Levels', 30);
%         [fcurr, dcurr] = vl_sift(currFrame);
    %% Filter matches
    [fcurr, dcurr] = getForegroundPoints(fcurr, dcurr, foreground);
    %% Normalize data
    fcurrCenter = sum(fcurr,2) / size(fcurr,2);
    fcurrCenter(3:4) = [0; 0];
    fcurr = fcurr - repmat(fcurrCenter,1,size(fcurr,2));
    %% set data to be used later
    set.f = fcurr;
    set.d = dcurr;
    sift(frame) = set;
end
disp('Finish extracting sift features...')
toc

%% Show points - cameras figure
pvm = [];
pvmList = [];
frames = [ 1:size(frameList,1), 1];
for frame = 1:5;
    disp(['Frames: ', num2str(frames(frame)), '-->', num2str(frames(frame+frameStep))]);
    tic
    fcurr = sift(frames(frame)).f;
    dcurr = sift(frames(frame)).d;
    fnext = sift(frames(frame+frameStep)).f;
    dnext = sift(frames(frame+frameStep)).d;
    %% Compute matches
    [matches, ~] = vl_ubcmatch(dcurr, dnext);
    %% Matches coordinates for the two images -- without not matched points
    currAll = fcurr(1:2,matches(1,:));
    nextAll = fnext(1:2,matches(2,:));
    %% Ransac with eight point
    normalized = false;
    maxInlierSet = ransacEightPoint(currAll, nextAll, normalized, ransacMaxIter, ransacThres);
    %% Chaining
    [pvm, pvmList] = getPvm(currAll, nextAll, maxInlierSet, pvm, pvmList);
    %% Display and visualization of inliers' set
    disp(['inliers number is:', num2str(size(maxInlierSet,1))]);
%     showMatches(Im(:,:,frame), Im(:,:,frame+frameStep), currAll, nextAll, maxInlierSet);
    toc
    disp('----');
end

%% Show points - cameras figure
pvmListImg = mat2gray(pvmList, [0 1]);
pvmListImg = imresize(pvmListImg, [10000 size(pvmList,2)]);
figure()
imshow(pvmListImg);

end


