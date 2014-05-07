clear all
close all
clc

warning('off','all');
run('vlfeat-0.9.18/toolbox/vl_setup.m')
addpath('TeddyBear')
addpath('House')

I1 = imread('frame00000001.png');
I2 = imread('frame00000002.png');

figure
imshow(I1);

figure
imshow(I2);

%%compute SIFT frames and descriptors
[f1, d1] = vl_sift(single(I1));
[f2, d2] = vl_sift(single(I2));

[matches, scores] = vl_ubcmatch(d1, d2);

figure
imshow(uint8(I1));
hold on;
plot(f1(1,matches(1,:)),f1(2,matches(1,:)),'b*');

figure
imshow(uint8(I2));
hold on;
plot(f2(1,matches(2,:)),f2(2,matches(2,:)),'g*');