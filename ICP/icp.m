function[R, T, RMS] = icp(base, target)
%% Arguments

%INPUT
%base = Nx3 matrix
%target = Nx3 matrix
%OUTPUT
%R = rotation matrix
%T = translation matrix
%RMS = root mean square error of distance between base and target

%% Closest Points between base and target

% lengths
lenB = size(base,1);
lenT = size(target,1);

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
cp =importdata('cp.mat');
%% Center of mass

sum = zeros(1,3);
for i=1:lenB
    sum = sum + base(i,1:3);
end
comBase = sum / lenB;

sum = zeros(1,3);
for i=1:lenT
    sum = sum + target(i,1:3);
end
comTarget = sum / lenT;

%% subtract center of masses

baseNor = base(:,1:3) - repmat(comBase,lenB,1);
targetNor = target(:,1:3) - repmat(comBase,lenT,1);

%% SVD
A = zeros(3,3);
  for i= 1:lenB
    A = A + (baseNor(i,:)' * targetNor(cp(i,1),:));
 end
[U,S,V] = svd(A);

%% Rotation matrix

R = U * transpose(V);

%% Translation matrix

T = comBase - comTarget * R;

%% New target cloud

newTarget = (R * base(:,1:3)')' + repmat(T,lenB,1);

%% RMS0
for i = 1:lenB
   sumRMS = (sqrt((base(i,1)-newTarget(i,1))^2+(base(i,2)-newTarget(i,2))^2+(base(i,3)-newTarget(i,3))^2))^2;
   %2-norm (euclidean) - den eimai sigouros an einai ayto pou prepei.(paris) 
end 
RMS = sqrt(mean(sumRMS));



















