function [ ] = showMatches( currFrame, nextFrame, currAll, nextAll )
%SHOWMATCHES Summary of this function goes here
%   Detailed explanation goes here
% Create a new image showing the two images side by side.
img = [currFrame, nextFrame];

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img,2) size(img,1)]);
colormap('gray');
imagesc(img);
hold on;
for i = 1: size(currAll,2)
     line([currAll(1,i) nextAll(1,i)+size(currFrame,2)], [currAll(2,i) nextAll(2,i)], 'Color', 'c');
end
plot(currAll(1,:), currAll(2,:), 'bo');
plot(nextAll(1,:)+size(currFrame,2), nextAll(2,:), 'ro');
hold off;
end

