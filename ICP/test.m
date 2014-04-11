clc 
clear all

X = rand(2,100);
kdtree = vl_kdtreebuild(X);
Q = [0.6596;0.5186];
%Q = rand(2,1);
[index, distance] = vl_kdtreequery(kdtree, X, Q) ;