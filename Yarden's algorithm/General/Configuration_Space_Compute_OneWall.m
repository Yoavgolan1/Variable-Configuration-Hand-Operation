function [Wall] = Configuration_Space_Compute_OneWall( Shape, Wall, TetaGrid)
% This MATLAB function builds the CO-boundry of Arms & Walls
% 
% Notes:
% 1. This function is specific for the Pushing Algorithm with one wall.

ShapeNew = Shape.Vertex';
RotMat = @(x) [cos(x), -sin(x); sin(x), cos(x)]; % Rotation matrix

%% Walls

Wall.Configuration.teta = linspace(0,2*pi,TetaGrid);
for ii = 1:Wall.Num         % Loop for each wall
    TetaCounter = 1;
    for TetaTemp = linspace(0,2*pi,TetaGrid) % Loop for each theta piece
        
        R = RotMat(TetaTemp);
        ShapeWorldFrame = R*ShapeNew + Shape.d*ones(1,size(ShapeNew,2));
 
        % Step 1: locate the closest corner at each theta configuration.
        CornerDistance = 0;
        for jj = 1:size(ShapeNew,2);
            [~, CornerDistance(jj)] = Point2Line(ShapeWorldFrame(1:2,jj), Wall.Corr(1:2,ii),Wall.Corr(3:4,ii));
        end
        [~, Ind] = min(CornerDistance);
        
        % Step 2: find the location that the corner merge with the wall.  
        Wall.Configuration.d{ii,TetaCounter}(1:2,1) = Wall.Corr(1:2,ii) - R*ShapeNew(1:2,Ind);
        Wall.Configuration.d{ii,TetaCounter}(1:2,2) = Wall.Corr(3:4,ii) - R*ShapeNew(1:2,Ind);
        
        TetaCounter = TetaCounter + 1;
    end
end

end

