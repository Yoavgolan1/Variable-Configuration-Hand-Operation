function [attached_item] = Grasp_Item(item)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global robot RDK safe_height digits station tool MODE

adjustments = item.Pre_Grasp_Dist - item.Grasp_Dist;
amount_to_close = mean(adjustments);
fingers_to_close = 0;
for ii=1:length(adjustments)-1
    if adjustments(ii+1)
        fingers_to_close = [fingers_to_close,ii];
    end
end

N_digits = length(item.Angles);

for ii=1:N_digits
    if digits(ii+1).angle ~= item.Angles(ii)
        Reorient_Finger(ii,item.Angles(ii));
        pause(0.5);
    end
end
Hand_Adjust(item.Angles,item.Pre_Grasp_Dist);


robot.MoveL(item.Above_Frame);

grasping_pos = transl(0,0,-safe_height)*item.Above_Frame.Pose();
robot.MoveL(grasping_pos);

if isequal(MODE,'REAL_ROBOT')
    step = 0;
else
    step = 1; %Visualization of the fingers closing, 1mm resolution.
end
    
Close_Fingers(fingers_to_close,amount_to_close,step);
%Hand_Adjust(item.Angles,item.Grasp_Dist);
pause(1);

attached_item = tool.AttachClosest();
if attached_item.Valid()
    attachedname = attached_item.Name();
    fprintf('Attached: %s\n', attachedname);
else
    % The tolerance can be changed in:
    % Tools->Options->General tab->Maximum distance to attach an object to
    % a robot tool (default is 1000 mm)
    fprintf('No object is close enough\n');
end

robot.MoveL(item.Above_Frame);

end

