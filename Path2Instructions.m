function Instructions = Path2Instructions(Hand_Configuration,Path)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global Hand_Center_Finger_Center_Dist
Start = Hand_Configuration.Distances - Hand_Center_Finger_Center_Dist;
N_Steps = length(Path);
N_Fingers = length(Path(1).Location);
Steps = zeros(N_Steps,N_Fingers);
for ii=1:N_Steps
    Steps(ii,:) = Path(ii).Location;
end
%Steps(end,:) = Steps(end,:) - Hand_Center_Finger_Center_Dist; %not sure why this is needed
if isequal(round(Steps(1,:),3),round(Steps(2,:),3))
    Steps(1,:) = [];
    N_Steps = N_Steps-1;
end
%Abs_Steps = Steps - Start'
Steps = [Start'; Steps];
%Steps
Abs_Steps = Steps(2:end,:)- Steps(1:end-1,:);
%Abs_Steps
% for ii=2:N_Steps
   % Abs_Steps(ii-1,:) = Steps(ii,:) - Steps(ii-1,:); 
% end
Abs_Steps = round(Abs_Steps,3);

Finger_Presses = zeros(N_Steps,1);
[aa,bb]=find(~Abs_Steps);

Finger_Presses(aa) = bb - 1;
Instructions = [Abs_Steps(:,1),Finger_Presses];

end

