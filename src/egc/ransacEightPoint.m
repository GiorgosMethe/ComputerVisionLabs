function [ MaxInliersSet ] = ransacEightPoint( currAll, nextAll, normalized, RansacMaxIt, RansacThreshold )
%RANSACEIGHTPOINT Summary of this function goes here
%   Detailed explanation goes here
%% Ransac
MaxInliersNum = -1;
for it = 1:RansacMaxIt
    
    %% 8 random matches
    randomSelection = randsample(size(currAll,2), 8);
    p1 = currAll(:,randomSelection);
    p2 = nextAll(:,randomSelection);
    
    %% EightPoint
    if normalized
        F = normalizedEightPoint(p1, p2);
    else
        F = eightPoint(p1, p2);
    end
    
    %% Sampson distance
    D = sampsonDistance(currAll, nextAll, F);
    inliers  = checkInliers(D, RansacThreshold);
    n = size(inliers, 1);
    if(n > MaxInliersNum)
        MaxInliersSet = inliers;
        MaxInliersNum = n;
    end
end
end

