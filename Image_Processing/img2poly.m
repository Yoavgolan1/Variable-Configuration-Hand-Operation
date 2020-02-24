function [Polygon, normpolyfactor,Centroid] = img2poly(snap, polytol,one_cm_is_X_pixels,showresults)
%IMG2POLY accepts an image, finds an object in it, and converts it to a polygon.
%   img2poly accepts an RGB image "snap", a fit tolerance for polygonal
%   appoximation "polytol", a ration between pixels and cm in the real
%   world "one_cm_is_X_pixels", and an option to show the results
%   "showresults". The lower the value of polytol, the better the
%   approximation, but the longer the runtime and noise of the polygon.
global Finger_Radius xyBlob
if nargin < 4
    showresults = false;
end
if nargin < 3
    one_cm_is_X_pixels = 12.549;
end
if nargin < 2
    polytol = 0.02;
end

img = autocontrast(snap); % Automatic contrast to optimum level (A = input, B = output)
img = flipud(img); % Flip the image

% Get recommended threshold
bwthresh = isodata(img);

img_gray = rgb2gray(img);
level = graythresh(img);
imgBW9 = imbinarize(img,level);

% Convert to black&white
imgBW = im2bw(img,bwthresh); %#ok<IM2BW>

imghsv = rgb2hsv(img);
imgS = imghsv(:,:,2);
level = graythresh(imgS);
imgBW10 = ~imbinarize(imgS,level);

imgBW = imgBW9(:,:,3);

imgBW = imgBW10;
% Remove empty spaces within the object
obj = 0.02; % = 1%
imgBW2 = bwareaopen(imgBW, round(obj*numel(imgBW)),4);

% Clean noise with disk using a "close" operation
Disk_Rad = floor(one_cm_is_X_pixels*Finger_Radius/10);
SE = strel('disk', Disk_Rad); 
imgBW3 = imclose(imgBW2,SE);
imshow(imgBW3);

%Transfer to configuration space by eroding the image (dilating the object)
SE = strel('disk', floor(one_cm_is_X_pixels*Finger_Radius/10)); 
imgBW3 = imerode(imgBW3,SE);

% Fine the object boundaries
xyBlob = bwboundaries(imgBW3);


% (xyBlob) returns two values. The first is the frame and second is the object boundaries.
%xyBlob = xyBlob{2};
xyBlobLength = zeros(length(xyBlob),1);
for ii=1:length(xyBlob)
    xyBlobLength(ii) = length(xyBlob{ii});
end
[val,~] = max(xyBlobLength(xyBlobLength<max(xyBlobLength)));
ind = find(val==xyBlobLength);
xyBlob = xyBlob{ind};

Centroid = [mean(xyBlob(:,2)),640-mean(xyBlob(:,1))];
Centroid = 10*Centroid/(one_cm_is_X_pixels); %Convert to mm
% Convert boundaries to polygon
[Polygon, ~] = Blob2Poly(xyBlob,polytol);
% Remove duplicate end
Polygon(end,:) = [];

normpolyfactor = 1/mean(mean(Polygon)); % move analysis to X-Y's ranging from 0~2 (normalization) (seems to run faster idk...)
Polygon = normpolyfactor*Polygon;
fprintf('____________________________________________');
fprintf('\n[#] Converted snapshot to polygon');

if showresults
    
    % show original image
    subplot(1,3,1)
    imshow(img);

    % show initial acquired borders
    subplot(1,3,2)
    imshow(imgBW2);
    hold on;
    plot(xyBlob(:,2),xyBlob(:,1))

   % show polygon approx.
    subplot(1,3,3)
    imshow(img)
    hold on
    plot(Polygon(:,1)/ normpolyfactor,Polygon(:,2)/ normpolyfactor,'r','LineWidth',2)
    hold off
    %pause
    %close all
    
end
