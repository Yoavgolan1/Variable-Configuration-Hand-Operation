function Instructions = Instruction_Blender_time_eval(Distance_Instructions,Hand_Configuration,Goal_Angles)
%INSTRUCTION_BLENDER takes the fingertip distance changes needed, the start
%angle configuration and the goal angle configuration. It produces a list
%of instructions to adjust the hand structure to its goal.
%   Priority is given to distance instructions. Angle adjustments are made
%   opportunistically.
global Angle_Right_Now Angle_tracker
Instructions = [];

Current_Angles = Hand_Configuration.Angles;
N_Fingers = numel(Current_Angles);

Current_Angles = Rel2Abs_Angles(Current_Angles');
Goal_Angles = Rel2Abs_Angles(Goal_Angles');

Dist_Change_IDS = Distance_Instructions(:,end);
N_Distance_Changes = numel(Dist_Change_IDS);
Fingers_To_Change = [];
for ii=1:N_Fingers-1
    if Goal_Angles(ii) ~= Current_Angles(ii)
        Fingers_To_Change(end+1) = ii;
    end
end
Angle_tracker = 0;
for ii=1:N_Distance_Changes
    if Dist_Change_IDS(ii) %If a finger needs to be pressed while changing distance
        
        This_Instruction.Command = 'ROTATE_HAND';
        This_Instruction.Value = Angle_Right_Now - Current_Angles(Dist_Change_IDS(ii));
        Instructions{end+1} = This_Instruction;
        Angle_Right_Now = Current_Angles(Dist_Change_IDS(ii));
        Angle_tracker(end+1) = Angle_Right_Now;
        
        This_Instruction.Command = 'PRESS_FINGER';
        This_Instruction.Value = Dist_Change_IDS(ii);
        Instructions{end+1} = This_Instruction;
        This_Instruction.Command = 'CHANGE_DIST';
        This_Instruction.Value = Distance_Instructions(ii,1);
        Instructions{end+1} = This_Instruction;
        
        Finger_Index = find(Fingers_To_Change==Dist_Change_IDS(ii),1);
        if ~isempty(Finger_Index) %If this finger has not been re-angled
            Angle_Change_Possible = ...
                Check_Angle_Movement(Current_Angles,Goal_Angles,Dist_Change_IDS(ii));
            if Angle_Change_Possible
                This_Instruction.Command = 'ROTATE_HAND';
                This_Instruction.Value = Goal_Angles(Dist_Change_IDS(ii))...
                    - Current_Angles(Dist_Change_IDS(ii));
                Instructions{end+1} = This_Instruction;
                Current_Angles(Dist_Change_IDS(ii)) = Goal_Angles(Dist_Change_IDS(ii));
                Fingers_To_Change(Finger_Index) = [];
                
                Angle_Right_Now = Angle_Right_Now + This_Instruction.Value;
                Angle_tracker(end+1) = Angle_Right_Now;
                
            end
        end
        This_Instruction.Command = 'UNPRESS_FINGER';
        This_Instruction.Value = Dist_Change_IDS(ii);
        Instructions{end+1} = This_Instruction;
        
    else %If the finger ID is 0, all fingers need to be changed
        This_Instruction.Command = 'CHANGE_DIST';
        This_Instruction.Value = Distance_Instructions(ii,1);
        Instructions{end+1} = This_Instruction;
    end
end

Ind = 1;
while ~isempty(Fingers_To_Change)
    This_Finger_ID = Fingers_To_Change(Ind);
    Angle_Change_Possible = ...
        Check_Angle_Movement(Current_Angles,Goal_Angles,This_Finger_ID);
    if Angle_Change_Possible
        This_Instruction.Command = 'PRESS_FINGER';
        This_Instruction.Value = This_Finger_ID;
        Instructions{end+1} = This_Instruction;
        This_Instruction.Command = 'ROTATE_HAND';
        This_Instruction.Value = Goal_Angles(This_Finger_ID)...
            - Current_Angles(This_Finger_ID);
        Instructions{end+1} = This_Instruction;
        This_Instruction.Command = 'UNPRESS_FINGER';
        This_Instruction.Value = This_Finger_ID;
        Instructions{end+1} = This_Instruction;
        Current_Angles(This_Finger_ID) = Goal_Angles(This_Finger_ID);
        Finger_Index = find(Fingers_To_Change==This_Finger_ID,1);
        
        Fingers_To_Change(Finger_Index) = [];
        Ind = 1;
    else
        Ind = Ind+1;
    end
end

%Clean Instructions
ii=1;
while ii<length(Instructions)
    if isequal(Instructions{ii}.Command, 'CHANGE_DIST') &&  Instructions{ii}.Value == 0
        Instructions(ii) = [];
        ii = 0;
    end
    ii = ii+1;
end

ii=2;
while ii<length(Instructions)
    if isequal(Instructions{ii}.Command, 'UNPRESS_FINGER') &&  isequal(Instructions{ii-1}.Command, 'PRESS_FINGER')
        Instructions(ii-1:ii) = [];
        ii = 0;
    end
    ii = ii+1;
end

%disp('Instructions have been refined, and are ready for execution.');

end

