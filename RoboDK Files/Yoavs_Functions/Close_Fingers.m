function [] = Close_Fingers(finger_ids,amount,step)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global digits robot RDK Hand_Configuration
if nargin<3 || step==0
    step = amount;
end
if amount == 0
    return
end
for ii=2:length(digits)
    digits(ii).angle = Hand_Configuration.Abs_Angles(ii-1);
end
for ii=1:length(digits)
    digits(ii).distance = Hand_Configuration.Distances(ii);
end
fingertip_offset = 115.5;
N_digits = length([digits.angle]);
% if length(finger_ids)~=N_digits
%     warning('Number of finger IDs does not match simulator');
% end
distances(1:N_digits) = [digits.distance];
angles(1:N_digits) = [digits.angle];

Finger(1) = RDK.Item('Finger_1'); Fingertip(1) = RDK.Item('Fingertip_0');
Finger(2) = RDK.Item('Finger_1'); Fingertip(2) = RDK.Item('Fingertip_1');
Finger(3) = RDK.Item('Finger_2'); Fingertip(3) = RDK.Item('Fingertip_2');
Finger(4) = RDK.Item('Finger_3'); Fingertip(4) = RDK.Item('Fingertip_3');

res = abs(round(amount/step));
loc_space = linspace(0,-amount,res);
step_size = amount/res;

for ii=1:res
    for jj=1:length(finger_ids)
        cur = finger_ids(jj)+1;
        %Fingertip(cur).setPose(rotz(angles(cur)*pi/180)*transl(0,fingertip_offset-loc_space(ii)-digits(cur).distance,0));
        F_Pose = Fingertip(cur).Pose();
        Fingertip(cur).setPose(F_Pose*transl(0,step_size,0));
    end
end
for ii=1:length(finger_ids)
    cur = finger_ids(ii)+1;
    digits(cur).distance = digits(cur).distance-amount;
end

end

