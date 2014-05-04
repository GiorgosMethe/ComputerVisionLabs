function[R, T] = icp(base, target)

%% Initialize rotation, translation
R = eye(3, 3);
T = zeros(1, 3);
tr = eye(4);
rms = 0;

for i=1:100
    tr = [R,T';0,0,0,1] * tr;
    %% New transformed target cloud
    target = (R * target(:,1:3)')' + repmat(T,size(target,1),1);
    
    %% Find Closest Points
    %[base, target] = closestPoints(base, target, 0);
    %[base, target] = closestPoints(base, target, 1, 1000);
    [base, target] = closestPoints(base, target, 2, 0);
    
    %% Get transformation for Rotation, Translation through SVD
    [R, T] = getTransformation(base, target);
    
    %% Find Rms between base and target
    oldRms = rms;
    rms = getRms(base, target);
    if (abs(oldRms - rms) < 10e-15)
        break
    end
%     %% show initial pointclouds
%     if(i == 1)
%         p=base';
%         p1=target';
%         figure
%         hold on
%         title(rms)
%         scatter3(p(1,:),p(2,:),p(3,:),'bo');
%         scatter3(p1(1,:),p1(2,:),p1(3,:),'r+');
%         hold off
%     end
end
% %% show final pointclouds
% p=base';
% p1=target';
% figure
% hold on
% title(rms)
% scatter3(p(1,:),p(2,:),p(3,:),'bo');
% scatter3(p1(1,:),p1(2,:),p1(3,:),'r+');
% hold off

R = tr(1:3, 1:3);
T = (tr(1:3,4))';
end
