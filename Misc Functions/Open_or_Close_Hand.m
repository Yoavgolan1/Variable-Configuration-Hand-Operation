function Amount_Opened = Open_or_Close_Hand(a,cmd,close_amount)
%OPEN_OR_CLOSE_HAND extends or retracts the hand digits.
%   This function works in either simulation or run-on-robot mode. The
%   function recieves an "OPEN", "CLOSE" or "FORCE_CLOSE" command, and the amount to open
%   or close in mm. If no amount is given, the function uses the current
%   hand configuration to open a standard distance. "FORCE_CLOSE"
%   over-closes the hand, to avoid grasp uncertainty. This mode may harm
%   the object/hand.
if nargin<3
    close_amount = 0;
end
global Hand_Configuration Hand_Center_Finger_Center_Dist
r_min = Hand_Center_Finger_Center_Dist;
r_max = r_min+144.44;
Amount_Opened = [];
if isequal(cmd,'OPEN') && close_amount == 0
    Largest_Dist = max(Hand_Configuration.Distances);
    Room_To_Move = r_max - Largest_Dist;
    Amount_Opened = Room_To_Move/2;
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = Amount_Opened;
elseif isequal(cmd,'OPEN') && close_amount ~= 0
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = close_amount;
elseif isequal(cmd,'CLOSE')
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = -close_amount;
elseif isequal(cmd,'FORCE_CLOSE')
    This_Instruction{1}.Command = 'CHANGE_DIST';
    This_Instruction{1}.Value = -close_amount-50; %Close 50mm more
end
Execute_Instructions(This_Instruction,'NULL',a);
end

