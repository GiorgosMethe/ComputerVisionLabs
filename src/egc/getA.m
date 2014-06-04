function [ A ] = getA( p1, p2 )
%GETA Summary of this function goes here
%   Detailed explanation goes here
%%
x = p1(1,:);
xp = p2(1,:);
y = p1(2,:);
yp = p2(2,:);
%%
A = ones(size(p1,2), 9);
A(:,1) = x .* xp;
A(:,2) = x .* yp;
A(:,3) = x;
A(:,4) = y .* xp;
A(:,5) = y .* yp;
A(:,6) = y;
A(:,7) = xp;
A(:,8) = yp;
end

