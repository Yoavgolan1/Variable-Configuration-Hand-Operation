function [blobs,BW_Image] = basicImg2Blob(imggray)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global Finger_Radius one_mm_is_X_pixels
%img = autocontrast(snap); % Automatic contrast to optimum level (A = input, B = output)
%img = flipud(img);
%imghsv = rgb2hsv(img);
%imggray = rgb2gray(img);
%imgS = imghsv(:,:,2);
level = graythresh(imggray);
%imgBW = imbinarize(imgS,level);

%imgBW = imbinarize(imggray,max(0.2,level));
imgBW = imbinarize(imggray, 0.02);
% Remove empty spaces within the object
obj = 0.02; % = 1%
imgBW2 = bwareaopen(imgBW, round(obj*numel(imgBW)));
imgBW2 = imfill(imgBW2, 'holes');

imgBW2 = imclearborder(imgBW2);
load('handCameraParams.mat','handCameraParams');


if handCameraParams.ImageSize(1) > length(imgBW(1,:))
    BW_Image = zeros(size(imgBW2')+2);
    BW_Image(2:end-1,2:end-1) = imgBW2';
else
    BW_Image = imgBW2';
end
BW_Image = undistortImage(BW_Image, handCameraParams);
BW_Image = BW_Image';
%BW_Image = imgBW2;
%figure
%imshow(BW_Image);
%labeledImage = bwlabel(imgBW2, 8);
%coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
%blobMeasurements = regionprops(imgBW2, imgBW, 'all'); %older
blobMeasurements = regionprops(BW_Image,'Area','Centroid','Eccentricity',...
    'EquivDiameter','MajorAxisLength','MinorAxisLength',...
    'Orientation','Perimeter');
if ~isempty(blobMeasurements)
    blobMeasurements.Circularity = (4*blobMeasurements.Area*pi)/(blobMeasurements.Perimeter^2); 
    %numberOfBlobs = size(blobMeasurements, 1);
    rotated_img = imrotate(BW_Image,-blobMeasurements.Orientation);
    straightened_image = regionprops(rotated_img,'Image');
    blobMeasurements.StraightImage = straightened_image.Image;
    
    %Replace the area centroid with perimeter centroid
    SE = strel('disk', floor(one_mm_is_X_pixels*Finger_Radius));
    BW_Image_dilated = imdilate(BW_Image,SE);
    
    Perim = bwboundaries(BW_Image_dilated);
    Perim = Perim{1};
    Mean_Perim = mean(Perim);
    Mean_Perim = [Mean_Perim(2),length(BW_Image_dilated(:,1))-Mean_Perim(1)];
    
    Object_Perimeter = bwperim(BW_Image_dilated);
    Perim_blob = regionprops(Object_Perimeter,'Centroid');
    Perim_Cent = Perim_blob.Centroid;
    blobMeasurements.Centroid = Perim_Cent; 
end
blobs = blobMeasurements;
% Clean noise with disk using a "close" operation
% Disk_Rad = floor(0.01*length(imgBW));
% SE = strel('disk', Disk_Rad);
% imgBW3 = imclose(imgBW2,SE);
% imshow(imgBW3);

end

