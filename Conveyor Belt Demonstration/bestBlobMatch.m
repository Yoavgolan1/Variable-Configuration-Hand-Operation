function [object, object_type, confidence] = bestBlobMatch(blobs,library_of_objects)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

N_blobs = numel(blobs);
N_library = numel(library_of_objects);
confidence_matrix = zeros(N_blobs,N_library);

for ii=1:N_blobs
    for jj=1:N_library
        confidence_matrix(ii,jj) = compareBlobs(blobs(ii),library_of_objects(jj));
    end
end
%[M,I] = max(confidence_matrix);
maximum = max(max(confidence_matrix));
[x,y]=find(confidence_matrix==maximum,1,'first');
confidence = maximum;
object_type = library_of_objects(y);
object = blobs(x);
end

