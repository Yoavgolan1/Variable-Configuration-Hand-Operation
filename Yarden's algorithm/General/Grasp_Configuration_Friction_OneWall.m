function [ BestContactPoints, GraspingArm ] = Grasp_Configuration_Friction_OneWall( Shape, GraspingArm, SGrid )
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

if nargin == 2
    SGrid              = 30;           % Polygon's perimeter grid points
end

%% Construction of the computational grid
[ShapeCorr, ShapeIntDir, ShapeEdgeNum] = Shape_Edge_Grid(Shape, SGrid);

%% Grasp Map Possibilities
IndVec              = zeros(3,1);
ConvexHullRadius    = 0;
Ind                 = 1;
JPos                = [0 -1 0; 1 0 0; 0 0 1];   %  90 deg Rotation Matrix.

for ii = 1 : SGrid - GraspingArm.Num + 1
    for jj = ii+1 : SGrid - GraspingArm.Num + 2
        for kk = jj+1 : SGrid - GraspingArm.Num + 3

            %%%% Construction of the current Grasp Map
            Tempr = [ShapeCorr(ii,:)', ShapeCorr(jj,:)', ShapeCorr(kk,:)'; zeros(1,3)];
            Tempn = [ShapeIntDir(ii,:)', ShapeIntDir(jj,:)', ShapeIntDir(kk,:)'; zeros(1,3)];
            
            Tempf1 = JPos*Tempn*GraspingArm.Mu + Tempn;
            Tempf2 = -JPos*Tempn*GraspingArm.Mu + Tempn;
            
            TempTorquef1 = cross(Tempr,Tempf1);
            TempTorquef2 = cross(Tempr,Tempf2);
            
            TempGf1 = TempTorquef1 + Tempf1;
            TempGf2 = TempTorquef2 + Tempf2;
            
            TempG = [TempGf1(1:3,1), TempGf2(1:3,1), TempGf1(1:3,2),...
                TempGf2(1:3,2), TempGf1(1:3,3), TempGf2(1:3,3)];

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
                        for tt = 1:sz(1)
                            Plane = TempTR.ConnectivityList(tt,:);
                            d(tt) = sum(TempFaceNormal(tt,:).*TempTR.Points(Plane(1),:));
                        end
                        TempRad = min(d);

                        %%%% Saves the biggest radius
                        if TempRad > ConvexHullRadius
                            IndVec = [ii jj kk]';
                            ConvexHullRadius = TempRad;
                            GraspMapConH = TempTR;
                        end
                        
                        CloseRad(Ind,1) = TempRad;
                        CloseConf(Ind,1:3) = [ii jj kk];
                        Ind = Ind + 1;
                        
                    end
                end
            end 
        end %%% kk
    end %%% jj
end %%% ii

%%%% Checks if there is any possiable grasp
if ConvexHullRadius == 0
    disp(' ')
    disp('There is no stable Grasp configuration for this object with the current arm.')
    disp(' ')
    BestContactPoints = [];
    return
end

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
BestContactPoints = [ShapeCorr(IndVec(1),:);ShapeCorr(IndVec(2),:);ShapeCorr(IndVec(3),:)];
ContactDirections = [ShapeIntDir(IndVec(1),:);ShapeIntDir(IndVec(2),:);ShapeIntDir(IndVec(3),:)];
GraspingArm.FingerEdgeNum = [ShapeEdgeNum(IndVec(1)); ShapeEdgeNum(IndVec(2)); ShapeEdgeNum(IndVec(3))];

Circle = linspace(0,2*pi);
for ii = 1:3
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

[X,Y,Z] = sphere(20);
surf(ConvexHullRadius*X,ConvexHullRadius*Y,ConvexHullRadius*Z,...
    'FaceColor','k', ...
    'FaceAlpha',0.5);
hold off 

warning('on',msgid);

end

