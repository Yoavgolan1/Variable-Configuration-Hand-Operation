function [object, object_type] = waitForConveyorObject(confidence_threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global cam
if nargin<1
    confidence_threshold = 0.95;
end
object_detected = false;
load('object_library.mat','library_of_objects');
load('meanBackground.mat','meanBackground');

while ~object_detected
    snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
    gray_snap = rgb2gray(snap) - meanBackground;
    gray_snap = gray_snap(2:end-1,2:end-1);
    %gray_snap = undistortImage(gray_snap', handCameraParams);
    %gray_snap = gray_snap';
    [blobs,~] = basicImg2Blob(gray_snap);
    [object, object_type, confidence] = bestBlobMatch(blobs,library_of_objects);
    %confidence
    if confidence>confidence_threshold
        object_detected = true;
        figure(1);
        %imshow(snap);
        %figure(2);
        imshow(gray_snap);
        disp([object_type.Name, ' detected.']);
    end
    if ~isempty(object)
        if confidence < confidence_threshold && (object.Centroid(1) > length(gray_snap(1,:))/3) && object.Centroid(1) < (length(gray_snap(1,:)) - length(gray_snap(1,:))/3) %if the object is in the center and the confidence is low, it must be a new object
            
            [new_x,new_y] = pixelXY2GlobalXY(object.Centroid);
            x_from_hand_center = new_x - (-195.033) -(-263.7);
            y_from_hand_center = new_y - (-967.724);
            disp(['x: ',num2str(x_from_hand_center),'     y: ',num2str(y_from_hand_center)]);
            %disp('New Type of object')
            return
            %object.Centroid
        end
    end
end

end

