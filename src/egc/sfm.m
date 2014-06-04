function [M,S] = sfm(D)
%D is a 2m x n matrix. (m images, n feature points)

%% center points in D
n = size(D,2);

for i=1:size(D,1)
    %calculate centroid of points for each image 
    lineSum = 0;
    times =0;
    for j=1:n
        if D(i,j)~=0
            lineSum = lineSum + D(i,j);
            times = times+1;
        end
    end
    centroid = lineSum/times;
    
    %subtract centroid from coords
    for q=1:n
        if D(i,q)~=0
            D(i,q)= D(i,q)-centroid;
        end
    end
end

%% factorize D
[U,W,V] = svd(D);
U3 = U(:,1:3);
W3 = W(1:3,1:3);
V3 = V(:,1:3)';

%% create motion and shape matrices
M = U3*sqrt(W3);
S = sqrt(W3)*V3;




end