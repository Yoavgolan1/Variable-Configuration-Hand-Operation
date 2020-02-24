function [a] = InitArduino(COM_Port)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global MODE
if isequal(MODE,'SIMULATION')
    a = [];
    return
end
if nargin<1
    COM_Port = 'COM5';
end
if isinteger(COM_Port)
    COM_Port = ['COM',int2str(COM_Port)];
end
disp('Initializing Arduino...');
a = arduino(COM_Port,'Nano','Libraries','rotaryEncoder');
Stepper_Motor_On_Off(a,'OFF')
configurePin(a,'D4','DigitalInput')
disp('Arduino initialized.');
end

% for ii=1:100
%     writeDigitalPin(a,'D11',0)
%     pause(0.01)
% writeDigitalPin(a,'D11',1)
% pause(0.01)
% end