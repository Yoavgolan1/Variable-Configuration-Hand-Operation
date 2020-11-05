function [X,Y] = pixelXY2GlobalXY(x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global cam RDK
if nargin < 2
    y = x(2);
    x = x(1);
end
one_mm_is_X_pixels = (640-18)/420;
RES_STR = cam.Resolution;
x_loc = find(RES_STR=='x');
RES_X = str2double(RES_STR(1:x_loc-1));
RES_Y = str2double(RES_STR(x_loc+1:end));
RES = [RES_Y,RES_X];

%base_frame = RDK.Item('Motoman UP6 Base');
cam_frame = RDK.Item('Camera');
pose = cam_frame.PoseAbs();
cam_x = pose(1,4);
cam_y = pose(2,4);

img_center = RES./2;

x = x - img_center(1)
y = y - img_center(2)

x_mm_cam_frame = x * one_mm_is_X_pixels
y_mm_cam_frame = -y * one_mm_is_X_pixels

X = x_mm_cam_frame + cam_x
Y = y_mm_cam_frame + cam_y

end

