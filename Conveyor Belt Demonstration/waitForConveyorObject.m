function [object, object_type] = waitForConveyorObject(confidence_threshold)
%WAITFORCONVEYOROBJECT runs until an object is detected by the hand camera
%   The function will run until either an object is detected that is part
%   of the object library, or until an unknown object is added to the
%   library. The function returns the object blob parameters, as well as
%   the object type from the library. A confidence threshold serves as the
%   classifier for known/unknown objects.
global cam
if nargin<1
    confidence_threshold = 0.95;
end
object_detected = false;
load('object_library.mat','library_of_objects');
load('meanBackgroundRGB.mat','meanBackgroundRGB');

while ~object_detected
    snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
    snap = snap - meanBackgroundRGB;
    gray_snap = rgb2gray(snap);
    gray_snap = gray_snap(2:end-1,2:end-1);
    %gray_snap = undistortImage(gray_snap', handCameraParams);
    %gray_snap = gray_snap';
    [blobs,~] = basicImg2Blob(gray_snap);
    [object, object_type, confidence] = bestBlobMatch(blobs,library_of_objects);
    if confidence>0
        disp(['Confidence: ',num2str(confidence)]);
    end
    if confidence>confidence_threshold
        object_detected = true;
        disp([object_type.Name, ' detected.']);
    end
    if ~isempty(object)
        if confidence < confidence_threshold && (object.Centroid(1) > length(gray_snap(1,:))/3) && object.Centroid(1) < (length(gray_snap(1,:)) - length(gray_snap(1,:))/3) %if the object is in the center and the confidence is low, it must be a new object
            disp('New Type of object')
            addObjectToLibrary();
        end
    end
    if confidence_threshold==0
        break
    end
end

end

