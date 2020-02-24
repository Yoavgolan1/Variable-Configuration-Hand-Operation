function [ Shape ] = Force_Activator_OneWall( Shape, Wall, GraspingArm, Force,Polygon)
% This MATLAB function is a simulation of polygon's trajectory while
% activating external forces on it. 

dx = 1*10^-3;
dt = 0.01;
dt_plot = 0.1;
D = [1 ; 1];            % Linear and angular restrain
time = 0;
state_vec = [ Shape.d; Shape.teta; 0; 0; 0];

RotMat = @(x) [cos(x), -sin(x); sin(x), cos(x)]; % Rotation matrix
R = RotMat(Shape.teta);

Last_teta = 10; Last_d = [100; 100];

%% Third version: frictional force.
% while 1

    % Wall info
    if ~exist('Wall.K','var')
        Wall.K = 350;
    end

    % Force info
    if ~exist('Force.Time','var')
        Force.Time = 5*dt;
    end
    if ~exist('Force.Boost','var')
        Force.Boost = 8; 
    end
    if ~exist('Force.TorqueDamp','var')
        Force.TorqueDamp = 0.1; 
    end  
    
    
    Force.Vector = Force.Boost*Force.Direction;
    Torque = [0 0 Force.TorqueDamp]*cross([Force.Location - Shape.d ; 0], [Force.Vector ; 0]);
    
    Wall.Force = [0 ; 0]; Wall.Torque = 0;
    tic
    while time < 30 % Simulation
        
        if time > Force.Time
            Force.Vector = [0 0]'; Torque = 0;
            if norm(dt*state_vec_dot(1:3)) < dx  % Loop's end condition
                break; 
            end
        end
        
        % Wall Collision Detection and Force Compute
        if Wall.Num
            [Shape, Wall] = Collision_Force(Shape,Wall); %,state_vec(4:6));
        end
        
        % state_vec_dot is the f(x) vector.
        state_vec_dot = [state_vec(4); state_vec(5); state_vec(6);...
            ((Force.Vector + [sum(Wall.Force(1,:)); ...
            sum(Wall.Force(2,:))])/Shape.m-D(1)*state_vec(4:5)); ...
            ((Torque + Wall.Torque)/Shape.I-D(2)*state_vec(6))];
   
        % Comuptes current itteration 
        time = time + dt;
        state_vec = state_vec + dt*state_vec_dot;
        Shape.d = state_vec(1:2);
        Shape.teta = mod(state_vec(3),2*pi); % Fixes teta if bigger than 2*pi or smaller than 0.
        R = RotMat(Shape.teta);
        
        if  mod(time,dt_plot) <= dt  %% Plot every 'dt_plot' sec 
            ShapeWorldFrame = [R*Shape.Vertex' + Shape.d*ones(1,length(Shape.Vertex(:,1))); zeros(1,length(Shape.Vertex(:,1)))];
            
            Polygon{1}.XData = ShapeWorldFrame(1,:)'; Polygon{1}.YData = ShapeWorldFrame(2,:)';
            Polygon{2}.XData = Shape.d(1); Polygon{2}.YData = Shape.d(2); 
%             title(TaskSpace,['Shape Location After ',num2str(round(toc,1)), ' Sec'])
            drawnow
            
            subplot(1,2,2)
            Configuration_Space_Trajectory(Shape.teta, Last_teta, Shape.d, Last_d);
            Last_d = Shape.d; Last_teta = Shape.teta;
        end 
    end
% end


end
