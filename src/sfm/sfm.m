function [M,S] = sfm(D)

%% center points in D
n = size(D,2);

%% Apply SVD
[U,W,V] = svd(D);

U3 = U(:,1:3);
W3 = W(1:3,1:3);
V3 = V(:,1:3)';

%% Obtain matrix Motion and Shape
M = U3 * sqrt(W3);
S = sqrt(W3) * V3;

end