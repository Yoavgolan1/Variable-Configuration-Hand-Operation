clear all
close all
instrreset
%% Initialization

global Hand_Configuration MODE Grasp_Finger_Placements Best_Config ...
    Hand_Center_Finger_Center_Dist Finger_Radius N_Fingers...
    CONVEYOR_SPEED cam one_mm_is_X_pixels;

one_mm_is_X_pixels = (640-18)/420;

% The initial hand configuration
N_Fingers = 3;
Finger_Radius = 10; %mm
Hand_Center_Finger_Center_Dist = 20; %Constant, dependent of finger type. Regular is 70; "small size" is 20; "large size" is 163
Hand_Configuration.Distances = [97.4; 48.8; 44.3;]+Hand_Center_Finger_Center_Dist; %Set the distances of the fingers from the min point
Hand_Configuration.Angles = deg2rad([90; 90; 180]); %Initial angles, relative %was 45 45 270???
Hand_Configuration.Center = [0,0];
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles'); %Initial angles, absolute

%Run mode - simulation only, or run on robot
MODE = 'SIMULATION';
MODE = 'REAL_ROBOT'; %Uncomment this line to run on the robot. This
%assumes that what we perceive as real life is not actually a simulation.

%Initialize Arduino microcontroller and RoboDK robot simulator
a = InitArduino('COM10'); %Requires MATLAB Arduino Addon in REAL_ROBOT mode, and a connected Arduino Nano
b = InitArduino_Conveyor('COM9');
Robot_COM = 'COM2';
InitRoboDK_Conveyer();

%% Start motion
CONVEYOR_SPEED = 20; %mm/sec
setConveyorBeltSpeed(b,CONVEYOR_SPEED);
robot.MoveJ(Above_Conveyor_Belt);
cam = webcam();

%% Task 1 - Palletize distinct items
Current_Object_Type = [];
new_type_of_object = false;
Total_Number_Of_Objects = 1;
Number_Of_New_Items = 0;
This_Item_Count = 0;
for ii=1:Total_Number_Of_Objects
    [~,~] = waitForConveyorObject(0.7);
    setConveyorBeltSpeed(b,0);
    pause(0.2);
    [object, object_type] = waitForConveyorObject();
    new_type_of_object = ~isequal(object_type.Name,Current_Object_Type);
    This_Item_Count = This_Item_Count+1;
    if new_type_of_object
        This_Item_Count = 1;
        Number_Of_New_Items = Number_Of_New_Items +1;
        Current_Object_Type = object_type.Name;
        [Best_Config, Distance_Instructions] = ...
            Find_Easiest_Reconfig(Hand_Configuration, object_type.Possible_Hand_Configs);
        Instructions = Instruction_Blender(Distance_Instructions,Hand_Configuration,Best_Config.Angles);
        Execute_Instructions(Instructions,'ROBOT_BODY',a);
    end
    
    [GC_x, GC_y, GC_theta] = getHandCenterInWorldFrame(object,object_type);
    Above_Object_Position = transl(GC_x,GC_y,Conveyor_Belt_Height+safe_height+200)*roty(0)*rotz(GC_theta);
    robot.MoveL(Above_Object_Position)
    Amount_Opened = Open_or_Close_Hand(a,'OPEN');
    Grasp_Position = transl(GC_x,GC_y,Conveyor_Belt_Height+50)*roty(0)*rotz(GC_theta);
    robot.MoveL(Grasp_Position)
    Open_or_Close_Hand(a,'CLOSE',Amount_Opened);
    robot.MoveL(Above_Object_Position)
    
    [DOx,DOy,DOz] = getDropoffPosition(This_Item_Count,Number_Of_New_Items);
    Drop_Off_Position = transl(DOx,DOy,DOz)*roty(0)*rotz(0);
    Above_Drop_Off_Position =  transl(DOx,DOy,DOz+safe_height)*roty(0)*rotz(0);
    
    robot.MoveL(Above_Drop_Off_Position)
    robot.MoveL(Drop_Off_Position)
    Amount_Opened = Open_or_Close_Hand(a,'OPEN');
    robot.MoveL(Above_Drop_Off_Position)
    Open_or_Close_Hand(a,'CLOSE',Amount_Opened);
    robot.MoveJ(Above_Conveyor_Belt);
    
    
    
    %robot.setSpeed(Slow_Speed);
    
end