function blobs = basicImg2Blob(snap)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
img = autocontrast(snap); % Automatic contrast to optimum level (A = input, B = output)
%img = flipud(img);
imghsv = rgb2hsv(img);
imggray = rgb2gray(img);
imgS = imghsv(:,:,2);
%level = graythresh(imgS);
%imgBW = imbinarize(imgS,level);

imgBW = imbinarize(imggray);
% Remove empty spaces within the object
obj = 0.02; % = 1%
imgBW2 = bwareaopen(imgBW, round(obj*numel(imgBW)));
imgBW2 = imfill(imgBW2, 'holes');

labeledImage = bwlabel(imgBW2, 8);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
blobMeasurements = regionprops(labeledImage, imgBW, 'all');
numberOfBlobs = size(blobMeasurements, 1);

blobs = blobMeasurements;
% Clean noise with disk using a "close" operation
% Disk_Rad = floor(0.01*length(imgBW));
% SE = strel('disk', Disk_Rad);
% imgBW3 = imclose(imgBW2,SE);
% imshow(imgBW3);

end

