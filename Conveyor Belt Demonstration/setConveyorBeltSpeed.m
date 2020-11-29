function [] = setConveyorBeltSpeed(b,speed)
%SETCONVEYORBELTSPEED sends a goal speed to the conveyor belt controller
%   Goal speed is sent in mm/s by serial connection.

success = false;
for ii=1:5 %attempts
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

