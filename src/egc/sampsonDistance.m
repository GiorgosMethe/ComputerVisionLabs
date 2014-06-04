function [ d ] = sampsonDistance( p1, p2, F )
%SAMPSONDISTANCE Summary of this function goes here
%   Detailed explanation goes here
d = zeros(size(p1,2),1);
for i=1:size(p1,2)
    p = [p1(1,i); p1(2,i); 1];
    pp = [p2(1,i); p2(2,i); 1];
    
    n1 = (pp' * F * p)^2;
    
    d1 = F * p;
    d11 = d1(1)^2;
    d12 = d1(2)^2;
    
    d2 = transpose(F) * pp;
    d21 = d2(1)^2;
    d22 = d2(2)^2;
    
    d(i) = n1 / (d11 + d12 + d21 + d22);
end

end

