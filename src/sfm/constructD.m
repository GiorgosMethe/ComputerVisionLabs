function [ D ] = constructD(pvmIndexes, pvm)
%Construct matrix D to feed to sfm

%find indexes that contains the point across all frames 
indexList = all(pvmIndexes);
indexes = find(indexList);
D = pvm(:, indexes);
end

