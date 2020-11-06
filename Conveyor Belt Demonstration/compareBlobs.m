function [confidence,corrected_blob] = compareBlobs(blob,lib_obj)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

errArea = (blob.Area - lib_obj.Area)/lib_obj.Area;
errMajorAxisLength = (blob.MajorAxisLength - lib_obj.MajorAxisLength)/lib_obj.MajorAxisLength;
errMinorAxisLength = (blob.MinorAxisLength - lib_obj.MinorAxisLength)/lib_obj.MinorAxisLength;
errEccentricity = (blob.Eccentricity - lib_obj.Eccentricity)/lib_obj.Eccentricity;
errEquivDiameter = (blob.EquivDiameter - lib_obj.EquivDiameter)/lib_obj.EquivDiameter;
errPerimeter = (blob.Perimeter - lib_obj.Perimeter)/lib_obj.Perimeter;
errCircularity = (blob.Circularity - lib_obj.Circularity)/lib_obj.Circularity;

intersection = blob.StraightImage~=lib_obj.StraightImage;
intersection_flipped = imrotate(blob.StraightImage,180)~=lib_obj.StraightImage;

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

errs = [errArea, errMajorAxisLength, errMinorAxisLength, errEccentricity,...
    errEquivDiameter, errPerimeter, errCircularity];
N_errs = numel(errs);

SSE = sqrt(sum(errs.^2));

confidence = 1 - min(SSE/N_errs,1);
corrected_blob = blob;
end

