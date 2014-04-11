clear all
close all
clc

% read arrays
base = readPcd('data/0000000001.pcd');
target = readPcd('data/0000000002.pcd');
% filter base array
filterIndexBase = find(base(:,3) < 2);
base = base(filterIndexBase,:);
% filter target array
filterIndexTarget = find(target(:,3) < 2);
target = target(filterIndexTarget,:);

% lengths
lenB = size(base,1);
lenT = size(target,1);
% closest points from source to target
cp = ones(lenB,2);
% %% find close points
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


%% find center of mass

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

figure()
hold on
scatter3(base(:,1), base(:,2), base(:,3));
scatter3(comBase(:,1), comBase(:,2), comBase(:,3),'r');
hold off


figure()
hold on
scatter3(target(:,1), target(:,2), target(:,3));
scatter3(comTarget(:,1), comTarget(:,2), comTarget(:,3),'r');
hold off


%% subtract center of masses
baseNor = base(:,1:3) - repmat(comBase,lenB,1);
targetNor = target(:,1:3) - repmat(comBase,lenT,1);

figure()
hold on
scatter3(baseNor(:,1), baseNor(:,2), baseNor(:,3));
hold off

figure()
hold on
scatter3(targetNor(:,1), targetNor(:,2), targetNor(:,3));
hold off

%% 
A = zeros(3,3);
for i= 1:lenB
    A = A + (baseNor(i,:)' * targetNor(cp(i,1),:));
end


%% SVD
[U,S,V] = svd(A);

%% Rotation matrix
R = U * transpose(V);

%% Translation matrix
T = comBase - comTarget * R;

%% New target cloud
newTarget = (R * base(:,1:3)')' + repmat(T,lenB,1);

%% RMS
RMS = 0;
for i = 1:lenB
   RMS = RMS + sqrt() 
end 










