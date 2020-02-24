function [ ShapeCorr, ShapeIntDir, ShapeEdgeNum ] = Shape_Edge_Grid( Shape, SGrid )
% This MATLAB function's input is a Polygon and the number of grid points
% of the polygon's perimeter. Its output is the computational grid and the
% direction to the polygon's interior at each grid point.


%%%% Calculate the shape's perimeter grid
A               = (Shape.Vertex - [Shape.Vertex(2:end,:); Shape.Vertex(1,:)]).^2;
P               = (A(:,1) + A(:,2)).^0.5;   % Shape's perimeters lengths
Delta           = sum(P)/SGrid;             % The distance between 2 adjacent points             

ShapeCorr       = zeros(SGrid,2);
ShapeIntDir     = zeros(SGrid,2);
Ind             = 1;
LastDelta       = 0;
NewDelta        = Delta*(pi/10);          %0;

for ii = 1:size(Shape.Vertex,1)

    %%%% Sets the direction of the current edge line
    if ii == size(Shape.Vertex,1)
        Direction = (Shape.Vertex(1,:) - Shape.Vertex(ii,:))/norm((Shape.Vertex(1,:) - Shape.Vertex(ii,:)));
    else
        Direction = (Shape.Vertex(ii+1,:) - Shape.Vertex(ii,:))/norm((Shape.Vertex(ii+1,:) - Shape.Vertex(ii,:)));
    end

    ElementNum = ceil((P(ii)-NewDelta)/Delta) - 1;
    
    %%%% ShapeEdgeNum might be useless
    if ii == 1
        ShapeEdgeNum(ii:ii + ElementNum, 1) = ii*ones(ElementNum + 1,1);
    else
        ShapeEdgeNum(end + 1:end + ElementNum + 1, 1) = ii*ones(ElementNum + 1,1);
    end
    
    %%%% How many Grid Points on the current line    
    if ii == 1 
        % Using Pi to make it irrational number
        ShapeCorr(Ind,:) = Shape.Vertex(ii,:) + Direction*Delta*(pi/10);
    else
        ShapeCorr(Ind,:) = Shape.Vertex(ii,:) + (Delta - LastDelta)*Direction;
    end   
    
    temp = cross(cross([ShapeCorr(Ind,:)';0],[Direction';0]),[Direction';0])';
    temp = temp(1:2)/norm(temp);
    ShapeIntDir(Ind,:) = temp;
    
    
    for jj = (Ind + 1):(Ind + ElementNum)
        ShapeCorr(jj,:) = ShapeCorr(jj - 1,:) + Delta*Direction;
        ShapeIntDir(jj,:) = temp;
    end
    
    if ii < size(Shape.Vertex,1)
        LastDelta = norm(Shape.Vertex(ii+1,:)-ShapeCorr(jj,:));
        NewDelta = Delta - LastDelta;
    end
    
    Ind = jj + 1;
end

end

