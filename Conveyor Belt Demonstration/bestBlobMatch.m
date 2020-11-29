function [object, object_type, confidence] = bestBlobMatch(blobs,library_of_objects)
%BESTBLOBMATCH compares a blob to a library of objects. 
%   The function performes a blob comparison by certain criteria. The input
%   blob/s is compared to the objects in the object library. The confidence
%   score for each comparison is returned, as well as the best suiting
%   object type from the library. The object itself may have its
%   orientation flipped to better suit the library match (+-180 degrees).

N_blobs = numel(blobs);
N_library = numel(library_of_objects);
confidence_matrix = zeros(N_blobs,N_library);

for ii=1:N_blobs
    for jj=1:N_library
        [confidence_matrix(ii,jj),blobs(ii)] = compareBlobs(blobs(ii),library_of_objects(jj));
    end
end
%confidence_matrix
maximum = max(max(confidence_matrix));
[x,y]=find(confidence_matrix==maximum,1,'first');
confidence = maximum;
object_type = library_of_objects(y);
if numel(library_of_objects(y)) > 0
    [~,object] = compareBlobs(blobs(x),library_of_objects(y),1);
else
    object = blobs(x);
end

if isempty(confidence)
    confidence = 0;
end
end

