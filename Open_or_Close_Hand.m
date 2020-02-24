function Amount_Opened = Open_or_Close_Hand(a,cmd,close_amount)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if nargin<3
    close_amount = 0;
end
global Hand_Configuration Hand_Center_Finger_Center_Dist
r_min = Hand_Center_Finger_Center_Dist;
r_max = r_min+144.44;
Amount_Opened = [];
if isequal(cmd,'OPEN')
    Largest_Dist = max(Hand_Configuration.Distances);
    Room_To_Move = r_max - Largest_Dist;
    Amount_Opened = Room_To_Move/2;
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = Amount_Opened;
elseif isequal(cmd,'CLOSE')
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = -close_amount;
elseif isequal(cmd,'FORCE_CLOSE')
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = -close_amount-20; %Close 20mm more
end
Execute_Instructions(This_Instruction,'NULL',a);
end

