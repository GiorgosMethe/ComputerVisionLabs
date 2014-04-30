function[Rot, Tra] = icp(base, target)

%% Initialize rotation, translation
Rot = eye(3, 3);
Tra = zeros(1, 3);

for i=1:4
    %% New transformed target cloud
    newTarget = (Rot * base(:,1:3)')' + repmat(Tra,size(base,1),1);

    %% Find Closest Points
    matchedPoints = closestPoints(newTarget, target);
    
    %% Get transformation for Rotation, Translation through SVD
    [Rot, Tra] = getTransformation(matchedPoints, base);
    
    %% Find Rms between base and target
    rms = getRms(newTarget, matchedPoints);
end

function[cp] = closestPoints(base, target)
%% Closest Points between base and target (bruteForce)
% lengths
% lenB = size(base,1);
% lenT = size(target,1);
% closest points from source to target
% cp = ones(lenB,2);
% % find close points
% for i=1:lenB
%    minimum = +Inf;
%    cIndex = -1;
%    for j=1:lenT
%       xB = base(i,1);
%       xT = target(j,1);
%       yB = base(i,2);
%       yT = target(j,2);
%       zB = base(i,3);
%       zT = target(j,3);
%       dist = sqrt((xB-xT)^2+(yB-yT)^2+(zB-zT)^2);
%       
%       if dist<minimum
%          minimum=dist; 
%          cIndex = j;
%       end
%    end
%    cp(i,1) = cIndex;
%    cp(i,2) = minimum;
% end
kres =importdata('cp.mat');
cp = target(kres(:,1),:);

function[Rms] = getRms(base, target)
%% RMS
sumRms = sum(power((base-target), 2));
Rms = sqrt(mean(sumRms));

function[R, T] = getTransformation(base, target)
%% Arguments

%INPUT
%base = Nx3 matrix
%target = Nx3 matrix
%OUTPUT
%R = rotation matrix
%T = translation matrix
%RMS = root mean square error of distance between base and target

% lengths
lenB = size(base,1);
lenT = size(target,1);


%% Center of mass
comBase = sum(base)/lenB;
comTarget = sum(target) / lenT;

%% subtract center of masses

baseNor = base(:,1:3) - repmat(comBase,lenB,1);
targetNor = target(:,1:3) - repmat(comBase,lenT,1);

%% SVD
A = baseNor' * targetNor;
[U,S,V] = svd(A);

%% Rotation matrix

R = U * transpose(V);

%% Translation matrix

T = comBase - comTarget * R;


















