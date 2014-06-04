%% Choose folder you want to run chaining
addpath(strcat('../../data/','House'));
frameList = dir(strcat('../../data/','House'));
frameList = frameList(~[frameList.isdir]);

%% Load images
tic
disp('Loading images...')
for i = 1:size(frameList,1);
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
for frame=1:size(frameList,1);
    disp([num2str(frame) ,'/', num2str(size(frameList,1))]);
    % take the two images
    currFrame = Im(:,:,frame);
    % Compute Sift
    [fcurr, dcurr] = vl_sift(currFrame);
    % Filter matches
    [fcurr, dcurr] = getForegroundPoints(fcurr, dcurr, foreground);
    
    fcurrCenter = sum(fcurr,2) / size(fcurr,2);
    fcurrCenter(3:4) = [0; 0];
    fcurr = fcurr - repmat(fcurrCenter,1,size(fcurr,2));
    
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
for frame = 1:size(frames,2)-1;
    disp(['Frames: ', num2str(frames(frame)), '-->', num2str(frames(frame+1))]);
    tic
    fcurr = sift(frames(frame)).f;
    dcurr = sift(frames(frame)).d;
    fnext = sift(frames(frame+1)).f;
    dnext = sift(frames(frame+1)).d;
    % Compute matches
    [matches, scores] = vl_ubcmatch(dcurr, dnext);
    
    % Matches coordinates for the two images -- without not matched points
    currAll = fcurr(1:2,matches(1,:));
    nextAll = fnext(1:2,matches(2,:));
    
    % Ransac with eight point
    normalized = false;
    maxInlierSet = ransacEightPoint(currAll, nextAll, normalized, 1000, 1.9);
    
    % Chaining
    [pvm, pvmList] = getPvm(currAll, nextAll, maxInlierSet, pvm, pvmList);
    toc
    
    disp(['inliers number is:', num2str(size(maxInlierSet,1))]);
    disp('----');
    % showMatches(currFrame, nextFrame, currAll, nextAll, maxInlierSet);
end

%% Show points - cameras figure
pvmListImg = mat2gray(pvmList, [0 1]);
pvmListImg = imresize(pvmListImg, [800 size(pvmList,2)]);

figure()
imshow(pvmListImg);

%% Show points that follow enough frames -- from chaining matrix
% for frame = 1:size(frames,2)-1;
%     currFrame = Im(:,:,frames(frame));
%     figure()
%     imshow(uint8(currFrame));
%     hold on;
%     plot(pvm((2*(frame))-1,bestPointsIndexes),pvm((2*(frame)),bestPointsIndexes),'bo');
%     hold off;
%     pause(0.3);
% end

% end
