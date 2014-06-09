function[R, T, tr, target,avgRMS] = icp(tr, base, target, type, maxIter)

% Initialize rotation, translation
rms = 0;

%% Update new target point cloud
R = tr(1:3, 1:3);
T = (tr(1:3,4))';
target = (R * target(:,1:3)')' + repmat(T,size(target,1),1);
sumRMS = 0;

for iterations=1:maxIter
    %% Find Closest Points
    
    if type == 1
        %% Brute force
        [baseCP, targetCP] = closestPoints(base, target, 0);
    elseif type == 2
        %% Uniform Sampling
        [baseCP, targetCP] = closestPoints(base, target, 1, 1000);
    elseif type == 3
        %% KD-tree NN search
        [baseCP, targetCP] = closestPoints(base, target, 2);
    end
    
    %% Get transformation for Rotation, Translation through SVD
    [R, T] = getTransformation(baseCP, targetCP);
    %% Update tr
    tr = [R,T';0,0,0,1] * tr;
    %% Update target point cloud
    target = (R * target(:,1:3)')' + repmat(T,size(target,1),1);
    targetCP = (R * targetCP(:,1:3)')' + repmat(T,size(targetCP,1),1);
    %% Find Rms between base and target
    oldRms = rms;
    rms = getRms(baseCP, targetCP);
    sumRMS = sumRMS+rms;
    change = abs(oldRms - rms);
    if (change < 10e-5)
        break
    end
end
avgRMS = sumRMS/100;
disp(['icp iterations:',num2str(iterations)]);
end
