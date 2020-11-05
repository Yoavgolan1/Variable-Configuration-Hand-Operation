clear all
close all
%% Initialization

global Hand_Configuration MODE Grasp_Finger_Placements Best_Config ...
    Hand_Center_Finger_Center_Dist Finger_Radius N_Fingers...
    CONVEYOR_SPEED cam;

% The initial hand configuration
N_Fingers = 4;
Finger_Radius = 10; %mm
Hand_Center_Finger_Center_Dist = 70; %Constant, dependent of finger type
Hand_Configuration.Distances = [94; 50; 60; 30]+Hand_Center_Finger_Center_Dist; %Set the distances of the fingers from the min point
Hand_Configuration.Angles = deg2rad([45; 45; 90; 180]); %Initial angles, relative %was 45 45 270???
Hand_Configuration.Center = [0,0];
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles'); %Initial angles, absolute

%Run mode - simulation only, or run on robot
MODE = 'SIMULATION';
%MODE = 'REAL_ROBOT'; %Uncomment this line to run on the robot. This
%assumes that what we perceive as real life is not actually a simulation.

%Initialize Arduino microcontroller and RoboDK robot simulator
a = InitArduino('COM7'); %Requires MATLAB Arduino Addon in REAL_ROBOT mode, and a connected Arduino Nano
b = InitArduino_Conveyor('COM4');
InitRoboDK_Conveyer();

%% Start motion
CONVEYOR_SPEED = 50; %mm/sec
setConveyorBeltSpeed(b,CONVEYOR_SPEED);
robot.MoveJ(Above_Conveyor_Belt);

cam = webcam(2);

[~,~] = waitForConveyorObject(0.95);
setConveyorBeltSpeed(b,0);
pause(0.2);
[object, object_type] = waitForConveyorObject();





