clear all
%close all
global f0_min f0_max f1_min f1_max f1_pressed_min Borders Dimension Last_Index
global Movement_Vectors Border_HyperPlanes All_Locations Angle_Right_Now angle_duration_slope
f0_min = 0;
f0_max = 143.7;
f1_min = 20;
f1_max = 131;
f1_pressed_min = 10;
Angle_Right_Now = 0;

Dimension = 5; %N_Fingers
Borders = Create_Borders();
Movement_Vectors = Create_Movement_Vectors(Dimension);
Border_HyperPlanes = Create_Border_Hyperplanes(Borders);

%Create an inner hypercube for start and target
margin = 0.4 * (f1_max-f1_min); 
Margin_Borders = Create_Borders(margin);

load('Angle_experiment.mat'); angle_duration_slope = b1;

N = 10000;
Search_time_vec = zeros(N,1);
Path_length_vec = zeros(N,1);
Evaluated_Duration_vec = zeros(N,1);

for ii=1:N
    if mod(ii,0.01*N)==0
        disp(['Computing... ', num2str(ii),'/',num2str(N),' completed.']);
    end
    Start = Create_Random_Point(Dimension, Margin_Borders);
    Target = Create_Random_Point(Dimension, Margin_Borders);
    

    Hand_Configuration.Distances = Start'; 
    Hand_Configuration.Center = [0,0];
    Hand_Configuration.Abs_Angles = Create_Random_Angles(Dimension); %Initial angles, absolute
    Hand_Configuration.Angles = Abs2Rel_Angles(Hand_Configuration.Abs_Angles); %Initial angles, relative %was 45 45 270???
    
    Target_Angles = Abs2Rel_Angles(Create_Random_Angles(Dimension));
    
    %%Box test
    %Start(3) = Start(1); Start(4) = Start(2); Target(3) = Target(1); Target(4) = Target(2);
    %Hand_Configuration.Abs_Angles = [90, 180, 270];
    %Hand_Configuration.Angles = Abs2Rel_Angles(Hand_Configuration.Abs_Angles);
    %Target_Angles = Hand_Configuration.Angles;
    %%Similar triangle test
    %Start(2) = Start(1); Start(3) = Start(1); Target(3) = Target(1); Target(2) = Target(1);
       
    tic
    %[Path_Exists, Path] = Path_Within_Cube(Start,Target);
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
    Give_up_time = 100; %Give up search after 10 seconds
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
    Instr = Instruction_Blender_time_eval(Distance_Instructions,Hand_Configuration,Target_Angles);
    
    Evaluated_Duration_vec(ii) = Evaluate_Duration(Instr);
    
end

disp(['The mean duration for ', num2str(Dimension), ' fingers is ',num2str(mean(Evaluated_Duration_vec)),' seconds.']);
disp(['The standard deviation is ',num2str(std(Evaluated_Duration_vec)),' seconds.']);
SEV = sort(Evaluated_Duration_vec);
disp(['95% of plans were realized in ',num2str(SEV(round(length(SEV)*0.95))),' seconds.']);
disp(['The mean computation time is ',num2str(mean(Search_time_vec)),' seconds.']);
disp(['The standard deviation is ',num2str(std(Search_time_vec)),' seconds.']);

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/Fingers_',num2str(Dimension),'.mat'];
%uncomment this line to save the data
save(filename,'Search_time_vec','Path_length_vec','Evaluated_Duration_vec')
