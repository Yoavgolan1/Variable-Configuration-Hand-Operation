function Angle_Instruction_Options = Create_Angle_Instruction_Options(Hand_Configuration,Angles)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

N_Fingers = length(Angles);
All_Combos = perms(1:N_Fingers-1);
N_Options = size(All_Combos,1);
Viability_Vector = ones(N_Options,1);
Initial_Angles = Hand_Configuration.Angles;
Initial_Angles = Rel2Abs_Angles(Initial_Angles');

Goal_Angles = Rel2Abs_Angles(Angles');
ChangeMat = zeros(size(All_Combos));

for ii=1:N_Options
    This_Combo = All_Combos(ii,:);
    Current_Angles = Initial_Angles;
    for jj=1:numel(This_Combo)
        Viability_Vector(ii) = Viability_Vector(ii)*...
            Check_Angle_Movement(Current_Angles,Goal_Angles,This_Combo(jj));
        Angle_Change = Goal_Angles(This_Combo(jj)) - Current_Angles(This_Combo(jj));
        ChangeMat(ii,jj) = Angle_Change;
        Current_Angles(This_Combo(jj)) = Goal_Angles(This_Combo(jj));
    end
end
Angle_Instruction_Options = [All_Combos,ChangeMat,Viability_Vector];

end

