function [] = moveToObject(object,location)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global robot
if nargin < 1
    location = 'Centroid';
end
switch location
    case 'Centroid'
        [new_x,new_y] = pixelXY2GlobalXY(object.Centroid);
    case 'Hand Center'
        
        [new_x,new_y] = pixelXY2GlobalXY(object.Centroid);
    otherwise
        error('Unrecognized command')
end

newPose = transl(new_x,new_y,Conveyor_Belt_Height+safe_height)*rotz(-90*pi/180);
robot.MoveL(newPose);

end

