function [Path_Is_Good, Path] = Path_Within_Cube(Start, Target)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global Dimension Borders Movement_Vectors

Path = [];
Path_Is_Good = false;

ST_Euc = Target-Start;
Vec_Decomp = Movement_Vectors\ST_Euc'; %Same as inv(Movement_Vectors)*ST_Euc';
Full_Path_Vecs = Movement_Vectors.*repmat(Vec_Decomp, [1 Dimension]);
Vec_Perms = perms(1:Dimension);

for ii=1:length(Vec_Perms(:,1))
    This_Path = zeros(Dimension+1,Dimension);
    This_Perm = Vec_Perms(ii,:)';
    This_Movement_Vecs = Full_Path_Vecs(This_Perm,:);
    This_Path(1,:) = Start;
    for jj=2:Dimension+1
        This_Path(jj,:) = This_Path(jj-1,:)+This_Movement_Vecs(jj-1,:);
    end
    Points_To_Check = This_Path(2:end-1,:);
    Path_Is_Good = All_Points_In_HyperCube(Points_To_Check,Borders);
    if Path_Is_Good 
        Path = This_Path;
        %disp('Miracle!')
        %ii
        return
    end
end

end

