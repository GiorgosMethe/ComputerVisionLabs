function [ F ] = eightPoint( A )
%EIGHTPOINT Summary of this function goes here
%   Detailed explanation goes here
[~, D, V] = svd(A);

[~,index] = min(diag(D));
F = V(:,index);

F = reshape(F,3,3);
[Uf, Df, Vf] = svd(F);

[~,indexF] = min(diag(Df));
Dfp = Df;
Dfp(indexF,indexF) = 0;

F = Uf * Dfp * Vf';
F = reshape(F,9,1);
end

