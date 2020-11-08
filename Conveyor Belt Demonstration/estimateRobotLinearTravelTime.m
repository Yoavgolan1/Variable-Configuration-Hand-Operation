function [time] = estimateRobotLinearTravelTime(Start,End,Speed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dist = pdist([Start;End]); %euclidean distance between the x,y,z coordinates of the start and end
speed_linear = Speed(1);
speed_joints = Speed(2);
accel_linear = Speed(3);
accel_joints = Speed(4);

rise_time = speed_linear/accel_linear;
rise_dist = accel_linear*(rise_time^2)/2;

if rise_dist*2 > dist % speed function looks like this:  /\
    partial_rise_time = sqrt(((dist/2)*2)/accel_linear);
    time = partial_rise_time*2;
elseif rise_dist*2 < dist % speed function looks like this:  /''''\
    residual_dist = dist - 2*rise_dist;
    residual_time = residual_dist/speed_linear;
    time = 2*rise_time + residual_time;
else %  rise_dist*2 == dist
    time = rise_time*2;
end


end

