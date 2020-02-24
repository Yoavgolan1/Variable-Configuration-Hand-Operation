%% Initialize
clear all
close all
warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId')
load('MyShapes.mat')

for jj=1:100
%% Create polygon
[xs,ys,dts]=simple_polygon(randi([3,8]));
Shape.Vertex = [xs(1:end-1),ys(1:end-1)]-.5;
while ~inpolygon(0,0,xs-.5,ys-.5)
    [xs,ys,dts]=simple_polygon(randi([3,8]));
    Shape.Vertex = [xs(1:end-1),ys(1:end-1)]-.5;
end
%Saved_Shapes(jj) = Shape;
Shape=Saved_Shapes(jj);
N_Fingers       = 3;        % Number of fingers
Mu              = 0.001;      % Coefficient of friction

%% Monte Carlo settings
SGrid = 1000;           % Polygon's perimeter grid points
Bets = 50000;

Guessed_Locations = ceil(unifrnd(0,SGrid,N_Fingers,Bets));

[No_Fric_Vol(jj),No_Fric_Location(:,jj)] = Search_Grasp(Shape,N_Fingers,Mu,SGrid,Bets,Guessed_Locations,0);

Mu   = 0.4; 
[Best_Fric_Vol(jj),Best_Fric_Location(:,jj)] = Search_Grasp(Shape,N_Fingers,Mu,SGrid,Bets,Guessed_Locations,0);

[Fric_Vol_At_No_Fric(jj),~] = Search_Grasp(Shape,N_Fingers,Mu,SGrid,Bets,No_Fric_Location(:,jj),0);
pause(0.01)


jj
end

%% Call the grasp function
% Mus = linspace(0.0001,1,1000);
% My_Ellipse_Vol = zeros(length(Mus),1);
% for ii=1:1000
%     Mu = Mus(ii)
%     [My_Ellipse_Vol(ii),Location] = Search_Grasp(Shape,N_Fingers,Mu,SGrid,Bets,No_Fric_Location(:,end),0);
% end