function [Rel_Angles] = Abs2Rel_Angles(Abs_Angles)
%ABS2REL_ANGLES converts digit absolute angles into relative angles in rad
%   For example, [45 180] will be converted to [0.7854; 2.3562; 3.1416]
N_Fingers = length(Abs_Angles)+1;
Rel_Angles = zeros(N_Fingers,1);
Abs_Angles = [0,Abs_Angles,360];
for ii=2:N_Fingers+1
    Rel_Angles(ii-1) = Abs_Angles(ii) - Abs_Angles(ii-1);
end
Rel_Angles = deg2rad(Rel_Angles);
end

