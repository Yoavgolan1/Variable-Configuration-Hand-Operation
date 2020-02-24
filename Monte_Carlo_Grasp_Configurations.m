function [Sorted_List_Of_Grasps] = Monte_Carlo_Grasp_Configurations(Number_Of_Fingers,Polygon2,Friction_Coefficient,Bets,Division,Quality_Measure)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global Polygon
Polygon = Polygon2;
if nargin<6 || (Quality_Measure ~= "SPHERE_VOLUME")
    Quality_Measure = "ELLIPSE_VOLUME";
end
if nargin<5
    Division = 0.1; %mm
end
if nargin<4
    Bets = 50000;
end
if nargin<3
    Friction_Coefficient = 0.1;
end
if nargin<2
    [xs,ys,dts]=simple_polygon(randi([3,8]));
    Shape.Vertex = [xs(1:end-1),ys(1:end-1)]-.5;
    Shape.Vertex = Shape.Vertex * 200; %Scale up
    while ~inpolygon(0,0,xs-.5,ys-.5)
        [xs,ys,dts]=simple_polygon(randi([3,8]));
        Shape.Vertex = [xs(1:end-1),ys(1:end-1)]-.5;
        Shape.Vertex = Shape.Vertex * 200; %Scale up
    end
    Polygon = Shape;
end
if nargin<1
    Number_Of_Fingers = 3;
end
fprintf('\nCalculating randomized grasps...\n');
Shape = Polygon;
Polygon_Perimeter = perimeter(polyshape(Shape.Vertex));
warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId')

GraspingArm.Num = Number_Of_Fingers;        % Number of fingers
GraspingArm.Mu  = Friction_Coefficient;      % Coefficient of friction
%% Monte Carlo settings
SGrid = round(Polygon_Perimeter/Division);           % Polygon's perimeter grid points
%Bets are a function Parameter

%% Construction of the computational grid
% instead '~' use ShapeEdgeNum(Not yet neccesary)
[ShapeCorr, ShapeIntDir, ShapeEdgeNum] = Shape_Edge_Grid(Shape, SGrid);

%% Grasp Map Possibilities
Ind                 = 1;
JPos                = [0 1 0; -1 0 0; 0 0 1];   %  90 deg Rotation Matrix.

plot([Shape.Vertex(:,1);Shape.Vertex(1,1)],[Shape.Vertex(:,2);Shape.Vertex(1,2)])
hold on
axis equal

FingerConfiguration = zeros(GraspingArm.Num,Bets);

%List_Of_Grasps = {};
for ii = 1:Bets
    
    FingerConfiguration(1:GraspingArm.Num,ii) = ceil(unifrnd(0,SGrid,GraspingArm.Num,1));
    
    %%%% Construction of the current Grasp Map
    Tempr = [ShapeCorr(FingerConfiguration(:,ii),:)'; zeros(1,GraspingArm.Num)];
    Tempn = [ShapeIntDir(FingerConfiguration(:,ii),:)'; zeros(1,GraspingArm.Num)];
    
    Tempf1 = JPos*Tempn*GraspingArm.Mu + Tempn;
    Tempf2 = -JPos*Tempn*GraspingArm.Mu + Tempn;
    
    TempTorquef1 = cross(Tempr,Tempf1);
    TempTorquef2 = cross(Tempr,Tempf2);
    
    TempGf1 = TempTorquef1 + Tempf1;
    TempGf2 = TempTorquef2 + Tempf2;
    
    TempG = [TempGf1(1:3,:), TempGf2(1:3,:)];
    
    %%%% Checks if G is full rank matrix
    if rank(TempG) == min(size(TempG))
        
        %%%% Delaunay Triangulation of the Grasp Map
        TempDT = delaunayTriangulation(TempG');
        
        %%%% Checks if there is any Tetrahedron exist
        if min(size(TempDT)) > 0
            
            %%%% Checks if the Origin is inside the Convex Hull
            if ~isnan(pointLocation(TempDT,[0 0 0]))
                
                ThisGrasp.Index = Ind;
                ThisGrasp.Configuration = Tempr(1:end-1,:)';
                
                if Quality_Measure == "ELLIPSE_VOLUME"
                    D = eig(TempG*TempG');
                    Temp_Ellipse_Vol = D(1)*D(2)*D(3);
                    ThisGrasp.Quality = Temp_Ellipse_Vol;
                end
                
                if Quality_Measure == "SPHERE_VOLUME"
                    [TempConvHull,Xb] = freeBoundary(TempDT);
                    TempTR = triangulation(TempConvHull,Xb);
                    TempFaceNormal = faceNormal(TempTR);
                    %%%% Search for the closest Convex Hull surface
                    sz = size(TempTR);
                    clear d
                    d = zeros(1,sz(1));
                    for jj = 1:sz(1)
                        Plane = TempTR.ConnectivityList(jj,:);
                        d(jj) = sum(TempFaceNormal(jj,:).*TempTR.Points(Plane(1),:));
                    end
                    TempRad = min(d);
                    ThisGrasp.Quality = TempRad;
                end
                
                List_Of_Grasps(Ind) = ThisGrasp;
                Ind = Ind + 1;
                
            end
        end
    end
end


if Ind==1
    disp('No grasp found');
    Sorted_List_Of_Grasps = [];
else
    [~,idx]=sort([List_Of_Grasps.Quality]);
    Sorted_List_Of_Grasps = List_Of_Grasps(fliplr(idx));
    %Plot the object and best grasp
    plot([Shape.Vertex(:,1);Shape.Vertex(1,1)],[Shape.Vertex(:,2);Shape.Vertex(1,2)])
    hold on
    axis equal
    %Tempr = Sorted_List_Of_Grasps(1).Configuration';
    %scatter(Tempr(1,:),Tempr(2,:),'MarkerEdgeColor',[0 .5 .5],...
    %    'MarkerFaceColor',[1 0 0],...
    %    'LineWidth',1.5)
end

disp(['Monte Carlo simulation complete. ',num2str(Ind),' valid grasps found and sorted'])
end

