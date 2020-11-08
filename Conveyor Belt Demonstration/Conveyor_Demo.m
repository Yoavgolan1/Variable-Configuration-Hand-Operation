clear all
close all
%% Initialization

global Hand_Configuration MODE Grasp_Finger_Placements Best_Config ...
    Hand_Center_Finger_Center_Dist Finger_Radius N_Fingers...
    CONVEYOR_SPEED cam one_mm_is_X_pixels;

one_mm_is_X_pixels = (640-18)/420;

% The initial hand configuration
N_Fingers = 3;
Finger_Radius = 10; %mm
Hand_Center_Finger_Center_Dist = 70; %Constant, dependent of finger type
Hand_Configuration.Distances = [94; 50; 60;]+Hand_Center_Finger_Center_Dist; %Set the distances of the fingers from the min point
Hand_Configuration.Angles = deg2rad([45; 45; 270]); %Initial angles, relative %was 45 45 270???
Hand_Configuration.Center = [0,0];
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles'); %Initial angles, absolute

%Run mode - simulation only, or run on robot
MODE = 'SIMULATION';
%MODE = 'REAL_ROBOT'; %Uncomment this line to run on the robot. This
%assumes that what we perceive as real life is not actually a simulation.

%Initialize Arduino microcontroller and RoboDK robot simulator
a = InitArduino('COM7'); %Requires MATLAB Arduino Addon in REAL_ROBOT mode, and a connected Arduino Nano
b = InitArduino_Conveyor('COM4');
Robot_COM = 'COM2';
InitRoboDK_Conveyer();

%% Start motion
CONVEYOR_SPEED = 20; %mm/sec
setConveyorBeltSpeed(b,CONVEYOR_SPEED);
robot.MoveJ(Above_Conveyor_Belt,1);
cam = webcam(2);

%% Task 1 - Palletize distinct items
Current_Object_Type = [];
new_type_of_object = false;
Total_Number_Of_Objects = 5;
for ii=1:Total_Number_Of_Objects
    [~,~] = waitForConveyorObject(0.95);
    setConveyorBeltSpeed(b,0);
    pause(0.2);
    [object, object_type] = waitForConveyorObject();
    new_type_of_object = ~isequal(object_type.Name,Current_Object_Type);
    if new_type_of_object
        Current_Object_Type = object_type.Name;
        [Best_Config, Distance_Instructions] = ...
        Find_Easiest_Reconfig(Hand_Configuration, object_type.Possible_Hand_Configs);
        Instructions = Instruction_Blender(Distance_Instructions,Hand_Configuration,Best_Config.Angles);
        Execute_Instructions(Instructions,'ROBOT_BODY',a);
    end
    
    [GC_x, GC_y, GC_theta] = getHandCenterInWorldFrame(object,object_type);
    Above_Object_Position = transl(GC_x,GC_y,Conveyor_height+safe_height)*roty(0)*rotz(GC_theta);
    robot.MoveL(robot.Pose*rotz(Base_Finger_Angle_World))
    Amount_Opened = Open_or_Close_Hand(a,'OPEN');
    robot.setSpeed(Slow_Speed);
    
end