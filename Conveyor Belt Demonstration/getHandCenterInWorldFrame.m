function [GC_x, GC_y, GC_theta] = getHandCenterInWorldFrame(object,object_type)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global Best_Config
Base_Finger_XY_Rel = object_type.Untilted_Finger_Placements(1,:);
Base_Finger_Angle_Object_Frame = atan2(Base_Finger_XY_Rel(2),Base_Finger_XY_Rel(1));
Base_Finger_Angle_World_Frame = deg2rad(object.Orientation) + Base_Finger_Angle_Object_Frame + pi/2;

% UFP = object_type.Untilted_Finger_Placements;
% TFP = UFP*R;
% TFP = [TFP(:,1),-TFP(:,2)];
% FP = TFP + object.Centroid;
% fpp = plot(FP(:,1),FP(:,2),'om');
% 

GC_theta = Base_Finger_Angle_World_Frame;

GC_Object_Frame = Best_Config.Center;
R = rotz(deg2rad(-object.Orientation));
R = R(1:2,1:2);


GC_Rotated_Object_Frame = GC_Object_Frame*R;

GC_Rotated_Object_Frame = [GC_Rotated_Object_Frame(1),-GC_Rotated_Object_Frame(2)];
GC_Cam_Frame = GC_Rotated_Object_Frame + object.Centroid;

[GC_World_Frame(1),GC_World_Frame(2)] = pixelXY2GlobalXY(GC_Cam_Frame);
%[Object_centroid_x_WF,Object_centroid_y_WF] = pixelXY2GlobalXY(object.Centroid);
%GC_World_Frame = GC_Rotated_Object_Frame + [Object_centroid_x_WF,Object_centroid_y_WF];


% Hand_Center = object_type.Possible_Hand_Configs(1).Center;
% Hand_Center_Pixels = Hand_Center;
% R = rotz(deg2rad(-object.Orientation));
% R = R(1:2,1:2);
% Rotated_Hand_Center_Pixels = Hand_Center_Pixels*R;
% Rotated_Hand_Center_Pixels = [Rotated_Hand_Center_Pixels(1),-Rotated_Hand_Center_Pixels(2)];
% Hand_Center_Cam_Frame = Rotated_Hand_Center_Pixels + object.Centroid;
% 

GC_x = GC_World_Frame(1);
GC_y = GC_World_Frame(2);

end

