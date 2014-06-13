clear all
%close all
clc
% Warnings off
warning('off','all');
% run vl_setup, for vl functions
run('../../lib/vlfeat-0.9.18/toolbox/vl_setup.m')

addpath('../egc/');
addpath('../../data/TeddyBear/');
addpath('../../data/House/');
addpath('pvms');

%[ pvm , pvmList ] = chaining('House',8, 1000, 1.0);
%save('pvm8.mat','pvm')
%save('pvmList8.mat','pvmList')

%load mat file for teddy bear
 load('pvmList8.mat');
 load('pvm8.mat');

pvmListImg = mat2gray(pvmList, [0 1]);
pvmListImg = imresize(pvmListImg, [10000 size(pvmList,2)]);

% figure()
% imshow(pvmListImg);
% title('House DataSet')

%Construct matrix D for sfm
D = constructD(pvmList, pvm);
a = sum(pvmList,1);
indexes = find(a > 5);
D = pvm(:,indexes);
[M, S] = sfm(D);

figure
plot3(S(1,:),S(2,:),S(3,:),'b.', 'markersize', 10);

D = load('D.txt');
[M, S] = sfm(D);
figure
plot3(S(1,:),S(2,:),S(3,:),'r.');
