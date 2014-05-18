function [ tempPVM,PVM ] = getPVM( p1all,p2all,inliers,tempPVM,PVM,frame)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

matchedPointsP1 = p1all(:,inliers);
matchedPointsP2 = p2all(:,inliers);

sizeTemp = size(tempPVM,2);
sizep1matched = size(matchedPointsP1,2);

found = false;
for i=1:sizep1matched
    for j = 1:sizeTemp
        if matchedPointsP1(1,i) == tempPVM(1,j) && matchedPointsP1(2,i) == tempPVM(2,j)  
            found = true;
            break;
        end
    end
    if found==true
        tempPVM(:,j) = matchedPointsP2(:,i);
        PVM(frame-1,j) = 1;
    else
        tempPVM(:,sizeTemp+1) = matchedPointsP2(:,i);
        sizeTemp = size(tempPVM,2);
        PVM(frame-1,size(PVM,2)+1) =1;
    end
end












end

