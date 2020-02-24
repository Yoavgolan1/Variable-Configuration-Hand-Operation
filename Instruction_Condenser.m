function Short_Instructions = Instruction_Condenser(Instructions)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global Hand_Configuration
N_Instructions = length(Instructions);
Short_Instructions = [];
ii=1;
while ii<N_Instructions
    switch Instructions{ii}.Command
        case 'CHANGE_DIST'
            %if ii==N_Instructions %Last command
              Short_Instructions(end+1).Command = 'REDIST';
              Short_Instructions(end).Dist = Instructions{ii}.Value;
              Short_Instructions(end).Finger_ID = 0;
              ii = ii+1;
              continue;
            %end
        case 'PRESS_FINGER'
            if isequal(Instructions{ii+2}.Command,'UNPRESS_FINGER') &&...
                    isequal(Instructions{ii+1}.Command,'CHANGE_DIST')
                Short_Instructions(end+1).Command = 'REDIST';
                Short_Instructions(end).Dist = Instructions{ii+1}.Value;
                Short_Instructions(end).Finger_ID = Instructions{ii}.Value;
                ii=ii+3;
                continue;
            elseif isequal(Instructions{ii+2}.Command,'UNPRESS_FINGER') &&...
                    isequal(Instructions{ii+1}.Command,'ROTATE_HAND')
                Short_Instructions(end+1).Command = 'REORIENT';
                Short_Instructions(end).Finger_ID = Instructions{ii}.Value;
                Short_Instructions(end).NewAngle = ...
                    Instructions{ii+1}.Value - Hand_Configuration.Angles(Short_Instructions(end).Finger_ID+1);
                ii=ii+3;
                continue;
            elseif isequal(Instructions{ii+3}.Command,'UNPRESS_FINGER')
                Short_Instructions(end+1).Command = 'REORIENT_REDIST';
                Short_Instructions(end).Finger_ID = Instructions{ii}.Value;
                Short_Instructions(end).Dist = Instructions{ii+1}.Value;
                Short_Instructions(end).NewAngle = ...
                    Instructions{ii+2}.Value - Hand_Configuration.Angles(Short_Instructions(end).Finger_ID+1);
                ii=ii+4;
                continue;
            end
        otherwise
            error('Unexpected instruction');
    end
end

end

