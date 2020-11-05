b = InitArduino_Conveyor('COM4');
InitRoboDK_Conveyer();

setConveyorBeltSpeed(b,50);
robot.MoveJ(Above_Conveyor_Belt);

N_images = 10;

cam = webcam(2);
initSnap = rgb2gray(takeSnapshot(cam));
sumImage = double(initSnap);
for ii=2:N_images
    pause(0.5);
    sumImage = sumImage + double(rgb2gray(takeSnapshot(cam)));
end
meanBackground = uint8(sumImage / N_images);

clear cam

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/meanBackground.mat'];
save(filename,'meanBackground');