function[baseCP, targetCP] = closestPoints(base, target, type, arg1)
%% Closest Points between base and target (bruteForce)
%closest points from source to target

%% brute force
if type == 0
    baseCP = ones(size(target,1),3);
    targetCP = target;
    for i=1:size(targetCP,1)
        minimum = +Inf;
        cIndex = -1;
        for j=1:size(base,1)
            dist = 0;
            for w=1:3
                dist = dist + ((targetCP(i,w)-base(j,w))*(targetCP(i,w)-base(j,w)));
            end
            dist = sqrt(dist);
            if dist<minimum
                minimum=dist;
                cIndex = j;
            end
        end
        %get coords from index.
        baseCP(i,1) = base(cIndex,1);
        baseCP(i,2) = base(cIndex,2);
        baseCP(i,3) = base(cIndex,3);
    end
    
    %% uniform sampler
elseif type == 1
    baseCP = ones(arg1,3);
    sel = randsample(size(target,1),arg1);
    targetCP = target(sel,:);
    for i=1:size(targetCP,1)
        minimum = +Inf;
        cIndex = -1;
        for j=1:size(base,1)
            dist = 0;
            for w=1:3
                dist = dist + ((targetCP(i,w)-base(j,w))*(targetCP(i,w)-base(j,w)));
            end
            dist = sqrt(dist);
            if dist<minimum
                minimum=dist;
                cIndex = j;
            end
        end
        %get coords from index.
        baseCP(i,1) = base(cIndex,1);
        baseCP(i,2) = base(cIndex,2);
        baseCP(i,3) = base(cIndex,3);
    end
    %% KD-tree search
elseif type == 2
    % perform the nearest-neighbor search
    params.algorithm = 'kdtree';
    params.trees = 8;
    params.checks = 64;
    % perform the nearest-neighbor search
    [result, ~] = flann_search(base',target',1,params);
    baseCP = base(result',:);
    targetCP = target;
end
end

