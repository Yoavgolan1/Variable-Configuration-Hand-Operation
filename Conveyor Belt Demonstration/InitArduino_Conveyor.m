function [serial_arduino_object] = InitArduino_Conveyor(COM_Port,BaudRate)
%INITARDUINO_CONVEYOR initializes the Arduino board that controls the
%conveyor belt
%   The conveyor belt in the demonstration is powered by a DC motor,
%   controlled by an Arduino board using PID speed control. The speed
%   control is performed on the board. Speed commands can be sent to the
%   Arduino via serial communication. SPeed queries can be sent to the
%   Arduino board through serial communication. This function initializes
%   the communication.

global MODE
if nargin < 2
    BaudRate = 115200;
end
if nargin < 1
    COM_Port = 'COM3';
end
if isinteger(COM_Port)
    COM_Port = ['COM',int2str(COM_Port)];
end

if isequal(MODE,'SIMULATION')
    serial_arduino_object = [];
    return
end

success = false;

s = serial(COM_Port,'BaudRate',BaudRate);
fopen(s);
readData = fscanf(s);

for ii=1:5 %connection attempts
    if isequal(readData(1:5),'Ready')
        disp('Conveyor belt Arduino initialized by serial connection');
        success = true;
        break
    end
    disp('Connection failed. Retrying...');
    pause(1);
    readData = fscanf(s);
end

if success
    serial_arduino_object = s;
else
    warning('Serial connection failed');
    serial_arduino_object = [];
    fclose(s);
end
end

