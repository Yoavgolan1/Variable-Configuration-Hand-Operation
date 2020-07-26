function Instructions = Path2Instructions_time_eval(Hand_Configuration,Path)
%PATH2INSTRUCTINOS takes a distance change list, and transforms in into a
%cleaner list of instructions the system can follow.
Start = Hand_Configuration.Distances;
N_Steps = length(Path(:,1))-1;
N_Fingers = length(Path(1,:));
Steps = Path(2:end,:);

if isequal(round(Steps(1,:),3),round(Steps(2,:),3))
    Steps(1,:) = [];
    N_Steps = N_Steps-1;
end
Steps = [Start'; Steps];
Abs_Steps = Steps(2:end,:)- Steps(1:end-1,:);
Abs_Steps = round(Abs_Steps,3);

Finger_Presses = zeros(N_Steps,1);
[aa,bb]=find(~Abs_Steps);

Finger_Presses(aa) = bb - 1;
Instructions = [Abs_Steps(:,1),Finger_Presses];

end

