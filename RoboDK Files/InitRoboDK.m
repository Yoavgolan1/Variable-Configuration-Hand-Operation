global digits RDK robot tool station safe_height Hand_Configuration
safe_height = 105;

%Set some constants
global Normal_Speed Slow_Speed Camera_Position pre_press_position_transl press_position_transl Neutral_Position
pre_press_position_transl = transl(380,380,365);
press_position_transl = transl(362,362,365);
Normal_Speed = [100, 10, -1 ,-1];
Slow_Speed = [20, 10, -1, -1];
Neutral_Position = transl(0,-790,845)*roty(0)*rotz(90*pi/180);
%Camera_Position = transl(-50,-1169.388,640.911)*rotx(-90*pi/180)*roty(0*pi/180)*rotz(90*pi/180);
Camera_Position = transl(-70.651,-1214.031,618.260)*rotx(-98.676*pi/180)*roty(3.293*pi/180)*rotz(90.502*pi/180);


N_Fingers = length(Hand_Configuration.Distances);
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles');


for ii=0:N_Fingers-1
    digits(ii+1).id = ii;
    digits(ii+1).distance = Hand_Configuration.Distances(ii+1);
    if ii==0
        digits(1).angle = 0;
    else
        digits(ii+1).angle = Hand_Configuration.Abs_Angles(ii);
    end
end

RDK = Robolink;
%path = pwd;
path = [pwd,'\RoboDK Files\'];
%path = 'D:/Google Drive/Research/4th Hand/RoboDK/';
RDK.AddFile([path, 'Yoavs_Hand_Simplified_UP6.rdk']);

%fprintf('Available items in the station:\n');
%disp(RDK.ItemList());

robot = RoboDK_getRobot();
tool = RDK.Item('Hand');
station = RDK.Item('Yoavs_Hand');

%Import_Items; %Uncomment to import Sugar Box, Cracker Box, and Power Drill

if isequal(MODE,'REAL_ROBOT')
    % Try to connect to the robot (make sure to first provide the IP in the RoboDK User Interface)
    success = robot.Connect('COM2');
    % Check if you are properly connected to the robot
    [status, status_msg] = robot.ConnectedState();
    if status ~= Robolink.ROBOTCOM_READY
       fprintf(['Failed to connect to the robot:\n' , status_msg]);
       fprintf('\nPress enter to continue in simulation mode.\n');
       pause;
       MODE = 'SIMULATION';
    else
        RDK.setRunMode(RDK.RUNMODE_RUN_ROBOT)
        robot.setSpeed(Normal_Speed);
        %program = RDK.Item('Prog1');
        %program.setRunType(RDK.PROGRAM_RUN_ON_ROBOT)
    end
else %Simulation mode
    RDK.setRunMode(RDK.RUNMODE_SIMULATE)
end
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles');
Hand_Adjust(Hand_Configuration.Abs_Angles,Hand_Configuration.Distances');


