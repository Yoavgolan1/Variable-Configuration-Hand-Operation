function [x,y,z] = getDropoffPosition(ith_Object_In_Series,Number_Of_New_Objects)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global RDK

Pallet_Frame = RDK.Item('Pallet');
Pallet_Pose = Pallet_Frame.PoseAbs();

row_iter = ith_Object_In_Series-1;
col_iter = Number_Of_New_Objects - 1;

row_displacement = 150; %mm
col_displacement = -200; %mm

x = Pallet_Pose(1,4) + row_iter*row_displacement;
y = Pallet_Pose(2,4) + col_iter*col_displacement;
z = Pallet_Pose(3,4);
end

