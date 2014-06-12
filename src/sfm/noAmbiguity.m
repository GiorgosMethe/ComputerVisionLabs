function [M,S] = noAmbiguity(M,S)

% compute G,c
G = [gT(M(1:2:end,:),M(1:2:end,:)); gT(M(2:2:end,:),M(2:2:end,:)); gT(M(1:2:end,:),M(2:2:end,:))];
c = [ones(size(M,1),1); zeros(size(M,1)/2,1)];

% get l matrix
l = G\c;

% get L matrix (3x3 == A^TA)
L = [l(1:3)'; l(2),l(4),l(5); l(3),l(5),l(6)];
    
% get A matrix.
A = chol(L,'lower');

% new M & S
M = M*A;
S = A\S;

end