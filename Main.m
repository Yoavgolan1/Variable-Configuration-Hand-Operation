%% Initialization
clear all
close all
global Hand_Configuration MODE Grasp_Finger_Placements Best_Config Hand_Center_Finger_Center_Dist Finger_Radius N_Fingers

% The initial hand configuration
N_Fingers = 4;
Finger_Radius = 10; %mm
Hand_Center_Finger_Center_Dist = 70; %Constant, dependent of finger type
Hand_Configuration.Distances = [94; 50; 60; 30]+Hand_Center_Finger_Center_Dist; %Set the distances of the fingers from the min point
Hand_Configuration.Angles = deg2rad([45; 45; 90; 180]); %Initial angles, relative %was 45 45 270???
Hand_Configuration.Center = [0,0];
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles'); %Initial angles, absolute

%Hand_Adjust(Hand_Configuration.Abs_Angles,Hand_Configuration.Distances');

%Run mode - simulation only, or run on robot
MODE = 'SIMULATION';
%MODE = 'REAL_ROBOT'; %Uncomment this line to run on the robot. This
%assumes that what we perceive as real life is not actually a simulation.

%Initialize Arduino microcontroller and RoboDK robot simulator
a = InitArduino('COM4'); %Requires MATLAB Arduino Addon in REAL_ROBOT mode, and a connected Arduino Nano
InitRoboDK();

%% Image reading and processing
%Move robot to a photography position
robot.MoveJ(Camera_Position);
%Take a picture of the object
if isequal(MODE,'REAL_ROBOT')
    cam = webcam();
    snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
else % SIMULATION MODE
    snap = imread('Mustard.jpg');
end

%Convert the picture into a polygon
[P1.Vertex, normpolyfactor,Centroid] = img2poly(snap,0.02,640/48,1);
Poly_Center = mean(P1.Vertex); %Center of the polygon in camera frame
P1.Vertex = (1/normpolyfactor)*(P1.Vertex - Poly_Center); %Zero the polygon center and rescale it
Poly_Center = Poly_Center/normpolyfactor;
Pickup_Zero_Point = [-350,-625]; Object_Center = Pickup_Zero_Point + [Centroid(1),-Centroid(2)];

%% Search for grasps, hand formation instructions
MyConfigs = Monte_Carlo_Grasp_Configurations(N_Fingers,P1,0.01,5000,0.02,"SPHERE_VOLUME");
[Grasp_Center, Grasp_Finger_Placements] = Best_Grasp_That_Works(MyConfigs);
plot(Grasp_Center(:,1),Grasp_Center(:,2),'.b');
Possible_Hand_Configs = Grasp_To_Hand_Config(Grasp_Center,Grasp_Finger_Placements);
plot(Possible_Hand_Configs(1).Center(1),Possible_Hand_Configs(1).Center(2),'.g')
[Best_Config, Distance_Instructions] = Find_Easiest_Reconfig(Hand_Configuration, Possible_Hand_Configs);
Instructions = Instruction_Blender(Distance_Instructions,Hand_Configuration,Best_Config.Angles);

%% Run on Robot/Simulation
Active_Object = Create_RoboDK_Object('MUSTARD_BOTTLE',Object_Center);

robot.MoveJ(Neutral_Position);

Execute_Instructions(Instructions,'WALL',a);

robot.setSpeed(Normal_Speed);

Pick_Up_Item(Active_Object,a);
Drop_Off_Item(Active_Object,a);