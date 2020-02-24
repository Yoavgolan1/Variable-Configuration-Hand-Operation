%% Initialize
clear all
close all
warning('off','MATLAB:delaunayTriangulation:DupPtsWarnId')

%% Create polygon
[xs,ys,dts]=simple_polygon(randi([3,8]));
Shape.Vertex = [xs(1:end-1),ys(1:end-1)]-.5;
while ~inpolygon(0,0,xs-.5,ys-.5)
    [xs,ys,dts]=simple_polygon(randi([3,8]));
    Shape.Vertex = [xs(1:end-1),ys(1:end-1)]-.5;
end

%Shape.Vertex    = 1*[0 2 0 -5; -4 1 2 -3]';

GraspingArm.Num             = 3;        % Number of fingers
GraspingArm.Mu              = 0.1;      % Coefficient of friction
%% Monte Carlo settings
SGrid = 1000;           % Polygon's perimeter grid points
Bets = 50000;
Quality_Measure = "SPHERE_VOLUME";
Quality_Measure = "ELLIPSE_VOLUME";

%% Construction of the computational grid
% instead '~' use ShapeEdgeNum(Not yet neccesary)
[ShapeCorr, ShapeIntDir, ShapeEdgeNum] = Shape_Edge_Grid(Shape, SGrid);

%% Grasp Map Possibilities
IndBest             = 0;
ConvexHullRadius    = 0;
Ellipse_Vol         = 0;
Ind                 = 1;
JPos                = [0 1 0; -1 0 0; 0 0 1];   %  90 deg Rotation Matrix.

plot([Shape.Vertex(:,1);Shape.Vertex(1,1)],[Shape.Vertex(:,2);Shape.Vertex(1,2)])
hold on
axis equal

FingerConfiguration = zeros(GraspingArm.Num,Bets);
for ii = 1:Bets
    
    FingerConfiguration(1:GraspingArm.Num,ii) = ceil(unifrnd(0,SGrid,GraspingArm.Num,1));
    %     FingerConfiguraion(1:3,ii) = ceil(rand(3,1)*SGrid);
    
    %%%% Construction of the current Grasp Map
    Tempr = [ShapeCorr(FingerConfiguration(:,ii),:)'; zeros(1,GraspingArm.Num)];
    Tempn = [ShapeIntDir(FingerConfiguration(:,ii),:)'; zeros(1,GraspingArm.Num)];
    %     Tempr = [ShapeCorr(FingerConfiguraion(1,ii),:)', ShapeCorr(FingerConfiguraion(2,ii),:)', ShapeCorr(FingerConfiguraion(3,ii),:)'; zeros(1,3)];
    %     Tempn = [ShapeIntDir(FingerConfiguraion(1,ii),:)', ShapeIntDir(FingerConfiguraion(2,ii),:)', ShapeIntDir(FingerConfiguraion(3,ii),:)'; zeros(1,3)];
    
    Tempf1 = JPos*Tempn*GraspingArm.Mu + Tempn;
    Tempf2 = -JPos*Tempn*GraspingArm.Mu + Tempn;
    
    TempTorquef1 = cross(Tempr,Tempf1);
    TempTorquef2 = cross(Tempr,Tempf2);
    
    TempGf1 = TempTorquef1 + Tempf1;
    TempGf2 = TempTorquef2 + Tempf2;
    
    TempG = [TempGf1(1:3,:), TempGf2(1:3,:)];
    %     TempG = [TempGf1(1:3,1), TempGf2(1:3,1), TempGf1(1:3,2),...
    %         TempGf2(1:3,2), TempGf1(1:3,3), TempGf2(1:3,3)];
    
    %%%% Checks if G is full rank matrix
    if rank(TempG) == min(size(TempG))
        
        %%%% Delaunay Triangulation of the Grasp Map
        TempDT = delaunayTriangulation(TempG');
        
        %%%% Checks if there is any Tetrahedron exist
        if min(size(TempDT)) > 0
            
            %%%% Checks if the Origin is inside the Convex Hull
            if ~isnan(pointLocation(TempDT,[0 0 0]))
                
                
                
                if Quality_Measure == "ELLIPSE_VOLUME"
                    D = eig(TempG*TempG');
                    Temp_Ellipse_Vol = D(1)*D(2)*D(3);
                    
                    if Temp_Ellipse_Vol > Ellipse_Vol
                        IndBest = ii;
                        Ellipse_Vol = Temp_Ellipse_Vol;
                        %GraspMapConH = TempTR;
                        Best_G = TempG;
                        BestDT = TempDT;
                    end
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
                    %%%% Saves the biggest radius
                    if TempRad > ConvexHullRadius
                        IndBest = ii;
                        ConvexHullRadius = TempRad;
                        GraspMapConH = TempTR;
                        Best_G = TempG;
                        BestDT = TempDT;
                    end
                end
                %plot(Tempr(1,:),Tempr(2,:),'o')
                %pause(0.1)
                
                %                 CloseRad(Ind,1) = TempRad;
                %                 CloseConf(Ind,1) = ii;
                %                 Ind = Ind + 1;
                
            end
        end
    end
end
if ~IndBest
    display('No grasp found');
else
    Tempr = [ShapeCorr(FingerConfiguration(:,IndBest),:)'; zeros(1,GraspingArm.Num)];
    scatter(Tempr(1,:),Tempr(2,:),'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',[1 0 0],...
        'LineWidth',1.5)
end