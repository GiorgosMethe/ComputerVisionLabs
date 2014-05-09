clear all
clc

warning('off','all');
if(ismac)
    run('vlfeat/toolbox/vl_setup.m')
else
    run('vlfeat-0.9.18/toolbox/vl_setup.m')
end
addpath('TeddyBear')
addpath('House')

I1 = imread('frame00000001.png');
I2 = imread('frame00000002.png');

%% Sift
[f1, d1] = vl_sift(single(I1));
[f2, d2] = vl_sift(single(I2));
%% Matches
[matches, scores] = vl_ubcmatch(d1, d2);
%% Best Matches
best = find(scores < 3000);
matches = matches(:,best);
p1 = f1(1:2,matches(1,:));
p2 = f2(1:2,matches(2,:));

%% A
A = getA(p1, p2);
%% EightPoint
F = eightPoint(A);
F = normalizedEightPoint(p1, p2);

%% Sampson distance
for i=1:size(matches,2)
   p1hm = [p1(1,i) p1(2,i) 1];
   p2hm = [p2(1,i) p2(2,i) 1];
end






