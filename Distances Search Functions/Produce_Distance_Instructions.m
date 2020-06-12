function [IsPossible, N_Steps, Instructions] = Produce_Distance_Instructions(Hand_Configuration, This_Config_Distances, Lowest_N_Steps)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global Hand_Center_Finger_Center_Dist
N_Fingers = length(Hand_Configuration.Distances);
if N_Fingers ~=3
    return
end

%Target and start are reversed
Start = This_Config_Distances' - Hand_Center_Finger_Center_Dist;
Target = Hand_Configuration.Distances' - Hand_Center_Finger_Center_Dist;
%% Initialization
global f0_min f0_max f1_min f1_max f1_pressed_min Borders Dimension Last_Index
f0_min = 0;
f0_max = 143.7;
f1_min = 20;
f1_max = 131;
f1_pressed_min = 10;

Dimension = 3; %N_Fingers
Borders = Create_Borders();
Movement_Vectors = Create_Movement_Vectors(Dimension);

%Start = Create_Random_Point(Dimension, Borders);
%Target = Create_Random_Point(Dimension, Borders);
Start = [0.6659  106.0151  110.7207]; Target = [124.8314   29.3724   64.3759];

Target_HyperPlanes = Create_Target_Hyperplanes(Target, Movement_Vectors);
Border_HyperPlanes = Create_Border_Hyperplanes(Borders);

%% Search 3D

Start_Node.Parent = 0;
Start_Node.Index = 1;
Start_Node.Depth = 0;
Start_Node.Location = Start;
Start_Node.Is_Feasible = false;
Start_Node.Resolved = false;
Last_Index = 1;
Open = Start_Node;
Closed = [];

Target_Rays = Target_HyperPlanes; Target_Rays(:,Dimension+1:end) = Movement_Vectors;

Goal_Reached = false;
while ~isempty(Open) && ~Goal_Reached
    New_Nodes = Expand_Node(Open(1), Movement_Vectors, Border_HyperPlanes, Target_HyperPlanes);
    for ii=1:length(New_Nodes)
        Open = [Open; New_Nodes{ii}];
    end
    Closed = [Closed; Open(1)];
    Open(1) = [];
    
    for ii=length(Open):-1:1
        if Open(ii).Is_Feasible
            Point_Rays = Open(ii).Location;
            Point_Rays = repmat(Point_Rays,Dimension,1);
            Point_Rays = [Point_Rays, Movement_Vectors];
            for jj=1:Dimension
                for kk=1:Dimension
                    Target_Intersection = Line_Line_Intersection(Point_Rays(jj,:),Target_Rays(kk,:));
                    if Point_In_HyperCube(Target_Intersection, Borders)
                        Goal_Reached = true;
                        Final_Node.Location = Target_Intersection';
                        Final_Node.Depth = Open(ii).Depth + 1;
                        if (Final_Node.Depth + 1) > Lowest_N_Steps
                            N_Steps = Final_Node.Depth + 1;
                            Instructions = [];
                            IsPossible = false;
                            return
                        end
                        Final_Node.Parent = Open(ii).Index;
                        Last_Index = Last_Index + 1;
                        Final_Node.Index = Last_Index;
                        Final_Node.Is_Feasible = true;
                        Final_Node.Resolved = true;
                        Closed = [Closed; Open(ii)];
                        Open(ii) = [];
                        Path = Reconstruct_Path(Final_Node,Closed);
                        break
                    end
                end
                if Goal_Reached
                    break;
                end
            end
            if ~Goal_Reached
                Open(ii).Is_Feasible = [];
            else
                break
            end
        end
    end
    
    
end
if ~exist('Final_Node')
    Depth = 0;
    IsPossible = false;
Instructions = [];
    return
end
Depth = Final_Node.Depth;
N_Steps = Depth+1;
IsPossible = true;
Instructions = Path;
%Instructions.Location
end

