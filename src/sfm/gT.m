function [gT] = gT(af, bf)
    gT = [af(:,1).*bf(:,1), af(:,1).*bf(:,2)+af(:,2).*bf(:,1), af(:,1).*bf(:,3)+af(:,3).*bf(:,1),af(:,2).*bf(:,2), af(:,2).*bf(:,3)+af(:,3).*bf(:,2), af(:,3).*bf(:,3)];
end