function [] = Arduino_Change_Dist(a, delta, Finger_Pressed)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
global Hand_Configuration
Stepper_Motor_On_Off(a,'ON')
MOTOR_ACTIVATION_PIN = 'D11';
DIR_PIN = 'D12';
ENC_A_PIN = 'D18';
ENC_B_PIN = 'D19';
STEPPER_FREQUENCY = 3000; %Hz

ppr = 1000*4; %Ticks per revolution for encoder
mm_per_rev = 8;
rev_per_mm = 1/mm_per_rev;
ticks_per_mm = rev_per_mm*ppr;
mm_per_tick = 1/ticks_per_mm;
minspeed = 1; %rpm

Initial_Distances = Hand_Configuration.Distances;
Switch_Dir = 0;
if delta>0
    Switch_Dir = 1;
end
writeDigitalPin(a,DIR_PIN,Switch_Dir);

encoder = rotaryEncoder(a,ENC_A_PIN,ENC_B_PIN,ppr);
%resetCount(encoder);
[count,~] = readCount(encoder,'Reset',true);
Init_count = count;

Required_distance = abs(delta*ticks_per_mm)
tic
%writePWMVoltage(a,MOTOR_ACTIVATION_PIN,2.5);
playTone(a,MOTOR_ACTIVATION_PIN,STEPPER_FREQUENCY,30);


while abs(Init_count-count)<Required_distance
    [count,~] = readCount(encoder);
    %abs(readSpeed(encoder))
    count;
    %     BP = Any_Buton_Pressed(a);
    %     if BP
    %         %warning(['Button pressed: ',BP])
    %         %break
    %     end
    if abs(readSpeed(encoder)) < minspeed && toc>2
        medspeed = median([readSpeed(encoder) readSpeed(encoder) readSpeed(encoder)]);
        if medspeed < minspeed
            warning('Motor jammed!')
            break
        end
    end
    % %     abs(Init_count-count)
end
%writePWMVoltage(a,MOTOR_ACTIVATION_PIN,0); %Stop motor

playTone(a,MOTOR_ACTIVATION_PIN,0,0)
[count,~] = readCount(encoder);
delta_travelled = count*mm_per_tick;

N_Fingers = length(Initial_Distances);
for ii=1:N_Fingers
    if ii == (Finger_Pressed+1)
        continue
    else
        Hand_Configuration.Distances(ii) = Hand_Configuration.Distances(ii) + delta_travelled;
    end
end
clear encoder
Stepper_Motor_On_Off(a, 'OFF')
end

function Pressed = Any_Buton_Pressed(a)
Pressed = 0;
B1 = 'D4';
B2 = 'D5';
B3 = 'D6';
B4 = 'D7';
B5 = 'D8';
B6 = 'D9';
B7 = 'D10';
B8 = 'D10'; %Assign to analog later
B = {B1, B2, B3, B4, B5, B6, B7, B8};
for ii=1:length(B)
    if readDigitalPin(a,B{ii})
        Pressed = B{ii};
        break
    end
end

end

