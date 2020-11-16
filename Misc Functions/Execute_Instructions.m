function [] = Execute_Instructions(Instructions, Environment_Type, a)
%EXECUTE_INSTRUCTIONS takes a list of hand adjustment commands and executes
%them
%   Commands can be executed in simulation only, or on the real world.
%   COmmands are "ROTATE_HAND", "PRESS_FINGER", "UNPRESS_FINGER", and
%   "CHANGE_DIST". The user can choose what type of environment the robot
%   will adjust the hand against- "ROBOT_BODY" to adjust against the
%   robot's base, or "WALL" to adjust against the nearby wall.
global Normal_Speed Slow_Speed Neutral_Position RDK robot Hand_Configuration MODE tool station
if nargin < 3
    a = [];
end
if nargin < 2
    Environment_Type = 'ROBOT_BODY';
end
disp('Executing instructions...');
if isequal(Environment_Type,'WALL')
    PPL = [490,495,665];
    Pre_Press_Location_Transl = transl(PPL(1),PPL(2),PPL(3));
    %PL = [490,548,665];
        PL = [490,541,665];

    Press_Location_Transl = transl(PL(1),PL(2),PL(3));
    UM = PPL-PL;
    Unpress_Motion = transl(UM(1),UM(2),UM(3));
    T1 = RDK.AddTarget('Neutral Position');
    T1.setPose(Neutral_Position);
    robot.MoveJ(T1);
    %T2 = [-0.707106781186548,-0.707106781186548,-5.38467118429265e-17,458.614000000000;0.707106781186548,-0.707106781186548,-1.37113438689813e-16,-458.614000000000;4.85722573273506e-17,-1.22464679914735e-16,1,795;0,0,0,1];
    T2 = RDK.AddTarget('Way to wall');
    T2.setPose(transl(458,-458,795));
    T3 = RDK.AddTarget('Near wall');
    T3.setPose(Pre_Press_Location_Transl);
    %robot.MoveC(T2,T3);
    robot.MoveL(T2);
    robot.MoveL(T3);
end
if isequal(Environment_Type,'ROBOT_BODY')
    PPL = [0,-560,365];
    Pre_Press_Location_Transl = transl(PPL(1),PPL(2),PPL(3));
    %PL = [0,-522,365];
    PL = [0,-528,365]; %works for finger 1
    %PL = [0,-525,365]; %works for finger 2
    Press_Location_Transl = transl(PL(1),PL(2),PL(3));
    UM = PPL-PL;
    Unpress_Motion = transl(UM(1),UM(2),UM(3));
end



Finger_ID = 0;
N_Fingers = length(Hand_Configuration.Distances);
N_Instructions = length(Instructions);
A_Finger_Pressed = false;
%figure;
for ii=1:N_Instructions
    %w = waitforbuttonpress;
    switch Instructions{ii}.Command
        case 'PRESS_FINGER'
            Finger_ID = Instructions{ii}.Value;
            A_Finger_Pressed = true;
            Finger_Angle = Hand_Configuration.Abs_Angles(Finger_ID);
            robot.MoveJ(Pre_Press_Location_Transl*rotx(0)*roty(0)*rotz(deg2rad(180-Finger_Angle)));
            
            if isequal(MODE,'REAL_ROBOT')
                RDK.setRunMode(RDK.RUNMODE_SIMULATE); %Bug in RoboDK
                Joints = robot.Joints();
                RDK.setRunMode(RDK.RUNMODE_RUN_ROBOT);
            else
                RDK.setRunMode(RDK.RUNMODE_SIMULATE);
                Joints = robot.Joints();
            end
            
            T_Joint = Joints(6); %Last joint angle after next turn
            if T_Joint<(-180) || T_Joint>(180)
                robot.MoveL(robot.Pose()*rotz(deg2rad(-T_Joint/3)));
                robot.MoveL(robot.Pose()*rotz(deg2rad(-T_Joint/3)));
                robot.MoveL(robot.Pose()*rotz(deg2rad(-T_Joint/3)));
                robot.MoveJ(Pre_Press_Location_Transl*rotx(0)*roty(0)*rotz(deg2rad(180-Finger_Angle)));
            end
            robot.setSpeed(Slow_Speed);
            
            %if Finger_ID==2 %This "if" is because apparently Finger 2 has a slightly different length. Will be fixed later.
            %    Press_Location_Transl = Press_Location_Transl*transl(0,9,0);
            %end
            %bug fixed
            
            robot.MoveL(Press_Location_Transl*rotx(0)*roty(0)*rotz(deg2rad(180-Finger_Angle)));
            
            %if Finger_ID==2 %This "if" is because apparently Finger 2 has a slightly different length. Will be fixed later.
            %    Press_Location_Transl = Press_Location_Transl*transl(0,-9,0); 
            %end
            %bug fixed
            
            
            switch Finger_ID
                case 1
                    Finger = RDK.Item('Finger_1');
                    Fingertip = RDK.Item('Fingertip_1');
                case 2
                    Finger = RDK.Item('Finger_2');
                    Fingertip = RDK.Item('Fingertip_2');
                case 3
                    Finger = RDK.Item('Finger_3');
                    Fingertip = RDK.Item('Fingertip_3');
                otherwise
                    disp('Bad finger ID');
            end
            
            Finger.setParentStatic(station);
            Fingertip.setParentStatic(station);
        case 'UNPRESS_FINGER'
            Finger.setParentStatic(tool);
            Fingertip.setParentStatic(tool);
            A_Finger_Pressed = false;
            Robot_Pos = robot.Pose();
            robot.MoveL(Unpress_Motion*Robot_Pos);
            robot.setSpeed(Normal_Speed);
            Finger_ID = 0;
            %robot.MoveL(Pre_Press_Location*rotx(0)*roty(0)*rotz(deg2rad(Finger_Angle+90)));
            
        case 'ROTATE_HAND'
            Robot_Pos = robot.Pose();
            Angle_Change = Instructions{ii}.Value;
            if abs(Angle_Change)>180
                robot.MoveJ(Robot_Pos*rotz(deg2rad(-Angle_Change/2))); %Was MoveL, changed because Robodk doesn't limit joint speed in linear mode
                Robot_Pos = robot.Pose();
                robot.MoveJ(Robot_Pos*rotz(deg2rad(-Angle_Change/2)));
            else
                robot.MoveJ(Robot_Pos*rotz(deg2rad(-Angle_Change))); %Bug- adding *transl(0,11,0) corrects diversion in real joints?
            end
            Hand_Configuration.Abs_Angles(Finger_ID) =...
                Hand_Configuration.Abs_Angles(Finger_ID) + Angle_Change;
            Hand_Configuration.Angles = Abs2Rel_Angles(Hand_Configuration.Abs_Angles);
        case 'CHANGE_DIST'
            amount = Instructions{ii}.Value;
            Finger_Vec = 0:N_Fingers-1;
            if Finger_ID > 0 && A_Finger_Pressed
                Finger_Vec(Finger_ID+1) = [];
            end
            if isequal(MODE,'REAL_ROBOT')
                Close_Fingers(Finger_Vec,-amount); %No fancy animation
                Arduino_Change_Dist(a,-amount,Finger_ID); %Arduino function handles hand configuration update
            else %Simulation Mode
                Close_Fingers(Finger_Vec,-amount,1);
                for jj=1:length(Finger_Vec)
                    Hand_Configuration.Distances(Finger_Vec(jj)+1) = ...
                        Hand_Configuration.Distances(Finger_Vec(jj)+1) + amount;
                    Hand_Configuration.Angles = Abs2Rel_Angles(Hand_Configuration.Abs_Angles);
                end
            end
        otherwise
            error('Unrecognized command')
    end
    
end

if isequal(Environment_Type,'WALL')
    %     robot.MoveC(T2,T1);
    robot.MoveL(T2);
    robot.MoveL(T1);
    T1.Delete();
    T2.Delete();
    T3.Delete();
end

disp('Execution Complete.');


end

