function [ Shape, Wall, GraspingArm ] = Pushing_One_Wall( Shape, Wall, GraspingArm )
% This MATLAB function implement a set of manipulations on an object which
% is located near a single wall. The object's configuration doesn't allow
% it's propper grasping by a given arm.


RotMat = @(x) [cos(x), -sin(x); sin(x), cos(x)]; % Rotation matrix

PosShapeGrid        = 500;
Force.TorqueDamp    = 0.05;
Force.Boost         = 100;

[Shape, Polygon] = Ploting_One_Shape_OneWall( Shape,Wall );

TempEnd             = 1;            %% delete in the end %%%

%% Checks the fingers configuration that perform the best grasp.
% % Regular Best Grasping Configuration Algorithm
% SGrid               = 40;
% [~,GraspingArm]     = Grasp_Configuration_Friction_OneWall(Shape, GraspingArm, SGrid);

% Monte Carlo method.
SGrid               = 160;
Bets                = 8000;
[~,~,GraspingArm]     = Grasp_Configuration_Friction_OneWall_MonteCarlo(Shape, GraspingArm, Bets, SGrid);
pause(5);

%% Temp - plots the shapes trajectory
figure(4);  clf;
ShapeWorldFrame = RotMat(Shape.teta)*(Shape.Vertex') + Shape.d*ones(1,length(Shape.Vertex(:,1)));
fill(ShapeWorldFrame(1,:) , ShapeWorldFrame(2,:) ,'r');
hold on; grid on; axis square;
plot(Shape.d(1), Shape.d(2),'k+');
axis([-30, 30, -30, 30])
Ploting_Walls(Wall);
TempCM = Shape.d;
TempNum = 1;

%% Builds the configuration space of the object with the wall.
TetaGrid            = 100;
[Wall] = Configuration_Space_Compute_OneWall( Shape, Wall, TetaGrid);


%% Step 1: Initial condition.
GraspingArm.PossiableLoction = 0;

for ii = 1:GraspingArm.Num
    [~, Distance] = Point2Line(Shape.d+RotMat(Shape.teta)*GraspingArm.Finger(:,ii), Wall.Corr(1:2), Wall.Corr(3:4));
    GraspingArm.PossiableLoction(ii) = (Distance < 1.1*GraspingArm.FingerR);
end

while sum(GraspingArm.PossiableLoction)
    TempEnd = TempEnd +1;       %% delete in the end %%
    
    TempFinger = find(GraspingArm.PossiableLoction);
    
    %% Step 2: Find the ultimate direction
    
    %%%% NewNewNew Ultimate Direction search
    PointBody = [Shape.d; Shape.teta];
    WallLength = norm(Wall.Corr(1:2)-Wall.Corr(3:4));    
    
    for ii = 1:length(Wall.Configuration.teta)
        WallConf(1:6,ii) = [ Wall.Configuration.d{ii}(1:2,1); Wall.Configuration.teta(ii); ...
            Wall.Configuration.d{ii}(1:2,2); Wall.Configuration.teta(ii) ];
        Mid(ii) = (PointBody - WallConf(1:3,ii))'*((WallConf(4:6,ii) - WallConf(1:3,ii))/WallLength);
        ConfCurve(1:3,ii) = WallConf(1:3,ii) + Mid(ii)*((WallConf(4:6,ii) - WallConf(1:3,ii))/WallLength);
        Distance(ii) = norm(PointBody - ConfCurve(1:3,ii));
    end
    
    [~, Index] = sort(Distance);
    Point1 = ConfCurve(1:3,Index(1));
    Point2 = ConfCurve(1:3,Index(2));
    
    UltimateDir = cross((Point2 - Point1),(WallConf(4:6,Index(1)) - WallConf(1:3,Index(1))));
    UltimateDir = UltimateDir/norm(UltimateDir);
    
    % Direction check for the plane's normal dircetion -/+
    [TempDirection_d,~] = Point2Line(Shape.d,Wall.Corr(1:2),Wall.Corr(3:4));
    TempDirection_d = -TempDirection_d;
    if UltimateDir(1:2)'*TempDirection_d < 0
        UltimateDir = -UltimateDir;
    end
    
    
    
% %     % Configuration space coordinates of the Wall
% %     [~, Index] = sort(abs(Shape.teta - Wall.Configuration.teta)); 
% %     TempWallteta = Wall.Configuration.teta(Index(1:2));
% %     TempWalld1 = Wall.Configuration.d{Index(1)};
% %     TempWalld2 = Wall.Configuration.d{Index(2)};
% %     
% %     %%%% New Ultimate Direction search
% %     % Configuration Space Wall's coordinates
% %     PointBody = [Shape.d; Shape.teta];
% %     WallLength = norm(Wall.Corr(1:2)-Wall.Corr(3:4));
% %     PointAAA = [TempWalld1(:,1); TempWallteta(1)];
% %     PointBBB = [TempWalld1(:,2); TempWallteta(1)];
% %     PointCCC = [TempWalld2(:,1); TempWallteta(2)];
% %     PointDDD = [TempWalld2(:,2); TempWallteta(2)];
% %     Mid1 = (PointBody - PointAAA)'*((PointBBB-PointAAA)/WallLength);
% %     Mid2 = (PointBody - PointCCC)'*((PointDDD-PointCCC)/WallLength);
% %     
% %     % Find the 2 closest points with different theta values, on the on the CO-Boundary. 
% %     Point1 = PointAAA + (PointBBB - PointAAA)*Mid1;
% %     Point2 = PointCCC + (PointDDD - PointCCC)*Mid2;
% %     
% %     UltimateDir = cross((Point2 - Point1),(PointBBB-PointAAA));
% %     UltimateDir = UltimateDir/norm(UltimateDir);
% %     
% %     % Direction check for the plane's normal dircetion -/+
% %     [TempDirection_d,~] = Point2Line(Shape.d,Wall.Corr(1:2),Wall.Corr(3:4));
% %     TempDirection_d = -TempDirection_d;
% %     if UltimateDir(1:2)'*TempDirection_d < 0
% %         UltimateDir = -UltimateDir;
% %     end
        
% % % % %     % 3 closest points which are required to locate the closest plane.
% % % % %     PointA = [TempWalld1(:,1); TempWallteta(1)];
% % % % %     PointB = [TempWalld1(:,2); TempWallteta(1)];
% % % % %     PointC = [TempWalld2(:,1); TempWallteta(2)];    
% % % % %     
% % % % %     % Plane's normal is the ultimate direction (farthest from the Wall).
% % % % %     UltimateDir = cross(PointB-PointA, PointC-PointA);
% % % % %     UltimateDir = UltimateDir/norm(UltimateDir);
% % % % %     
% % % % %     % Direction check for the plane's normal dircetion -/+
% % % % %     [TempDirection_d,~] = Point2Line(Shape.d,Wall.Corr(1:2),Wall.Corr(3:4));
% % % % %     TempDirection_d = -TempDirection_d;
% % % % %     if UltimateDir(1:2)'*TempDirection_d < 0
% % % % %         UltimateDir = -UltimateDir;
% % % % %     end

    %% Step 3: Locate the best possiable location for pushing.
    
    % Locate the possible locations.
    [ShapeStep3, ShapeIntStep3, ~] = Shape_Edge_Grid(Shape, PosShapeGrid);
    ShapeStep3 = Shape.d*ones(1,PosShapeGrid) + RotMat(Shape.teta)*ShapeStep3';   % World frame.
    
    % Point2Line (for set of points):
    MatA = [Wall.Corr(1:2) - Wall.Corr(3:4); 0]*ones(1,PosShapeGrid);
    MatB = [ ShapeStep3 - Wall.Corr(3:4)*ones(1,PosShapeGrid); zeros(1,PosShapeGrid)];
    DistanceStep3 = (sum(cross(MatA,MatB).^2).^0.5)./(sum(MatA.^2).^0.5);
    
    ForceDirStep3 = RotMat(Shape.teta)*(ShapeIntStep3');
    PossibleLocation = DistanceStep3 > 1.1*2*GraspingArm.FingerR;
    
    % Locate the best possiable location for pushing.
    Projection = -1;
    BestLocation = 0;
    alpha = atan(GraspingArm.Mu);
    
    %%%% temp Extending the Force directions (inside Friction Cone).
    for ii = find(PossibleLocation)
        for jj = linspace(-0.5*alpha,0.5*alpha,9);
            
            TempForce = [ RotMat(jj)*ForceDirStep3(:,ii); 0];
            Tempr = [ShapeStep3(:,ii) - Shape.d; 0];
            TempWrench = TempForce + Force.TorqueDamp*cross(Tempr,TempForce);

            TempVelocity = [1/Shape.m; 1/Shape.m; 1/Shape.I].*TempWrench; % *dt
            TempVelocity = TempVelocity/norm(TempVelocity);
            
            if TempVelocity'*UltimateDir > Projection
                BestLocation = ii;
                BestForceDir = jj;
                Projection = TempVelocity'*UltimateDir;
            end
        end
        
        if Projection == 1
            break;
        end
    end
        
    if ii
        Force.Location = ShapeStep3(:,BestLocation);
        Force.Direction = RotMat(BestForceDir)*ForceDirStep3(:,BestLocation);
        
        figure(1); subplot(1,2,1);
        
        Circle = linspace(0,2*pi);
        
        hold on;
        FingerPrint = fill(Force.Location(1) - GraspingArm.FingerR*Force.Direction(1) + GraspingArm.FingerR*cos(Circle), ...
            Force.Location(2) - GraspingArm.FingerR*Force.Direction(2) + GraspingArm.FingerR*sin(Circle),'b');
        hold off;
        
    else
        fprintf('\n **There is no possiable pushing option **\n\n');
        return
    end
    

    
% %     for ii = find(PossibleLocation)
% %         TempForce = [ForceDirStep3(:,ii); 0];
% %         Tempr = [ShapeStep3(:,ii) - Shape.d; 0];
% %         TempWrench = TempForce + Force.TorqueDamp*cross(Tempr,TempForce);
% % 
% %         TempVelocity = [1/Shape.m; 1/Shape.m; 1/Shape.I].*TempWrench; % *dt
% % %         TempVelocity = TempVelocity/norm(TempVelocity);
% %         
% %         if TempVelocity'*UltimateDir > Projection
% %             BestLocation = ii;
% %             Projection = TempVelocity'*UltimateDir;
% %         end
% %     end
% %     
% %     if ii
% %         Force.Location = ShapeStep3(:,BestLocation);
% %         Force.Direction = ForceDirStep3(:,BestLocation);
% %         
% %         figure(1); subplot(1,2,1);
% %         
% %         Circle = linspace(0,2*pi);
% %         
% %         hold on;
% %         FingerPrint = fill(Force.Location(1) - GraspingArm.FingerR*Force.Direction(1) + GraspingArm.FingerR*cos(Circle), ...
% %             Force.Location(2) - GraspingArm.FingerR*Force.Direction(2) + GraspingArm.FingerR*sin(Circle),'b');
% %         hold off;
% %         
% %     else
% %         fprintf('\n **There is no possiable pushing option **\n\n');
% %         return
% %     end
    
    
    %% Step 4: Activating the force inside the friction cone.
    figure(1); subplot(1,2,1);
    [Shape] = Force_Activator_OneWall(Shape,Wall,GraspingArm,Force,Polygon);
    
    %% Step 5: Algorithm's stop condition.
    
    pause(1);
    FingerPrint.Visible = 'off';

    if TempEnd == 100           %% delete in the end %%%
        break
    end
    
    for ii = 1:GraspingArm.Num
        [~, Distance] = Point2Line(Shape.d+RotMat(Shape.teta)*GraspingArm.Finger(:,ii), Wall.Corr(1:2), Wall.Corr(3:4));
        GraspingArm.PossiableLoction(ii) = (Distance < 1.1*GraspingArm.FingerR);
    end
    
    
    %%%% Plots the object's trajectory in work space
    if ~mod(TempEnd,2)
        figure(4);
        ShapeWorldFrame = RotMat(Shape.teta)*(Shape.Vertex') + Shape.d*ones(1,length(Shape.Vertex(:,1)));
        TempPlot = fill(ShapeWorldFrame(1,:) , ShapeWorldFrame(2,:) ,'g');
        TempPlot.FaceAlpha = 0.3;
        TempNum = TempNum + 1;
        TempCM(1:2,TempNum) = Shape.d;
        drawnow;
        pause(0.3);
    end
    
end

figure(1); subplot(1,2,1);
[Shape, ~] = Ploting_One_Shape_OneWall( Shape,Wall );

figure(1); subplot(1,2,1); hold on;

Circle = linspace(0,2*pi);
for ii = 1:GraspingArm.Num
    
    FingerPlot = Shape.d + RotMat(Shape.teta)*GraspingArm.Finger(:,ii);
    
    fill(FingerPlot(1) + GraspingArm.FingerR*cos(Circle), ...
        FingerPlot(2) + GraspingArm.FingerR*sin(Circle),'b');
end

hold off


%%%% Plots the object's trajectory in work space
figure(4);
ShapeWorldFrame = RotMat(Shape.teta)*(Shape.Vertex') + Shape.d*ones(1,length(Shape.Vertex(:,1)));
fill(ShapeWorldFrame(1,:) , ShapeWorldFrame(2,:) ,'r');
plot(TempCM(1,:),TempCM(2,:),'--k','LineWidth', 1);

end