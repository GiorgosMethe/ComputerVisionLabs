function[baseCP, targetCP] = closestPoints(base, target, type, arg1)
%% Closest Points between base and target (bruteForce)
%closest points from source to target

%% brute force
if type == 0
    baseCP = base;
    targetCP = ones(size(base,1),3);
    %% uniform sampler
elseif type == 1
    sel = randsample(size(base,1),arg1);
    baseCP = base(sel,:);
end

%% search in target for closest points
for i=1:size(baseCP,1)
    minimum = +Inf;
    cIndex = -1;
    for j=1:size(target,1)
        dist = 0;
        for w=1:3
            dist = dist + ((baseCP(i,w)-target(j,w))*(baseCP(i,w)-target(j,w)));
        end
        dist = sqrt(dist);
        if dist<minimum
            minimum=dist;
            cIndex = j;
        end
    end
    %get coords from index.
    targetCP(i,1) = target(cIndex,1);
    targetCP(i,2) = target(cIndex,2);
    targetCP(i,3) = target(cIndex,3);
end
end

