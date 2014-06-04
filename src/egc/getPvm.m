function [ pvm, pvmList ] = getPVM( c, n, set, pvm, pvmList)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
c = c(:, set);
n = n(:, set);
if size(pvm, 1) == 0
    pvmList = ones(1, size(set));
    pvm = [c; n];
else
    sizePvm1 = size(pvm,1);
    for i = 1:size(c,2)      
        sizePvm2 = size(pvm,2);
        found = false;
        for j = 1:sizePvm2
            if pvm(sizePvm1-1:sizePvm1,j) == c(:,i)
                pvm(sizePvm1+1:sizePvm1+2,j) = n(:,i);
                pvmList(sizePvm1/2, j) = 1;
                found =true;
                break;
            end
        end
        if ~found
            pvm(sizePvm1-1:sizePvm1+2,sizePvm2+1) = [c(:,i); n(:,i)];
            pvmList(sizePvm1/2, sizePvm2+1) = 1;
        end
    end
end
end