function[R, T] = icp(base, target)

%% Initialize rotation, translation
R = eye(3, 3);
T = zeros(1, 3);

for i=1:20
    %% New transformed target cloud
    base = (R * base(:,1:3)')' + repmat(T,size(base,1),1);
    
    %% Find Closest Points
    %[baseCP, targetCP] = closestPoints(base, target, 0);
    [base, target] = closestPoints(base, target, 1, 1000);
    
    %% Get transformation for Rotation, Translation through SVD
    [R, T] = getTransformation(target, base);
    
    %% Find Rms between base and target
    rms = getRms(base, target);
    
    p=base';
    p1=target';
    figure
    hold on
    title(rms)
    scatter3(p(1,:),p(2,:),p(3,:),'bo');
    scatter3(p1(1,:),p1(2,:),p1(3,:),'r+');
    hold off
end
