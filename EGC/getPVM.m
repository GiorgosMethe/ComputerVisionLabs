function [ tempPVM,PVM ] = getPVM( p1all,p2all,inliers,tempPVM,PVM,frame)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

matchedPointsP1 = p1all(:,inliers);
matchedPointsP2 = p2all(:,inliers);


sizep1matched = size(matchedPointsP1,2);
sizeTempRows = size(tempPVM,1);
for i=1:sizep1matched
    found = false;

    sizeTemp = size(tempPVM,2);
    
    if sizeTemp >1 && sizeTempRows > 1
        for j = 1:sizeTemp
            if matchedPointsP1(1,i) == tempPVM(sizeTempRows-1,j) && matchedPointsP1(2,i) == tempPVM(sizeTempRows,j)
                found = true;
                break;
            end
        end
    else
        tempPVM((2*(frame-1))-1,i) = matchedPointsP2(1,i);
        tempPVM((2*(frame-1)),i) = matchedPointsP2(2,i);
    end
    if found==true
        tempPVM((2*(frame-1))-1,j) = matchedPointsP2(1,i);
        tempPVM((2*(frame-1)),j) = matchedPointsP2(2,i);
        PVM(frame-1,j) = 1;
    else
        tempPVM((2*(frame-1))-1,sizeTemp+1) = matchedPointsP2(1,i);
        tempPVM((2*(frame-1)),sizeTemp+1) = matchedPointsP2(2,i);
        sizeTemp = size(tempPVM,2);
        PVM(frame-1,size(PVM,2)+1) =1;
    end
end












end

