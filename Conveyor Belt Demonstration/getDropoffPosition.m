function [x,y,z,z_rotation] = getDropoffPosition(ith_Object_In_Series,Number_Of_New_Objects,object_type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global RDK
if nargin < 3
    z_rotation = 0;
    object_type = [];
end
if isempty(object_type)
    z_rotation = 0;
end

Pallet_Frame = RDK.Item('Pallet');
Pallet_Pose = Pallet_Frame.PoseAbs();

row_iter = ith_Object_In_Series-1;
col_iter = Number_Of_New_Objects - 1;

row_displacement = 210; %mm
col_displacement = -160; %mm

x = Pallet_Pose(1,4) + row_iter*row_displacement;
y = Pallet_Pose(2,4) + col_iter*col_displacement;
z = Pallet_Pose(3,4);

if isempty(object_type)
    return
end
object_name = object_type.Name;

switch object_name
    case 'Pipe_T'
        z_rotation = deg2rad(-5);
    case 'Pipe_90'
        z_rotation = deg2rad(0);
    case 'Pipe_45'
        z_rotation = deg2rad(15);
    case 'Pipe_Straight'
        z_rotation = deg2rad(-40);
    otherwise
        z_rotation = deg2rad(0);
end

end

