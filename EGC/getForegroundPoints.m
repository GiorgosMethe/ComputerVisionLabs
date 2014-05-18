function [ f_Points, f_Features ] = getForegroundPoints( points, features, foreground )

pos = zeros(1,size(points,2));
for i=1:size(points,2)
    x = floor(points(2,i));
    y = floor(points(1,i));
    if (foreground(x,y) == 1)
        pos(i) = 1;
    end
    
end


f_Points = points(:,find(pos));
f_Features = features(:,find(pos));
end

