function [] = moveToObjectCenter(object)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global robot 

[new_x,new_y] = pixelXY2GlobalXY(object.Centroid);
newPose = transl(new_x,new_y,Conveyor_Belt_Height+safe_height)*rotz(-90*pi/180);
robot.MoveL(newPose);

end 

