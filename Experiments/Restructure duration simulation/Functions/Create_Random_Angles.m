function [Random_Angles] = Create_Random_Angles(dim)
%CREATE_RANDOM_ANGLES creates random, legal, absolute finger angles.
buffer = 45;
Random_Angles = 0;
while ~Random_Angles
    attempt = buffer + (360-buffer*2)*rand(1,dim-1);
    attempt = sort(attempt);
    diffs = abs(attempt(1:end-1)-attempt(2:end));
    if dim==2
        Random_Angles = attempt;
        continue
    end
    if min(diffs)>buffer
        Random_Angles = attempt;
    end
end
end

