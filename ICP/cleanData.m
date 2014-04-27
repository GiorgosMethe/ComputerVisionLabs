function[cleanedData] = cleanData(data)

%remove 4th column
data(:,4) = [];
% filter array
filterIndexdata = data(:,3) < 2;
cleanedData = data(filterIndexdata,:);
