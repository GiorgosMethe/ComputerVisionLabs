function [ A ] = getA( f1, f2, matches )
%GETA Summary of this function goes here
%   Detailed explanation goes here
%%
x = f1(1,matches(1,:));
xp = f2(1,matches(2,:));
y = f1(2,matches(1,:));
yp = f2(2,matches(2,:));
%%
A = ones(size(matches,2), 9);
A(:,1) = x .* xp;
A(:,2) = x .* yp;
A(:,3) = x;
A(:,4) = y .* xp;
A(:,5) = y .* yp;
A(:,6) = y;
A(:,7) = xp;
A(:,8) = yp;
end

