function [] = Set_In_Box(item)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global RDK robot station MODE

cb = RDK.Item('Cardboard Box');
robot.MoveL(transl(50,0,200)*cb.Pose());

adjustments = item.Pre_Grasp_Dist - item.Grasp_Dist;
amount_to_open = -mean(adjustments);
fingers_to_open = 0;
for ii=1:length(adjustments)-1
    if adjustments(ii+1)
        fingers_to_open = [fingers_to_open,ii];
    end
end
if isequal(MODE,'REAL_ROBOT')
    step = 0;
else
    step = 1; %Visualization of the fingers closing, 1mm resolution.
end
Close_Fingers(fingers_to_open,amount_to_open,step);
%Hand_Adjust(item.Angles,item.Pre_Grasp_Dist);

item.Item.setParentStatic(station);
res = 10;
falling = -200/res;
for ii=1:res
    item.Item.setPose(transl(0,0,falling)*item.Item.Pose());
    pause(0.1);
end

