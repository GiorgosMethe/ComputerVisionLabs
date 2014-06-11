function[R_tmp, T_tmp, tr, target,avgRMS] = icp(tr, base, target, type, maxIter)
oldchange = 10e6;
oldRms = 10e3;
%% Initialize rotation, translation
R_tmp = tr(1:3, 1:3);
T_tmp = (tr(1:3,4))';
%% Update new target point cloud
target = (R_tmp * target(:,1:3)')' + repmat(T_tmp,size(target,1),1);
sumRMS = 0;
for iterations=1:maxIter
    %% Find Closest Points
    [baseCP, targetCP] = closestPoints(base, target, type, 1000);
    %% Get transformation for Rotation, Translation through SVD
    [R_tmp, T_tmp] = getTransformation(baseCP, targetCP);
    %% Update tr
    tr = [R_tmp,T_tmp';0,0,0,1] * tr;
    %% Update target point cloud
    target = (R_tmp * target(:,1:3)')' + repmat(T_tmp,size(target,1),1);
    targetCP = (R_tmp * targetCP(:,1:3)')' + repmat(T_tmp,size(targetCP,1),1);
    %% Find Rms between base and target
    rms = getRms(baseCP, targetCP);
    sumRMS = sumRMS + rms;
    display(['iteration: ',num2str(iterations),', Error: ',num2str(rms)]);
    change = abs(oldRms - rms);
    if (change < 10e-5 || (rms > oldRms && change > oldchange * 3))
        break
    end
    oldRms = rms;
    oldchange = change;
end
avgRMS = sumRMS/iterations;
disp(['icp iterations:',num2str(iterations)]);
end
