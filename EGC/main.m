clear all
close all
clc

warning('off','all');
run('vlfeat-0.9.18/toolbox/vl_setup.m')
addpath('TeddyBear')
addpath('House')

I1 = imread('frame00000001.png');
I2 = imread('frame00000002.png');

[f1, d1] = vl_sift(single(I1));
[f2, d2] = vl_sift(single(I2));

[matches, scores] = vl_ubcmatch(d1, d2);

best = find(scores < 3000);
matches = matches(:,best);
p1 = f1(1:2,matches(1,:));
p2 = f2(1:2,matches(2,:));

%% Figures
figure
imshow(uint8(I1));
hold on;
plot(p1(1,:),p1(2,:),'r.');

figure
imshow(uint8(I2));
hold on;
plot(p2(1,:),p2(2,:),'r.');

%% A
A = getA(p1, p2);
%% SVD
F = eightPoint(A);
%% Normalization
%F_norm = normalize(F);
[p1, T1] = normalizePoints(p1);
[p2, T2] = normalizePoints(p2);

p1 = p1(1:2,:);
p2 = p2(1:2,:);

An = getA(p1, p2);
Fn = eightPoint(An);
Fn = reshape(Fn, 3, 3);

F1 = T2' * Fn * T1;



