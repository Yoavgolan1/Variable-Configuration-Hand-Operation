function [duration] = Extension_Duration(extension)
%EXTENSION_DURATION accepts the extension/retracion and returns the
%duration of the action in the real world
%   The function accepts the extension/retraction in mm, and returns the
%   time it takes to comlete the action, based on experimentation.
%   Acceleration is negligible, so the function is linear.
ex1 = 0;
dur1 = 0;
ex2 = 100; %mm
dur2 = 3.4; %seconds

duration = abs(extension)*((dur2-dur1)/(ex2-ex1));
end

