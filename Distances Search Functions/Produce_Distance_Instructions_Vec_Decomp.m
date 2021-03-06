function [IsPossible, N_Steps, Instructions] = Produce_Distance_Instructions_Vec_Decomp(Hand_Configuration, This_Config_Distances, Lowest_N_Steps, Timeout)
%PRODUCE_DISTANCE_INSTRUCTIONS_VEC_DECOMP is the main restructuring
%planner.
%   The function receives start and target fingertip distance vectors, and
%   finds an optimal path (with the lease finger presses) between them. The
%   function uses the Vector Decomposition method, which is prefferable to
%   the previous method of dimensional unfolding, due to its simplicity.
%   The function returns a path from start to target, if possible.

if nargin<4
    Timeout = 10; %Give up after 10 seconds
end
IsPossible = true;

global f0_min f0_max f1_min f1_max f1_pressed_min Borders Dimension
global Last_Index Movement_Vectors Border_HyperPlanes All_Locations
global Hand_Center_Finger_Center_Dist

f0_min = 0;
f0_max = 143.7;
f1_min = 20;
f1_max = 131;
f1_pressed_min = 10;

Dimension = length(Hand_Configuration.Distances); %N_Fingers
Borders = Create_Borders();
Movement_Vectors = Create_Movement_Vectors(Dimension);
Border_HyperPlanes = Create_Border_Hyperplanes(Borders);

%Target and start are reversed
Start = This_Config_Distances' - Hand_Center_Finger_Center_Dist;
Target = Hand_Configuration.Distances' - Hand_Center_Finger_Center_Dist;


%Give_up_time = 10; %Give up search after 10 seconds
Start_Node.Index = 1;
Start_Node.Parent = 0;
Start_Node.Depth = 0;
Start_Node.Location = Start;
Start_Node.Parent_Vec = [];
Last_Index = Start_Node.Index;
All_Locations = Start_Node.Location;

N_Steps = Inf;
Path_Exists = 0;
Open = Start_Node;
Closed = [];
count = 0;
%Give_up_time = 10; %Give up search after 10 seconds
tic
while ~Path_Exists && toc<Timeout
    if Open(1).Depth > Lowest_N_Steps
        Instructions = [];
        IsPossible = false;
        return
    end

    [Path_Exists, Path] = Path_Within_Cube(Open(1).Location,Target);
    New_Nodes = Expand_Node2(Open(1));
    Open = [Open; New_Nodes'];
    Closed = [Closed; Open(1)];
    
    if Path_Exists
        N_Steps = Open(1).Depth + 1;
    end
    
    Open(1) = [];
    count = count+1;
    %     if mod(count,200)==0
    %     %   Clean struct
    %         AllNodes = [Open;Closed];
    %         %T = struct2table(AllNodes);
    %         %TL = T{:,4};
    %         TL = vertcat(AllNodes.Location);
    %         [C,ia,ic] = unique(TL,'rows','stable');
    %         OL = length(Open);
    %         %AllNodes(OL+1:end) = [];
    %         ia_Open = ia(ia<=OL);
    %         Open2 = AllNodes(ia_Open);
    %     end
end
time_elapsed = toc;

if (time_elapsed) > Timeout
    Instructions = [];
    IsPossible = false;
    return
end

Path_Start = Reconstruct_Path(Closed(end),Closed);
Path_Start_Locations = flipud(vertcat(Path_Start.Location));
Path_Start = fliplr(Path_Start);

for ii=1:length(Path(1,:))
    Path_Struct_Form(ii).Index = NaN;
    Path_Struct_Form(ii).Parent = NaN;
    Path_Struct_Form(ii).Depth = NaN;
    Path_Struct_Form(ii).Location = Path(ii,:);
    Path_Struct_Form(ii).Parent_Vec = [];
end




Path(1,:) = []; %remove common location
Path_Struct_Form(1) = []; %remove common location
%Full_Path = [Path_Start_Locations;Path];
Full_Path = fliplr([Path_Start,Path_Struct_Form]);


Instructions = Full_Path;

