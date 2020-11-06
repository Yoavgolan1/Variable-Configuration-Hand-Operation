function [] = moveToObjectCenter(object)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global robot 

[new_x,new_y] = pixelXY2GlobalXY(object.Centroid);
currentPose = robot.Pose();
newPose = currentPose;
newPose(1,4) = new_x;
newPose(2,4) = new_y;
robot.MoveJ(newPose);

end 

