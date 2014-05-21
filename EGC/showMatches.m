function [ ] = showMatches( currFrame, nextFrame, currAll, nextAll, maxInlierSet )
%SHOWMATCHES Summary of this function goes here
%   Detailed explanation goes here
% Create a new image showing the two images side by side.
img = [currFrame, nextFrame];

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(img,2) size(img,1)]);
colormap('gray');
imagesc(img);
hold on;
plot(currAll(1,:), currAll(2,:), 'bo');
plot(nextAll(1,:)+size(currFrame,2), nextAll(2,:), 'bo');
if size(maxInlierSet,1) > 0
    tit = ['Inliers num:',num2str(size(maxInlierSet,1)),' out of:', num2str(size(currAll,2))];
    title(tit)
    for k = 1: size(maxInlierSet,1)
        i = maxInlierSet(k);
        line([currAll(1,i) nextAll(1,i)+size(currFrame,2)], [currAll(2,i) nextAll(2,i)], 'Color', 'r');
        plot(currAll(1,i), currAll(2,i), 'ro');
        plot(nextAll(1,i)+size(currFrame,2), nextAll(2,i), 'ro');
    end
else
    title(['Matches num:', num2str(size(currAll,2))])
    for i = 1: size(currAll,2)
        line([currAll(1,i) nextAll(1,i)+size(currFrame,2)], [currAll(2,i) nextAll(2,i)], 'Color', 'r');
    end
end
hold off;
end

