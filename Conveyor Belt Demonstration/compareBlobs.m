function confidence = compareBlobs(blob,lib_obj)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

errArea = (blob.Area - lib_obj.Area)/lib_obj.Area;
errMajorAxisLength = (blob.MajorAxisLength - lib_obj.MajorAxisLength)/lib_obj.MajorAxisLength;
errMinorAxisLength = (blob.MinorAxisLength - lib_obj.MinorAxisLength)/lib_obj.MinorAxisLength;
errEccentricity = (blob.Eccentricity - lib_obj.Eccentricity)/lib_obj.Eccentricity;
errEquivDiameter = (blob.EquivDiameter - lib_obj.EquivDiameter)/lib_obj.EquivDiameter;
errPerimeter = (blob.Perimeter - lib_obj.Perimeter)/lib_obj.Perimeter;

errs = [errArea, errMajorAxisLength, errMinorAxisLength, errEccentricity,...
    errEquivDiameter, errPerimeter];
N_errs = numel(errs);

SSE = sqrt(sum(errs.^2));

confidence = 1 - min(SSE/N_errs,1);

end

