clear all
close all
clc

warning('off','all');

run('../../lib/vlfeat-0.9.18/toolbox/vl_setup.m')

addpath('../egc/');
addpath('../../data/TeddyBear/');
addpath('../../data/House/');

[ pvm , pvmList ] = chaining('House');

%load mat file for teddy bear
% load('pvmList.mat');
% load('pvm.mat');

% pvmListImg = mat2gray(pvmList, [0 1]);
% pvmListImg = imresize(pvmListImg, [800 size(pvmList,2)]);
% 
% figure()
% imshow(pvmListImg);

%Construct matrix D for sfm
D = constructD(pvmList, pvm);
[M, S] = sfm(D);

figure
plot3(S(1,:),S(2,:),S(3,:),'b.');