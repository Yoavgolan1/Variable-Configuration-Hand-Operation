function [Answer] = All_Points_In_HyperCube(Points,Borders)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Answer = true;
if isempty(Points)
    Answer = false;
    return
end

Dim = length(Points(1,:));

Mins = Borders(:,1)';
Maxs = Borders(:,2)';

Big_Mins = repmat(Mins,[length(Points(:,1)),1]);
Big_Maxs = repmat(Maxs,[length(Points(:,1)),1]);

Min_Compare = Points<Big_Mins;
Max_Compare = Points>Big_Maxs;

Min_Is_Bad = max(max(Min_Compare));
Max_Is_Bad = max(max(Max_Compare));

Is_Bad = max([Min_Is_Bad,Max_Is_Bad]);

Answer = ~Is_Bad;

end

