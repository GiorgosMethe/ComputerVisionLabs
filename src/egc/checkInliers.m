function [inliers] = checkInliers( D, threshold )
%CHECKINLIERS Summary of this function goes here
%   Detailed explanation goes here

inliers = find(D < threshold);

% for k=1:size(inliers,1)
%     matches(k,:) = [p2all(inliers(1,k)),p2all(inliers(2,k))];
% end
% matches = p2all(:,inliers);

n = size(inliers, 1);
end

