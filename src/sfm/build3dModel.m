clear all;
close all;
clc
addpath('iso2mesh');

data = readPcd('johan_sundin.pcd');
dataCoords = data(:,[1:3]);
colors = data(:,[5:7]);
colors(:,:) = (((colors(:,:)+1).*255)/2)/255;%normalize to 0..1
dataCoords = imfill(dataCoords);

[t,tnorm]=MyRobustCrust(dataCoords);


%% plot the points cloud
figure(1);
set(gcf,'position',[0,0,1280,800]);
subplot(1,2,1)
hold on
axis equal
title('Points Cloud','fontsize',14)
plot3(dataCoords(:,1),dataCoords(:,2),dataCoords(:,3),'g.')
view(3);
axis vis3d


%% plot of the output triangulation
figure(1)
subplot(1,2,2)
hold on
title('Output Triangulation','fontsize',14)
axis equal
trisurf(t,dataCoords(:,1),dataCoords(:,2),dataCoords(:,3),'facecolor','b');
view(3);
axis vis3d
