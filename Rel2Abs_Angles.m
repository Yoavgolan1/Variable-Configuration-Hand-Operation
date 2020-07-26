function [Abs_Angles] = Rel2Abs_Angles(Rel_Angles)
%REL2ABS_ANGLES takes relative finger angles and converts them to absolute.
%   Relative angles are the angles between each pair of adjacent fingers.
%   Absolute angles are the angles of each individual finger relative to
%   the thumb at 0. For example, [30 90 210] will be transformed into [30
%   120].
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

