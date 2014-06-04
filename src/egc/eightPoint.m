function [ F ] = eightPoint( p1, p2 )
%EIGHTPOINT Summary of this function goes here
%   Detailed explanation goes here
A = getA(p1, p2);

[~, D, V] = svd(A);

[~,index] = min(diag(D));
F = V(:,index);

F = reshape(F,3,3);
[Uf, Df, Vf] = svd(F);

[~,indexF] = min(diag(Df));
Dfp = Df;
Dfp(indexF,indexF) = 0;

F = Uf * Dfp * Vf';
end

