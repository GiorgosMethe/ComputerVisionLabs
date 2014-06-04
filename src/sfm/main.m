clear all
close all
clc

warning('off','all');

run('../../lib/vlfeat-0.9.18/toolbox/vl_setup.m')

addpath('../egc/');
addpath('../../data/TeddyBear/');
addpath('../../data/House/');

% [ pvm , pvmList ] = chaining('House');


pvmListImg = mat2gray(pvmList, [0 1]);
pvmListImg = imresize(pvmListImg, [800 size(pvmList,2)]);

figure()
imshow(pvmListImg);





[M, S] = sfm(pvmList);
