function [ points, T ] = normalizePoints( points )
%NORMALIZEPOINTS Summary of this function goes here
%   Detailed explanation goes here
mx = mean(points(:,1));
my = mean(points(:,2));
d = sum(sqrt(points(:,1) - mx).^2 + (points(:,2) - my).^2) / size(points,2);
T = [sqrt(2)/d 0 -mx*sqrt(2)/d; 0 sqrt(2)/d -my*sqrt(2)/d; 0 0 1];
points = T * [points; ones(1, size(points,2))];
end

