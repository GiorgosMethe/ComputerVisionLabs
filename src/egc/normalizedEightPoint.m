function [ F ] = normalizedEightPoint( p1, p2 )
%NORMALIZEDEIGHTPOINT Summary of this function goes here
%   Detailed explanation goes here
[p1, T1] = normalizePoints(p1);
[p2, T2] = normalizePoints(p2);

p1 = p1(1:2,:);
p2 = p2(1:2,:);

Fn = eightPoint(p1, p2);
Fn = reshape(Fn, 3, 3);

F = T2' * Fn * T1;
end

