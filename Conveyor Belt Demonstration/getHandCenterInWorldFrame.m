function [GC_x, GC_y, GC_theta] = getHandCenterInWorldFrame(object,object_type)
%GETHANDCENTERINWORLDFRAME returns the hand center and orientation in the
%world frame, in mm
%   The function takes a blob object and the object type, and returns the
%   x,y, and orientation of the hand center suited to grasp the object.

global Best_Config
Base_Finger_XY_Rel = object_type.Untilted_Finger_Placements(1,:);
Base_Finger_Angle_Object_Frame = atan2(Base_Finger_XY_Rel(2),Base_Finger_XY_Rel(1));
Base_Finger_Angle_World_Frame = deg2rad(object.Orientation) + Base_Finger_Angle_Object_Frame + pi/2;

GC_theta = Base_Finger_Angle_World_Frame;
GC_Object_Frame = Best_Config.Center;
R = rotz(deg2rad(-object.Orientation));
R = R(1:2,1:2);

GC_Rotated_Object_Frame = GC_Object_Frame*R;

GC_Rotated_Object_Frame = [GC_Rotated_Object_Frame(1),-GC_Rotated_Object_Frame(2)];
GC_Cam_Frame = GC_Rotated_Object_Frame + object.Centroid;

[GC_World_Frame(1),GC_World_Frame(2)] = pixelXY2GlobalXY(GC_Cam_Frame);

GC_x = GC_World_Frame(1);
GC_y = GC_World_Frame(2);

end

