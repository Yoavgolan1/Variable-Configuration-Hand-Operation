function [duration] = Rotation_Duration(in_angle, linear_slope)
%ROTATION_DURATION takes an angle of rotation for the hand, and returns the
%duration for the physical rotation to occur.
%   Based on experimental data, this function accepts the total angle
%   change (in degrees) of the last robotic arm joint (joint 6), and
%   returns the duration (in seconds) it will take to reach the target.
%   This is not a straightforward conversion because it takes into
%   consideration the acceleration and decelleration of the hand's
%   rotation. The result is interpolated based on real-world observations.

if nargin<2
    linear_slope = 0.021; %seconds per degree
end

duration = abs(in_angle)*linear_slope;
end

