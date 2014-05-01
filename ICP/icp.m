function[Rot, Tra] = icp(base, target)

%% Initialize rotation, translation
Rot = eye(3, 3);
Tra = zeros(1, 3);

for i=1:20
    %% New transformed target cloud
    base = (Rot * base(:,1:3)')' + repmat(Tra,size(base,1),1);
    
    %% Find Closest Points
    matchedPoints = closestPoints(base, target);
    
    %% Get transformation for Rotation, Translation through SVD
    [Rot, Tra] = getTransformation(matchedPoints, base);
    
    %% Find Rms between base and target
    rms = getRms(base, target);
    rms
    
    p=base';
    p1=target';
    figure
    hold on
    title(rms)
    scatter3(p(1,:),p(2,:),p(3,:),'bo');
    scatter3(p1(1,:),p1(2,:),p1(3,:),'r+');
    hold off
end

function[cp] = closestPoints(base, target)
%% Closest Points between base and target (bruteForce)
%closest points from source to target
cp = ones(size(base,1),3);
% find close points
for i=1:size(base,1)
    minimum = +Inf;
    cIndex = -1;
    for j=1:size(target,1)
        dist = 0;
        for w=1:3
            dist = dist + ((base(i,w)-target(j,w))*(base(i,w)-target(j,w)));
        end
        dist = sqrt(dist);
        if dist<minimum
            minimum=dist;
            cIndex = j;
        end
    end
    %get coords from index.
    cp(i,1) = target(cIndex,1);
    cp(i,2) = target(cIndex,2);
    cp(i,3) = target(cIndex,3);
end

function[R, T] = getTransformation(base, target)
%% Arguments

%INPUT
%base = Nx3 matrix
%target = Nx3 matrix
%OUTPUT
%R = rotation matrix
%T = translation matrix
%RMS = root mean square error of distance between base and target

%% Center of mass
comBase = sum(base)/ size(base,1);
comTarget = sum(target) / size(target,1);

%% subtract center of masses
baseNor = base(:,1:3) - repmat(comBase,size(base,1),1);
targetNor = target(:,1:3) - repmat(comTarget,size(target,1),1);

%% SVD
A = baseNor' * targetNor;
[U,S,V] = svd(A);

%% Rotation matrix
R = U * transpose(V);

%% Translation matrix
T = comBase * R - comTarget;

function[Rms] = getRms(base, target)
%% RMS
sumRms = sum(power((base-target), 2));
Rms = sqrt(mean(sumRms));



















