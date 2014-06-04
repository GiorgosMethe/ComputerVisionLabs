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
T = comBase - (comTarget * R');

end

