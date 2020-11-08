function [confidence,corrected_blob] = compareBlobs(blob,lib_obj)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

errArea = (blob.Area - lib_obj.Area)/lib_obj.Area;
errMajorAxisLength = (blob.MajorAxisLength - lib_obj.MajorAxisLength)/lib_obj.MajorAxisLength;
errMinorAxisLength = (blob.MinorAxisLength - lib_obj.MinorAxisLength)/lib_obj.MinorAxisLength;
%errEccentricity = (blob.Eccentricity - lib_obj.Eccentricity)/lib_obj.Eccentricity;
%errEquivDiameter = (blob.EquivDiameter - lib_obj.EquivDiameter)/lib_obj.EquivDiameter;
errPerimeter = (blob.Perimeter - lib_obj.Perimeter)/lib_obj.Perimeter;
%errCircularity = (blob.Circularity - lib_obj.Circularity)/lib_obj.Circularity;

BSI = blob.StraightImage;
LISI = lib_obj.StraightImage;
if ~isequal(size(BSI),size(LISI))
    %rows
    if length(BSI(:,1)) > length(LISI(:,1))
        amount = length(BSI(:,1)) - length(LISI(:,1));
        remainder = mod(amount,2);
        BSI = BSI(1+floor(amount/2):end-floor(amount/2)-remainder,:);
    elseif length(BSI(:,1)) < length(LISI(:,1))
        amount = length(LISI(:,1)) - length(BSI(:,1));
        remainder = mod(amount,2);
        LISI = LISI(1+floor(amount/2):end-floor(amount/2)-remainder,:);
    end
    %columns
    if length(BSI(1,:)) > length(LISI(1,:))
        amount = length(BSI(1,:)) - length(LISI(1,:));
        remainder = mod(amount,2);
        BSI = BSI(:,1+floor(amount/2):end-floor(amount/2)-remainder);
    elseif length(BSI(1,:)) < length(LISI(1,:))
        amount = length(LISI(1,:)) - length(BSI(1,:));
        remainder = mod(amount,2);
        LISI = LISI(:,1+floor(amount/2):end-floor(amount/2)-remainder);
    end
end

intersection = BSI~=LISI;
intersection_flipped = imrotate(BSI,180)~=LISI;

image_compare_err = sum(sum(intersection))/numel(intersection);
flipped_image_compare_err = sum(sum(intersection_flipped))/numel(intersection_flipped);

if image_compare_err > flipped_image_compare_err %The rotated image works better
    if blob.Orientation<0
        blob.Orientation = blob.Orientation + 180;
    else
        blob.Orientation = blob.Orientation - 180;
    end
    image_compare_err = flipped_image_compare_err;
end

errs = [errArea, errMajorAxisLength, errMinorAxisLength,...
    errPerimeter, image_compare_err];
N_errs = numel(errs);

SSE = sqrt(sum(errs.^2));

confidence = 1 - min(SSE/N_errs,1);
corrected_blob = blob;
end

