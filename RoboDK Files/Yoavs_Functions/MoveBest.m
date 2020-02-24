function [] = MoveBest(newpos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global robot
current_joints = robot.Joints();
if robot.MoveL_Test(current_joints, newpos) == 0
    robot.MoveL(newpos);
else
    robot.MoveJ(newpos);
end

end

