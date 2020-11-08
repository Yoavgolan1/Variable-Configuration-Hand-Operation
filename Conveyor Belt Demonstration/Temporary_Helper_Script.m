close all
openfig('Aux_Fig.fig');
figure(2)
imshow(object_type.StraightImage)
figure(3)
snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
gray_snap = rgb2gray(snap);
imshow(gray_snap)
hold on

Base_Finger_XY_Rel = object_type.Untilted_Finger_Placements(1,:);
Base_Finger_Angle_Object_Frame = atan2(Base_Finger_XY_Rel(2),Base_Finger_XY_Rel(1));
R = rotz(Base_Finger_Angle_Object_Frame + deg2rad(object.Orientation));
R = R(1:2,1:2);

centplt = plot(object.Centroid(1),object.Centroid(2),'xr');
hand_center_offset = (Best_Config.Center*R)/one_mm_is_X_pixels;
hand_center_pixels = object.Centroid + hand_center_offset;
handcentplt = plot(hand_center_pixels(1),hand_center_pixels(2),'xg');

F1_norm = [cos(Base_Finger_Angle_Object_Frame),sin(Base_Finger_Angle_Object_Frame)]*R;
F1_norm = F1_norm/norm(F1_norm);
F1 = F1_norm*Best_Config.Distances(1);
F1_Pixels = F1/one_mm_is_X_pixels;
F1_pxls_obj = F1_Pixels + hand_center_pixels;
line_f1 = plot([hand_center_pixels(1),F1_pxls_obj(1)],[hand_center_pixels(2),F1_pxls_obj(2)],'-y');

F2_norm = [cos(Base_Finger_Angle_Object_Frame+deg2rad(Best_Config.Abs_Angles(1))),...
    sin(Base_Finger_Angle_Object_Frame+deg2rad(Best_Config.Abs_Angles(1)))]*R;
F2_norm = F2_norm/norm(F2_norm);
F2 = F2_norm*Best_Config.Distances(2);
F2_Pixels = F2/one_mm_is_X_pixels;
F2_pxls_obj = F2_Pixels + hand_center_pixels;
line_f2 = plot([hand_center_pixels(1),F2_pxls_obj(1)],[hand_center_pixels(2),F2_pxls_obj(2)],'-y');

F3_norm = [cos(Base_Finger_Angle_Object_Frame+deg2rad(Best_Config.Abs_Angles(2))),...
    sin(Base_Finger_Angle_Object_Frame+deg2rad(Best_Config.Abs_Angles(2)))]*R;
F3_norm = F3_norm/norm(F3_norm);
F3 = F3_norm*Best_Config.Distances(3);
F3_Pixels = F3/one_mm_is_X_pixels;
F3_pxls_obj = F3_Pixels + hand_center_pixels;
line_f3 = plot([hand_center_pixels(1),F3_pxls_obj(1)],[hand_center_pixels(2),F3_pxls_obj(2)],'-y');

UFP = object_type.Untilted_Finger_Placements/one_mm_is_X_pixels;
TFP = UFP*R;
FP = TFP + hand_center_pixels;
fpp = plot(FP(:,1),FP(:,2),'om');

%delete(line_f1)
%delete(line_f2)
%delete(line_f3)
%delete(fpp)

