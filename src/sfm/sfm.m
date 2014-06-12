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
% compute G,c
G = [gT(M(1:2:end,:),M(1:2:end,:)); gT(M(2:2:end,:),M(2:2:end,:)); gT(M(1:2:end,:),M(2:2:end,:))];
c = [ones(size(M,1),1); zeros(size(M,1)/2,1)];

% get l matrix
l = G\c;

% get L matrix (3x3 == A^TA)
L = [l(1:3)'; l(2),l(4),l(5); l(3),l(5),l(6)];
    
% get A matrix.
A = chol(L,'lower');

%Updating M and S
M = M*A;
S = A\S;

end