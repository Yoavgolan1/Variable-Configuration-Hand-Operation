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

MODE = 'SIMULATION';
MODE = 'REAL_ROBOT';

%a = InitArduino('COM7'); %Requires MATLAB Arduino Addon in REAL_ROBOT mode, and a connected Arduino Nano
InitRoboDK();

robot.MoveJ(Neutral_Position);

N_Angles = 50;
angle_changes = linspace(0,170,N_Angles);
angle_change_durations = zeros(N_Angles,2);

for ii=1:N_Angles
    tic
    robot.MoveJ(robot.Pose()*rotz(deg2rad(angle_changes(ii))));
    angle_change_durations(ii,1) = toc;
    tic
    robot.MoveJ(Neutral_Position);
    angle_change_durations(ii,2) = toc;
    pause(0.5);
end

ACD = [angle_change_durations(:,1);angle_change_durations(:,2)];
AAC = [angle_changes,angle_changes];
ACD = ACD - (ACD(1)+ACD(2))/2;
plot([angle_changes,angle_changes],ACD,'.')
b1 = AAC'\ACD; %linear regression % b1 =0.0210
hold on
x = linspace(0,180,100);
y = b1*x;
plot(x,y)

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/Angle_experiment.mat'];
%save(filename,'ACD','AAC','b1')