function [Shape, Polygon] = Ploting_One_Shape_OneWall( Shape,Wall )
% This MATLAB function plots the initial workspace including the Polygon,
% Arms and walls. It is also converts the Polygon's Frame location into its
% enter mass, and its Vertices coordinates accordingly, using the MATLAB
% function 'center_mass'.

R = [ cos(Shape.teta) , -sin(Shape.teta) ; sin(Shape.teta) , cos(Shape.teta) ]; % R(teta) is the rotation matrix 

CM_body = center_mass(Shape); % CM_body is the center mass coordinates, in its own body frame.
CM = R*CM_body + Shape.d; % converts the center mass dimentions from body frame to the world frame.
  
Shape.d = CM;
Shape.Vertex(:,1) = Shape.Vertex(:,1) - ones(length(Shape.Vertex(:,1)),1)*CM_body(1);
Shape.Vertex(:,2) = Shape.Vertex(:,2) - ones(length(Shape.Vertex(:,2)),1)*CM_body(2);

ShapeWorldFrame = Shape.d*ones(1,length(Shape.Vertex(:,1)))+R*Shape.Vertex';

figure(1); subplot(1,2,1);
Polygon{1} = fill(ShapeWorldFrame(1,:) , ShapeWorldFrame(2,:) ,'r');
hold on; grid on; axis square;
Polygon{2} = plot(CM(1), CM(2),'k+');
axis([-30, 30, -30, 30])

if Wall.Num > 0
    Ploting_Walls(Wall);
end

hold off

end

