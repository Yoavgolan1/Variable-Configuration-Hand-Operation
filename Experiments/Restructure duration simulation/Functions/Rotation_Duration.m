function [duration] = Rotation_Duration(in_angle, robot_joint_speed, robot_joint_accel)
%ROTATION_DURATION takes an angle of rotation for the hand, and returns the
%duration for the physical rotation to occur.
%   Based on experimental data, this function accepts the total angle
%   change (in degrees) of the last robotic arm joint (joint 6), and
%   returns the duration (in seconds) it will take to reach the target.
%   This is not a straightforward conversion because it takes into
%   consideration the acceleration and decelleration of the hand's
%   rotation. The result is interpolated based on real-world observations.
if nargin<3
    robot_joint_accel = 800; %degrees per second^2
end
if nargin<2
    robot_joint_speed = 500; %degrees per second
end
in_angle = abs(in_angle);
%speed, acceleration, angle change, duration

%load(rotate_exp_data.mat)
% experiment_data = [500,800,0,0; 500,800,10,0.2; 500,800,20,0.3; 500,800,30,0.4;...
%     500,800,40,0.55; 500,800,50,0.65; 500,800,60,0.8; 500,800,70,0.9; 500,800,80,1.0;...
%     500,800,90,1.05; 500,800,100,1.15; 500,800,110,1.25; 500,800,120,1.4;...
%     500,800,150,2; 500,800,180,2.5; 500,800,250,4; 500,800,300,5;];
% speeds = experiment_data(:,1)+10*rand(17,1)-5;
% accels = experiment_data(:,2);
% angles = experiment_data(:,3);
% durations = experiment_data(:,4);
% 
% duration = griddata(speeds,angles,durations,robot_joint_speed,in_angle,'cubic');

rot1 = 0;
dur1 = 0;
rot2 = 180; %degrees
dur2 = 0.5; %seconds

duration = abs(in_angle)*((dur2-dur1)/(rot2-rot1));

end

