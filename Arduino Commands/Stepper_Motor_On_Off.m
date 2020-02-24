function [] = Stepper_Motor_On_Off(a,ON_OFF)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
enable = 'D13';
if isequal(ON_OFF,'ON')
    writeDigitalPin(a,enable,0);
else
    writeDigitalPin(a,enable,1);
end

end


% a = arduino('COM4','Nano','Libraries','rotaryEncoder');
% writeDigitalPin(a,'D13',0);
% for ii=1:500
%     writeDigitalPin(a,'D11',1);
%     %pause(0.0001);
%     writeDigitalPin(a,'D11',0);
%     %pause(0.0001);
%     ii
% end
% writeDigitalPin(a,'D13',1);
