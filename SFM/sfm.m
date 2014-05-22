clear all;
close all;
clc
addpath('iso2mesh');

data = readPcd('johan_sundin.pcd');
data = data(:,[1:3]);

data = imfill(data);

[t,tnorm]=MyRobustCrust(data);


%% plot the points cloud
figure(1);
set(gcf,'position',[0,0,1280,800]);
subplot(1,2,1)
hold on
axis equal
title('Points Cloud','fontsize',14)
plot3(data(:,1),data(:,2),data(:,3),'g.')
view(3);
axis vis3d


%% plot of the output triangulation
figure(1)
subplot(1,2,2)
hold on
title('Output Triangulation','fontsize',14)
axis equal
trisurf(t,data(:,1),data(:,2),data(:,3),'facecolor','c','edgecolor','b')
view(3);
axis vis3d
