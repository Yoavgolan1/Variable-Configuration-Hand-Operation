function [object, object_type] = waitForConveyorObject(confidence_threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global cam
if nargin<1
    confidence_threshold = 0.5;
end
object_detected = false;
load('object_library.mat','library_of_objects');
load('meanBackground.mat','meanBackground');
load('handCameraParams.mat','handCameraParams');

while ~object_detected
    snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
    snap = undistortImage(snap, handCameraParams);
    gray_snap = rgb2gray(snap) - meanBackground;
    [blobs,~] = basicImg2Blob(gray_snap);
    [object, object_type, confidence] = bestBlobMatch(blobs,library_of_objects);
    confidence
    if confidence>confidence_threshold
        object_detected = true;
        figure(1);
        %imshow(snap);
        %figure(2);
        imshow(gray_snap);
        disp([object_type.Name, ' detected.']);
    end
end

end

