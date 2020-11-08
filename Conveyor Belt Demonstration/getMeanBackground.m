b = InitArduino_Conveyor('COM9');
%InitRoboDK_Conveyer();

setConveyorBeltSpeed(b,20);
%robot.MoveJ(Above_Conveyor_Belt);

N_images = 100;

cam = webcam();
%load('handCameraParams.mat','handCameraParams');

initSnap = rgb2gray(takeSnapshot(cam));
sumImage = double(initSnap);
for ii=2:N_images
    pause(0.5);
    sumImage = sumImage + double(rgb2gray(takeSnapshot(cam)));
    ii
end
meanBackground = uint8(sumImage / N_images);

clear cam

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/meanBackground.mat'];
save(filename,'meanBackground');