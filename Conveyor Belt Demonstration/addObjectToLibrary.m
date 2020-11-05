function [] = addObjectToLibrary(object_name,library_of_objects)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global cam
if nargin<2
    load('object_library.mat','library_of_objects');
end
cam_on_flag = false;
if isempty('cam')
    cam = webcam(2);
    cam_on_flag = true;
end
load('meanBackground.mat','meanBackground');

snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
gray_snap = rgb2gray(snap) - meanBackground;
blobs = basicImg2Blob(gray_snap);

if numel(blobs) > 1
    if cam_on_flag
        clear cam
    end
    error('Unclean image. More than one object detected');
end

blobs.Name = object_name;
if isempty(library_of_objects)
    library_of_objects = blobs;
else
    library_of_objects(end+1) = blobs;
end

if cam_on_flag
    clear cam
end

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/object_library.mat'];
save(filename,'library_of_objects');

end

