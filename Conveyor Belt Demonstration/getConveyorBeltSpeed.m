function [] = getConveyorBeltSpeed(b)

%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
fprintf(b,num2str(10000)); %code for get speed
for ii=1:5
    response = fscanf(b);
    if isequal(response(1:5),'Speed')
        continue
    end
    if ~isempty(response)
        disp(response(1:end-2))
        return
    end
    disp('Connection failed. Retrying...');
    pause(1);
end

