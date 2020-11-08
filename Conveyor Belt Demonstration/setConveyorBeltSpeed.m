function [] = setConveyorBeltSpeed(b,speed)

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

success = false;
 
for ii=1:5 %attempts
    %writedata=uint16(speed);
    %fwrite(b,writedata,'uint16') %write data
    fprintf(b,num2str(speed));
    response = fscanf(b);
    if ~isempty(response)
        disp(response(1:end-2))
    end
    if isequal(response(1:5),'Speed')
        return
    end
    disp('Connection failed. Retrying...');
    pause(1);
end
if ~success
    warning('Conveyor belt speed not set');
end

flush(b,"input")
end

