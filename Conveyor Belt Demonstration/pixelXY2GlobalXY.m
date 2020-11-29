function [X,Y] = pixelXY2GlobalXY(x,y)
%PIXELXY2GLOBALXY takes a camera frame point and converts it to a world
%frame point in mm. 
%   This function assumes that the camera is at the default conveyor belt
%   camera position.
global cam RDK one_mm_is_X_pixels
if nargin < 2
    y = x(2);
    x = x(1);
end
RES_STR = cam.Resolution;
x_loc = find(RES_STR=='x');
RES_X = str2double(RES_STR(1:x_loc-1));
RES_Y = str2double(RES_STR(x_loc+1:end));
RES = [RES_Y,RES_X];

%base_frame = RDK.Item('Motoman UP6 Base');
cam_frame = RDK.Item('Static Camera');
pose = cam_frame.PoseAbs();
cam_x = pose(1,4);
cam_y = pose(2,4);

img_center = RES./2;

x = x - img_center(1);
y = y - img_center(2);

x_mm_cam_frame = x / one_mm_is_X_pixels;
y_mm_cam_frame = -y / one_mm_is_X_pixels;

X = x_mm_cam_frame + cam_x;
Y = y_mm_cam_frame + cam_y;

end

