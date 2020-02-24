function [Abs_Angles] = Rel2Abs_Angles(Rel_Angles)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[N_Options, N_Fingers] = size(Rel_Angles);

Abs_Angles = zeros(N_Options,N_Fingers);
for ii=1:N_Options
    for jj=2:N_Fingers
        Abs_Angles(ii,jj) = Abs_Angles(ii,jj-1) + Rel_Angles(ii,jj-1);
    end
end
Abs_Angles = Abs_Angles(:,2:end);
Abs_Angles = rad2deg(Abs_Angles);

end

