function [New_Instructions] = instructionsCleaner(Instructions)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N_Instructions = numel(Instructions);

ii=1;
while ii<numel(Instructions)
    if isequal(Instructions{ii}.Command,'CHANGE_DIST')
        if isequal(Instructions{ii+1}.Command,'CHANGE_DIST')
            Instructions{ii}.Value = Instructions{ii}.Value +...
                Instructions{ii+1}.Value;
            Instructions(ii+1) = [];
        end
    end
    ii = ii + 1;
end

ii=1;
while ii<numel(Instructions)
    if isequal(Instructions{ii}.Command,'ROTATE_HAND')
        if Instructions{ii}.Value == 0
            Instructions(ii+1) = [];
        end
    end
    ii = ii + 1;
end

end

