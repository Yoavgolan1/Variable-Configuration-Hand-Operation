function Duration = Evaluate_Duration(Instr)
%EVALUATE_DURATION Teakes a list of instructions, and evaluated the time it
%will take to eecute them on a real robot.
Duration = 0;

Time_To_Press_Button = 1; %Seconds
N_Steps = length(Instr);

for ii=1:N_Steps
    this_command = Instr{ii}.Command;
    switch this_command
        case 'PRESS_FINGER'
            Duration = Duration + Time_To_Press_Button;
        case 'CHANGE_DIST'
            amount = Instr{ii}.Value;
            Duration = Duration + Extension_Duration(amount);
        case 'ROTATE_HAND'
            Angle_Change = Instr{ii}.Value;
            Duration = Duration + Rotation_Duration(Angle_Change);
        otherwise
         
    end
end

end

