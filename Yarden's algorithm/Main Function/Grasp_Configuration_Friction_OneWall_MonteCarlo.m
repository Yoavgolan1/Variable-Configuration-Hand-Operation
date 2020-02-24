function [ BestContactPoints, PossiableFingerConfiguration, GraspingArm ] = Grasp_Configuration_Friction_OneWall_MonteCarlo( Shape, GraspingArm, Bets, SGrid ) %PosContactPoints
% This MATLAB function returns the best Grasping Configuration for a given
% polygon and grasping arm (number of fingers, friction's coefficient). The
% function using the Grasp Map and it's Convex Hull criterion to determine
% which Configuration gives the best grasp.
% 
% For now:
% The function works for a planer polygon, using 3 friction contact points.

msgid = 'MATLAB:delaunayTriangulation:DupPtsWarnId';
warning('off',msgid);
tic

if nargin < 4
    SGrid              = 30;           % Polygon's perimeter grid points
end

if nargin < 3
    Bets               = 500;
end

Threshold = 0.5;

%% Construction of the computational grid
% instead '~' use ShapeEdgeNum(Not yet neccesary)
[ShapeCorr, ShapeIntDir, ShapeEdgeNum] = Shape_Edge_Grid(Shape, SGrid);

%% Grasp Map Possibilities
IndBest             = 0;
ConvexHullRadius    = 0;
Ind                 = 1;
JPos                = [0 -1 0; 1 0 0; 0 0 1];   %  90 deg Rotation Matrix.

FingerConfiguraion = zeros(GraspingArm.Num,Bets);
for ii = 1:Bets
    
    FingerConfiguraion(1:GraspingArm.Num,ii) = ceil(unifrnd(0,SGrid,GraspingArm.Num,1));
%     FingerConfiguraion(1:3,ii) = ceil(rand(3,1)*SGrid);
    
    %%%% Construction of the current Grasp Map
    Tempr = [ShapeCorr(FingerConfiguraion(:,ii),:)'; zeros(1,GraspingArm.Num)];
    Tempn = [ShapeIntDir(FingerConfiguraion(:,ii),:)'; zeros(1,GraspingArm.Num)];    
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

                [TempConvHull,Xb] = freeBoundary(TempDT);
                TempTR = triangulation(TempConvHull,Xb);
                TempFaceNormal = faceNormal(TempTR);

                %%%% Search for the closest Convex Hull surface
                sz = size(TempTR);
                clear d
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
                end

                CloseRad(Ind,1) = TempRad;
                CloseConf(Ind,1) = ii;
                Ind = Ind + 1;

            end
        end
    end 
end

%%%% Checks if there is any possiable grasp
if ConvexHullRadius == 0
    disp(' ')
    disp('There is no stable Grasp configuration for this object with the current arm.')
    disp(' ')
    BestContactPoints = [];
    return
end

GoodPoints = find(CloseRad > Threshold*ConvexHullRadius);
GoodPointsIndices = CloseConf(GoodPoints);
GoodPointsIndicesRad = CloseRad(GoodPoints);
PossiableFingerConfiguration = sort(FingerConfiguraion(:,GoodPointsIndices));

%% Ploting the ConvexHull
figure(2); clf;

%%%% Contact points location Plot
subplot(1,2,1)
hold on; grid on; axis square;
ShapeCM = center_mass(Shape);
fill(Shape.Vertex(:,1) , Shape.Vertex(:,2) ,'r');
plot(ShapeCM(1),ShapeCM(2),'k+');
axis([min(Shape.Vertex(:,1))-3*GraspingArm.FingerR, max(Shape.Vertex(:,1))+3*GraspingArm.FingerR, min(Shape.Vertex(:,2))-3*GraspingArm.FingerR, max(Shape.Vertex(:,2))+3*GraspingArm.FingerR]);
xlabel('X_b'); ylabel('Y_b'); title('Work Space - Body Frame'); 

%%%% Best Contact Points (Calc + Plot)
BestContactPoints = ShapeCorr(FingerConfiguraion(:,IndBest),:);
ContactDirections = ShapeIntDir(FingerConfiguraion(:,IndBest),:);
GraspingArm.FingerEdgeNum = ShapeEdgeNum(FingerConfiguraion(:,IndBest));

% BestContactPoints = [ShapeCorr(FingerConfiguraion(1,IndBest),:);ShapeCorr(FingerConfiguraion(2,IndBest),:);ShapeCorr(FingerConfiguraion(3,IndBest),:)];
% ContactDirections = [ShapeIntDir(FingerConfiguraion(1,IndBest),:);ShapeIntDir(FingerConfiguraion(2,IndBest),:);ShapeIntDir(FingerConfiguraion(3,IndBest),:)];
% GraspingArm.FingerEdgeNum = [ShapeEdgeNum(FingerConfiguraion(1,IndBest)); ShapeEdgeNum(FingerConfiguraion(2,IndBest)); ShapeEdgeNum(FingerConfiguraion(3,IndBest))];

Circle = linspace(0,2*pi);
for ii = 1:GraspingArm.Num
    fill(BestContactPoints(ii,1) - GraspingArm.FingerR*ContactDirections(ii,1) + GraspingArm.FingerR*cos(Circle), ...
        BestContactPoints(ii,2) - GraspingArm.FingerR*ContactDirections(ii,2) + GraspingArm.FingerR*sin(Circle),'b');
    GraspingArm.Finger(1,ii) = BestContactPoints(ii,1) - GraspingArm.FingerR*ContactDirections(ii,1);
    GraspingArm.Finger(2,ii) = BestContactPoints(ii,2) - GraspingArm.FingerR*ContactDirections(ii,2);
end

hold off

%%%% Wrench Space Plot
subplot(1,2,2)             

%%%% Plots the Convex Hull
faceColor  = [0.6875 0.8750 0.8984];
trisurf(GraspMapConH, ...
    'FaceColor',faceColor, ...
    'FaceAlpha',0.3);
xlabel('F_x'); ylabel('F_y'); zlabel('\tau'); title('Wrench Space');
hold on; grid on; axis square;
axis([min(GraspMapConH.Points(:,1)),max(GraspMapConH.Points(:,1)),min(GraspMapConH.Points(:,2)),max(GraspMapConH.Points(:,2)),min(GraspMapConH.Points(:,3)),max(GraspMapConH.Points(:,3))]);
% plot3([0 0],[0 0],[-7 7],'b-'); plot3([0 0],[-7 7],[0 0],'b-'); plot3([-7 7],[0 0],[0 0],'b-');

%%%% Plots the surfaces directions
% P = incenter(GraspMapConH);
% fn = faceNormal(GraspMapConH);
% quiver3(P(:,1),P(:,2),P(:,3), ...
%     fn(:,1),fn(:,2),fn(:,3),0.5, 'color','r');

%%%% Plots the biggest sphere inside the Convex Hull
[X,Y,Z] = sphere(20);
surf(ConvexHullRadius*X,ConvexHullRadius*Y,ConvexHullRadius*Z,...
    'FaceColor','k', ...
    'FaceAlpha',0.5);
hold off 

ConvexHullRadius
disp(' '); toc; disp(' ');
warning('on',msgid);

% %%%% Plots the possiable configurations from the threshold
% if GraspingArm.Num == 3
%     figure(3)
%     scatter3(PossiableFingerConfiguration(1,:),...
%         PossiableFingerConfiguration(2,:),...
%         PossiableFingerConfiguration(3,:),...
%         [],GoodPointsIndicesRad);
%     colormap hot
% end

end

