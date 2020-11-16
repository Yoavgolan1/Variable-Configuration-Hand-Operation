b = InitArduino_Conveyor('COM9');
%InitRoboDK_Conveyer();

setConveyorBeltSpeed(b,20);
%robot.MoveJ(Above_Conveyor_Belt);

N_images = 100;

cam = webcam();
%load('handCameraParams.mat','handCameraParams');

initSnap = takeSnapshot(cam);
sumImage = double(initSnap);
for ii=2:N_images
    pause(0.5);
    sumImage = sumImage + double(takeSnapshot(cam));
    ii
end
meanBackgroundRGB = uint8(sumImage / N_images);

clear cam

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/meanBackgroundRGB.mat'];
save(filename,'meanBackgroundRGB');