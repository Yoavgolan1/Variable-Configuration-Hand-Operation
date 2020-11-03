function [object, object_type] = waitForConveyorObject(b,confidence_threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin<1
    confidence_threshold = 0.5;
end
object_detected = false;
cam = webcam();
library_of_objects = load('object_library.mat');

while ~object_detected
    snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
    blobs = basicImg2Blob(snap);
    [object, object_type, confidence] = bestBlobMatch(blobs,library_of_objects);
    if confidence>confidence_threshold
        object_detected = true;
    end
end

end

