global digits RDK robot tool station safe_height Hand_Configuration
safe_height = 105;

%Set some constants
global Normal_Speed Slow_Speed Camera_Position pre_press_position_transl...
    press_position_transl Neutral_Position Above_Conveyor_Belt Robot_Speed
pre_press_position_transl = transl(380,380,365);
press_position_transl = transl(362,362,365);
Normal_Speed = [100, 10, 100 ,10];
Slow_Speed = [20, 10, 10, 10];
Robot_Speed = Slow_Speed; %Used to keep track of the current robot speed

Neutral_Position = transl(0,-790,845)*roty(0)*rotz(90*pi/180);
Camera_Position = transl(-70.651,-1214.031,618.260)...
    *rotx(-98.676*pi/180)*roty(3.293*pi/180)*rotz(90.502*pi/180);

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
RDK.AddFile([path, 'Yoavs_Hand_Conveyor_UP6.rdk']);

robot = RoboDK_getRobot();
tool = RDK.Item('Hand');
station = RDK.Item('Yoavs_Hand');
Conveyor_Belt_Frame = RDK.Item('Conveyor Belt Base');
Conveyor_Belt_Height = Conveyor_Belt_Frame.Pose();
Conveyor_Belt_Height = Conveyor_Belt_Height(3,4);

Belt_Cam_Dist = 470.45; %Height of the hand above the conveyor belt for imaging

Above_Conveyor_Belt = transl(-194.436,-967.691,Conveyor_Belt_Height + Belt_Cam_Dist)...
    *roty(0)*rotz(-90*pi/180);

if isequal(MODE,'REAL_ROBOT')
    % Try to connect to the robot (make sure to first provide the IP in the
    % RoboDK User Interface)
    try
        success = robot.Connect(Robot_COM);
    catch
        pause(2);
        success = robot.Connect(Robot_COM);
        if ~success
            pause(2);
            success = robot.Connect(Robot_COM);
        end
        if ~success
            error('Not connected to RDK')
        end
    end
    % Check if you are properly connected to the robot
    [status, status_msg] = robot.ConnectedState();
    if status ~= 1%Robolink.ROBOTCOM_READY
       fprintf(['Failed to connect to the robot:\n' , status_msg]);
       fprintf('\nPress enter to continue in simulation mode.\n');
       pause;
       MODE = 'SIMULATION';
    else
        RDK.setRunMode(RDK.RUNMODE_RUN_ROBOT)
        Robot_Speed = Normal_Speed;
        robot.setSpeed(Robot_Speed);
        %program = RDK.Item('Prog1');
        %program.setRunType(RDK.PROGRAM_RUN_ON_ROBOT)
    end
else %Simulation mode
    RDK.setRunMode(RDK.RUNMODE_SIMULATE)
end
Hand_Configuration.Abs_Angles = Rel2Abs_Angles(Hand_Configuration.Angles');
Hand_Adjust(Hand_Configuration.Abs_Angles,Hand_Configuration.Distances');