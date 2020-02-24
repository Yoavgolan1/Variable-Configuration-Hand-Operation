function [Exists] = Check_Angle_Movement(Current_Angles,Goal_Angles,N)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
N_Fingers = numel(Goal_Angles)+1;
COMB = nchoosek(1:N_Fingers-1,2);
Buffer = 45;
Exists = 1;
Target_Angle_Diff = abs(Current_Angles(N)-Goal_Angles(N));
Checks_To_Make = ceil(Target_Angle_Diff/(Buffer-1))+1;
Angles_To_Check = round(linspace(Current_Angles(N),Goal_Angles(N),Checks_To_Make));
N_Checks = numel(Angles_To_Check);
List_Of_Angles = repmat(Current_Angles,N_Checks,1);
for ii=1:N_Checks
    List_Of_Angles(ii,N)=Angles_To_Check(ii);
    if ~Angles_Are_Legal(List_Of_Angles(ii,:),COMB)
        Exists = 0;
        return;
    end
end