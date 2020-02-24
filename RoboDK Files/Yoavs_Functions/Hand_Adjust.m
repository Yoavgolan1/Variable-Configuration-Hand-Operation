function output = Hand_Adjust(angles,distances)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global RDK digits Hand_Center_Finger_Center_Dist MODE
N_digits = length(distances);
distances = distances - Hand_Center_Finger_Center_Dist; % Offset the finger distance. The short fingers are 60mm from the center
command=[distances; [angles,0]];
command=command(:)';
command(end)=[];
if N_digits==3
    command = [command,0,0];
end

allOneString = sprintf('%.0f,' , command);
allOneString = allOneString(1:end-1);% strip final comma

fullcommand = ['Hand_Control(',allOneString,')'];
if isequal(MODE,'REAL_ROBOT')
    RDK.setRunMode(RDK.RUNMODE_SIMULATE); %Bug in RoboDK
    output = RDK.RunCode(fullcommand,1);
    RDK.setRunMode(RDK.RUNMODE_RUN_ROBOT)
else
    output = RDK.RunCode(fullcommand,1);
end

digits(1).distance = distances(1);
for ii=2:length(distances)
    digits(ii).angle = angles(ii-1);
    digits(ii).distance = distances(ii);
end

end

