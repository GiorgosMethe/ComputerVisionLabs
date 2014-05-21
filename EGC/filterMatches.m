function [ matches ] = filterMatches( matches, scores, threshold )
%FILTERMATCHES Summary of this function goes here
%   Detailed explanation goes here
best = find(scores < threshold);
matches = matches(:,best);
end

