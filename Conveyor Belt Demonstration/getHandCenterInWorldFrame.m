function [GC_x, GC_y, GC_theta] = getHandCenterInWorldFrame(object)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global Grasp_Finger_Placements Best_Config
Base_Finger_XY_Rel = Grasp_Finger_Placements(1,:);
Base_Finger_Angle_Object_Frame = atan2(Base_Finger_XY_Rel(2),Base_Finger_XY_Rel(1));
Base_Finger_Angle_World_Frame = deg2rad(object.Orientation) + Base_Finger_Angle_Object_Frame;

GC_theta = Base_Finger_Angle_World_Frame;

GC_Object_Frame = Best_Config.Center;
R = rotz(deg2rad(object.Orientation));
R = R(1:2,1:2);

GC_Rotated_Object_Frame = GC_Object_Frame*R;
[Object_centroid_x_WF,Object_centroid_y_WF] = pixelXY2GlobalXY(object.Centroid);
GC_World_Frame = GC_Rotated_Object_Frame + [Object_centroid_x_WF,Object_centroid_y_WF];

GC_x = GC_World_Frame(1);
GC_y = GC_World_Frame(2);

end

