function [Ellipse_Vol,Location] = Search_Grasp(Shape,N_Fingers,Mu,SGrid,Bets,AtLocation,draw)

GraspingArm.Num = N_Fingers;
GraspingArm.Mu = Mu;
Location = 0;
%% Construction of the computational grid
[ShapeCorr, ShapeIntDir, ShapeEdgeNum] = Shape_Edge_Grid(Shape, SGrid);

%% Grasp Map Possibilities
IndBest             = 0;
Ellipse_Vol         = 0;
Ind                 = 1;
JPos                = [0 1 0; -1 0 0; 0 0 1];   %  90 deg Rotation Matrix.


if (AtLocation ~= 0)
    if (isequal(size(AtLocation),[GraspingArm.Num,1]))
        Bets = 1;
    end
end

FingerConfiguraion = zeros(GraspingArm.Num,Bets);
for ii = 1:Bets
    if AtLocation == 0
        FingerConfiguraion(1:GraspingArm.Num,ii) = ceil(unifrnd(0,SGrid,GraspingArm.Num,1));
    elseif isequal(size(AtLocation),[GraspingArm.Num,1]) || isequal(size(AtLocation),[1,GraspingArm.Num])
        FingerConfiguraion(1:GraspingArm.Num,ii) = AtLocation;
    else
        FingerConfiguraion(1:GraspingArm.Num,ii) = AtLocation(:,ii);
    end
    
    %%%% Construction of the current Grasp Map
    Tempr = [ShapeCorr(FingerConfiguraion(:,ii),:)'; zeros(1,GraspingArm.Num)];
    Tempn = [ShapeIntDir(FingerConfiguraion(:,ii),:)'; zeros(1,GraspingArm.Num)];
    
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
                
                %D = eig(TempG*TempG');
                %Temp_Ellipse_Vol = D(1)*D(2)*D(3);
                Temp_Ellipse_Vol = sqrt(det(TempG*TempG'));
                
                if GraspingArm.Num==3

                    GD = [0 0 0; 0 0 0 ;0 0 -dot(Tempr(1),Tempf1(1)) - dot(Tempr(2),Tempf1(2)) - dot(Tempr(3),Tempf1(3))];
                    
                    Tempt=JPos*Tempn;
                    %GD = [0, 0, sum(Tempt(1,:)); 0, 0, sum(Tempt(2,:)); 0, 0, (-dot(Tempr(1),Tempf1(1)) - dot(Tempr(2),Tempf1(2)) - dot(Tempr(3),Tempf1(3)))];
                    %GD = [Tempt(1,1), Tempt(1,2), Tempt(1,3); Tempt(2,1), Tempt(2,2), Tempt(2,3); -dot(Tempr(1),Tempf1(1)), -dot(Tempr(2),Tempf1(2)), -dot(Tempr(3),Tempf1(3))];
                    GD = [0 0 0; 0 0 0 ;-dot(Tempr(1),Tempf1(1)), -dot(Tempr(2),Tempf1(2)), -dot(Tempr(3),Tempf1(3))];
                    New_G = [TempG(:,2),TempG(:,4),TempG(:,6)];
                    %New_G = Tempr;
                    New_G(3,:)=[0 0 0];
                    GGD = New_G+GD;
                    if GraspingArm.Mu <=0.001
                        Temp_Ellipse_Vol = sqrt(det(GGD*GGD'));
                    end
                end
                
                
                
                if Temp_Ellipse_Vol > Ellipse_Vol
                    IndBest = ii;
                    Ellipse_Vol = Temp_Ellipse_Vol;
                    Location = FingerConfiguraion(:,ii);
                    %Best_G = TempG;
                end
            end
        end
    end
end

if draw
    Tempr = [ShapeCorr(FingerConfiguraion(:,IndBest),:)'; zeros(1,GraspingArm.Num)];
    plot([Shape.Vertex(:,1);Shape.Vertex(1,1)],[Shape.Vertex(:,2);Shape.Vertex(1,2)],'-b')
    hold on
    axis equal
    if GraspingArm.Mu<=0.001
        scatter(Tempr(1,:),Tempr(2,:),'MarkerEdgeColor',[0.2 .2 .2],...
            'MarkerFaceColor',[0 1 0],...
            'LineWidth',1.5)
    else
        scatter(Tempr(1,:),Tempr(2,:),'MarkerEdgeColor',[0 .5 .5],...
            'MarkerFaceColor',[1 0 0],...
            'LineWidth',1.5)
    end
end

end