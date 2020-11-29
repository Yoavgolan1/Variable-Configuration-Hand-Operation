function [] = addObjectToLibrary(object_name,library_of_objects)
%ADDOBJECTTOLIBRARY enters a new object into the library.
%   The function takes an object name and an existing library, and adds a
%   blob object to the library wit hthe given name. THe blob is aquired by
%   snapshot. If no name is given, a randomized name is generated.
global cam one_mm_is_X_pixels N_Fingers
if nargin<2
    load('object_library.mat','library_of_objects');
end
if nargin<1
    object_name = ['Unknown_Object_',num2str(randi(1000))];
end
cam_on_flag = false;
if isempty('cam')
    cam = webcam();
    cam_on_flag = true;
end
load('meanBackground.mat','meanBackground');
load('handCameraParams.mat','handCameraParams');

snap = takeSnapshot(cam); %Requires MATLAB Webcam Addon
gray_snap = rgb2gray(snap) - meanBackground;
gray_snap = undistortImage(gray_snap', handCameraParams);
gray_snap = gray_snap';
[blob,img_BW] = basicImg2Blob(gray_snap);

if numel(blob) > 1
    if cam_on_flag
        clear cam
    end
    error('Unclean image. More than one object detected');
end

[Polygon, normpolyfactor,~] = BWimg2poly(imrotate(img_BW,-blob.Orientation),0.01,one_mm_is_X_pixels,1);
Poly_Center = mean(Polygon); %Center of the polygon in camera frame
Polygon = (1/normpolyfactor)*(Polygon - Poly_Center); %Zero the polygon center and rescale it
Poly_Center = Poly_Center/normpolyfactor;

BW_Image = flipud(imrotate(img_BW,-blob.Orientation));
SE = strel('disk', floor(one_mm_is_X_pixels*Finger_Radius));
BW_Image_dilated = imdilate(BW_Image,SE);
Object_Perimeter = bwperim(BW_Image_dilated);
Perim_blob = regionprops(Object_Perimeter,'Centroid');
Perim_Cent = Perim_blob.Centroid;

Perim_Cent_to_Poly_Cent_Vector = Poly_Center-Perim_Cent;
Polygon = Polygon + Perim_Cent_to_Poly_Cent_Vector;

P1.Vertex = Polygon;
MyConfigs = Monte_Carlo_Grasp_Configurations(N_Fingers,P1,0.01,50000,0.02,"SPHERE_VOLUME");
[Grasp_Center, Grasp_Finger_Placements] = Best_Grasp_That_Works(MyConfigs);

Possible_Hand_Configs = Grasp_To_Hand_Config(Grasp_Center,Grasp_Finger_Placements);


%Untilting the initial orientation
R = rotz(deg2rad(-blob.Orientation)); R = rotz(0);
R = R(1:2,1:2); %Only use the Z reorientation part of the matrix for 2D

%blob.Grasp_Center = Grasp_Center;
plot(Grasp_Center(1,1),Grasp_Center(1,2),'.k');
Untilted_Grasp_Center = Grasp_Center*R;
Untilted_Finger_Placements = Grasp_Finger_Placements*R;

blob.Name = object_name;
blob.Untilted_Grasp_Center = Untilted_Grasp_Center;
blob.Untilted_Finger_Placements = Untilted_Finger_Placements;
blob.N_Fingers_For_Analysis = N_Fingers;
for ii=1:length(Possible_Hand_Configs)
    Possible_Hand_Configs(ii).Center = Possible_Hand_Configs(ii).Center*R;
end
blob.Possible_Hand_Configs = Possible_Hand_Configs;
blob.Polygon = Polygon;

if isempty(library_of_objects)
    library_of_objects = blob;
else
    library_of_objects(end+1) = blob;
end

if cam_on_flag
    clear cam
end

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/object_library.mat'];
save(filename,'library_of_objects');

end

