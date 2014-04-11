clear all
clc

%identity matrix
R = eye(4);
t=0;



base = readPcd('data/0000000001.pcd');
target = readPcd('data/0000000002.pcd');

lenB = size(base,1);

target = target(:,[1:3])';

closestPoints = ones(lenB,2);

kdtree = vl_kdtreebuild(target);

for i=1:lenB
    x = base(i,1);
    y = base(i,2);
    z = base(i,3);
    
    Q = [x;y;z];
      tic
    [index, distance] = vl_kdtreequery(kdtree, target, Q,'MaxComparisons', 1) ;
      toc

   closestPoints(i,1) = index;
   closestPoints(i,2) = distance;
end