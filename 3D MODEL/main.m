% m x n cell (m images ,n features)


%% normalize points in each view

m = size(X,1);
n = size(X,2);

%sum for each row
sumEveryRow = sum(X,2);

for i =1:m
    sumThisRow = sumEveryRow(i);
    X(i,:) = X(i,:) - (1/n)*sumThisRow;
end

%koliles.