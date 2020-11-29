function [a] = InitArduino(COM_Port)
%INITARDUINO initializes the hand's built-in Arduino board
%   The in-hand Arduino board reads the encoder, buttons, and activates
% the stepper motor via the Big Easy Driver motor driver. This function
% initializes the Arduino.
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
%a = arduino(COM_Port,'Nano','Libraries','rotaryEncoder');
a = arduino(COM_Port,'Mega2560','Libraries','rotaryEncoder');
Stepper_Motor_On_Off(a,'OFF')
configurePin(a,'D4','DigitalInput')
disp('Robotic Hand Arduino initialized.');
end
