function [M,S] = sfm(D)
%% SVD to D matrix
[U,W,V] = svd(D);
%% First column from U, first element of W, first row of V
U3 = U(:,1:3);
W3 = W(1:3,1:3);
V3 = V(:,1:3)';
%% Obtain matrix Motion and Shape
M = U3 * sqrt(W3);
S = sqrt(W3) * V3;
%% affine ambiguity solution

[M,S] = noAmbiguity(M,S);


end