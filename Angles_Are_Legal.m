function [Legal_Angles] = Angles_Are_Legal(Angles,Finger_Combs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Buffer = 45;
Legal_Angles = true;

N_Fingers = numel(Angles);

if min(Angles) < Buffer || max(Angles) > (360-Buffer)
    Legal_Angles = false;
    return;
end
%warning('off','map:removing:combntns')


for ii=1:(numel(Finger_Combs)/2)
    if abs(Angles(Finger_Combs(ii,1))-Angles(Finger_Combs(ii,2))) < Buffer
        Legal_Angles = false;
        return;
    end
end

