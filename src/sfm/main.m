clear all
close all
clc
% Warnings off
warning('off','all');
% run vl_setup, for vl functions
run('../../lib/vlfeat-0.9.18/toolbox/vl_setup.m')

addpath('../egc/');
addpath('../../data/TeddyBear/');
addpath('../../data/House/');
addpath('pvms');

[ pvm , pvmList ] = chaining('TeddyBear',1, 200, 4.0);

%Construct matrix D for sfm
D = constructD(pvmList, pvm);
a = sum(pvmList,1);
% Value to be changed in respect to the number of frames and how many frames we skip
% Should be the same as the number of frames.
indexes = find(a > 3);
D = pvm(:,indexes);
[M, S] = sfm(D);

figure
plot3(S(1,:),S(2,:),S(3,:),'b.', 'markersize', 10);
