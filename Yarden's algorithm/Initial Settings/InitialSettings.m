%% InitialSettings

clear; clc; clf;
General_Shapes_Information
Force_Information
Walls_Information
Arm_Information_Grasp                               % Grasping Arm

if ~exist('Wall','var')
    Wall.Num = 0; Wall.K = 0; Wall.Torque = 0; Wall.Force = [0 0]';
end

figure(1); figure(2); figure(4);

% Work Space & Conf Space initialize   
figure(1); subplot(1,2,1);
[Shape, Poly] = Ploting_One_Shape(Shape, Wall);

ConfPlot = subplot(1,2,2); cla; box on;
set(ConfPlot,'BoxStyle','full','Color',[0.729, 0.831,0.957]);
view(3); grid on; axis([-70 70 -70 70 0 7]);
xlabel('X'); ylabel('Y'); zlabel('\theta');
% title('Configuration Space')

%% temp
[Wall, GraspingArm] = Configuration_Space_Compute(Shape, Wall, GraspingArm );
Configuration_Space_Plot( Wall, GraspingArm);


