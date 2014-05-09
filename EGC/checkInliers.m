function [ n ] = checkInliers( D, threshold )
%CHECKINLIERS Summary of this function goes here
%   Detailed explanation goes here
inliers = find(D < threshold);
n = size(inliers, 1);
end

