function [] = Reorient_Finger(fingerid,newangle,resdeg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global digits robot tool station RDK safe_height
if nargin < 3
    resdeg = 0;
end
Finger = RDK.Item('Finger_3');
Fingertip = RDK.Item('Fingertip_3');
if fingerid==3 && newangle==0
    Finger.setVisible(false);
    Fingertip.setVisible(false);
    if length(digits)~=3
        digits(:,4)=[];
    end
    return
elseif fingerid==3 && length(digits)==3
    Finger.setVisible(true);
    Fingertip.setVisible(true);
    digits(4).id = 3;
    digits(4).distance = 50;
    digits(4).angle = 270;
    return
end
oldangle = digits(fingerid+1).angle;
current_joints = robot.Joints();
global pre_press_position_transl press_position_transl
pre_press_position = pre_press_position_transl*roty(0*pi/180)*rotz((-oldangle-45)*pi/180);

robot_location = robot.Pose();
if isequal(round(robot_location(:,end)),round(pre_press_position(:,end)))
    robot.MoveJ(pre_press_position);
elseif robot.MoveL_Test(current_joints, pre_press_position,10) == 0
    robot.MoveL(pre_press_position);
else
    robot.MoveJ(pre_press_position);
end
robot.setSpeed(10,10);    %Set to slower speed
press_position = press_position_transl*roty(0*pi/180)*rotz((-oldangle-45)*pi/180);
robot.MoveL(press_position,1);

switch fingerid
    case 1
        Finger = RDK.Item('Finger_1');
        Fingertip = RDK.Item('Fingertip_1');
    case 2
        Finger = RDK.Item('Finger_2');
        Fingertip = RDK.Item('Fingertip_2');
    case 3
        Finger = RDK.Item('Finger_3');
        Fingertip = RDK.Item('Fingertip_3');
    otherwise
        disp('Bad finger ID');
end

Finger.setParentStatic(station);
Fingertip.setParentStatic(station);

rotated_position = press_position_transl*roty(0*pi/180)*rotz((-newangle-45)*pi/180);
robot.MoveL(rotated_position,1);

Finger.setParentStatic(tool);
Fingertip.setParentStatic(tool);
digits(fingerid+1).angle = newangle;


final_position = pre_press_position_transl*roty(0*pi/180)*rotz((-newangle-45)*pi/180);
robot.MoveL(final_position);

robot.setSpeed(100,100);

end

