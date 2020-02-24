function [] = Drop_Off_Item(Object,a, Location)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
global robot RDK station Normal_Speed Slow_Speed safe_height Neutral_Position
if nargin < 3
    Location = transl(-540,-900,20);
end
Above_Location = Location*transl(0,0,safe_height);
robot.MoveJ(Above_Location);
robot.setSpeed(Slow_Speed);
robot.MoveL(Location);
Amount_Opened = Open_or_Close_Hand(a,'OPEN');
Object.Item.setParentStatic(station);
Robot_Base = RDK.Item('Motoman UP6 Base');
Object.Above_Frame.setParentStatic(Robot_Base);
%Object.Above_Frame.setPose();
robot.MoveL(Above_Location);
robot.setSpeed(Normal_Speed);
robot.MoveJ(Neutral_Position);

end

