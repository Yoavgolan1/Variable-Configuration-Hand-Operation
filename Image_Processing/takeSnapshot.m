function [snap] = takeSnapshot(cam)

%Take a snapshop
% load cameraParams % if camera calibration is needed

snap = snapshot(cam);
load('cameraParamsNew.mat');
[snap, ~] = undistortImage(snap, cameraParamsNew);

rect = [  20   50  600  360];

%snap = imcrop(snap,rect);

snap = imrotate(snap,90); 

end

