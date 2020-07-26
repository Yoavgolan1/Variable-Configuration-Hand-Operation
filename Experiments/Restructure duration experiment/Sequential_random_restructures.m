clear all
close all

global f0_min f0_max f1_min f1_max f1_pressed_min Borders Dimension Last_Index
global Movement_Vectors Border_HyperPlanes All_Locations Angle_Right_Now
global MODE Hand_Center_Finger_Center_Dist Finger_Radius
Finger_Radius = 10; %mm
Hand_Center_Finger_Center_Dist = 70;
f0_min = 0;
f0_max = 143.7;
f1_min = 20;
f1_max = 131;
f1_pressed_min = 10;
Angle_Right_Now = 0;

Dimension = 4; %Number of Fingers
Borders = Create_Borders();
Movement_Vectors = Create_Movement_Vectors(Dimension);
Border_HyperPlanes = Create_Border_Hyperplanes(Borders);

%Create an inncer hypercube for start and target
margin = 0.4 * (f1_max-f1_min);
Margin_Borders = Create_Borders(margin);

N = 50; %Number of restructures
Search_time_vec = zeros(N,1);
Path_length_vec = zeros(N,1);
Evaluated_Duration_vec = zeros(N,1);
Real_Duration_vec = zeros(N,1);

Start = [94, 50, 60, 30] + Hand_Center_Finger_Center_Dist;
Hand_Configuration.Distances = Start';
Hand_Configuration.Angles = deg2rad([45; 45; 90; 180]); %Initial angles, relative
Hand_Configuration.Center = [0,0];
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles'); %Initial angles, absolute

MODE = 'SIMULATION';
%MODE = 'REAL_ROBOT'; %Uncomment this line to run on the robot. This
%assumes that what we perceive as real life is not actually a simulation.

%Initialize Arduino microcontroller and RoboDK robot simulator
a = InitArduino('COM4'); %Requires MATLAB Arduino Addon in REAL_ROBOT mode, and a connected Arduino Nano
InitRoboDK();
robot.MoveJ(Neutral_Position);


for ii=1:N
    tic
    
    %Start = Create_Random_Point(Dimension, Margin_Borders);
    Target = Create_Random_Point(Dimension, Margin_Borders) + Hand_Center_Finger_Center_Dist;
    Target_Angles = Abs2Rel_Angles(Create_Random_Angles(Dimension));
    
    Start_Node.Index = 1;
    Start_Node.Parent = 0;
    Start_Node.Depth = 0;
    Start_Node.Location = Start;
    Start_Node.Parent_Vec = [];
    Last_Index = Start_Node.Index;
    All_Locations = Start_Node.Location;
    
    Path_Exists = 0;
    Open = Start_Node;
    Closed = [];
    count = 0;
    Give_up_time = 100; %Give up search after 100 seconds
    while ~Path_Exists && toc<Give_up_time
        [Path_Exists, Path] = Path_Within_Cube(Open(1).Location,Target);
        New_Nodes = Expand_Node2(Open(1));
        Open = [Open; New_Nodes'];
        Closed = [Closed; Open(1)];
        Open(1) = [];
        count = count+1;
    end
    Search_time_vec(ii)=toc;
    
    Path_Start = Reconstruct_Path(Closed(end),Closed);
    Path_Start_Locations = flipud(vertcat(Path_Start.Location));
    Path(1,:) = []; %remove common location
    Full_Path = [Path_Start_Locations;Path];
    Path_length_vec(ii) = length(Full_Path(:,1));
    
    Distance_Instructions = Path2Instructions_time_eval(Hand_Configuration,Full_Path);
    Instructions = Instruction_Blender(Distance_Instructions,Hand_Configuration,Target_Angles);
    
    Evaluated_Duration_vec(ii) = Evaluate_Duration(Instructions);
    
    %Perform on robot
    Execute_Instructions(Instructions,'ROBOT_BODY',a);
    
    Real_Duration_vec(ii) = toc;
    Start = Target;
end
