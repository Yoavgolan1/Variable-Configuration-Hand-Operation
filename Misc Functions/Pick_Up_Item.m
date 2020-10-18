function [] = Pick_Up_Item(Active_Object,a)
%PICK_UP_ITEM commands the system to pick up a specific item.
%   This function works in either simulation or run-on-robot mode. Note
%   that the object in the simulation is not oriented correctly. To do
%   this, the model needs to be manually calibrated to settle it's angle
%   respective to the hand (will be done for some objects in future
%   versions).
global robot safe_height Neutral_Position tool Normal_Speed Slow_Speed Grasp_Finger_Placements

Base_Finger_XY_Rel = Grasp_Finger_Placements(1,:);
Base_Finger_Angle_World = atan2(Base_Finger_XY_Rel(2),Base_Finger_XY_Rel(1));

robot.MoveL(Active_Object.Above_Frame.Pose*rotz(Base_Finger_Angle_World))
Amount_Opened = Open_or_Close_Hand(a,'OPEN');
robot.setSpeed(Slow_Speed);
robot.MoveL(robot.Pose()*transl(0,0,-safe_height+10))
Open_or_Close_Hand(a,'CLOSE',Amount_Opened);
attached_item = tool.AttachClosest();
if attached_item.Valid()
    attachedname = attached_item.Name();
    fprintf('Attached: %s\n', attachedname);
    Active_Object.Above_Frame.setParentStatic(Active_Object.Item);
else
    % The tolerance can be changed in:
    % Tools->Options->General tab->Maximum distance to attach an object to
    % a robot tool (default is 1000 mm)
    fprintf('No object is close enough\n');
end
robot.setSpeed(Normal_Speed)
robot.MoveL(Neutral_Position);
end

