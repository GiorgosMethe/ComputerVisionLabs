function[R, T, tr, target] = icp(tr, base, target)

% Initialize rotation, translation
rms = 0;

%% Update new target point cloud
R = tr(1:3, 1:3);
T = (tr(1:3,4))';
target = (R * target(:,1:3)')' + repmat(T,size(target,1),1);

for iterations=1:100
    %% Find Closest Points
    % Brute force
    %[baseCP, targetCP] = closestPoints(base, target, 0);
    % Uniform Sampling
    %[baseCP, targetCP] = closestPoints(base, target, 1, 10000);
    % KD-tree NN search
    [baseCP, targetCP] = closestPoints(base, target, 2);
    
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
    change = abs(oldRms - rms);
    if (change < 10e-5)
        break
    end
end
iterations
end
