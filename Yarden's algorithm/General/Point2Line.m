function [direction, distance] = Point2Line( pt, v1, v2 )
% This function's input is a point and a line, and it returns the shortest
% distance between from the point to the line and the direction.

    a = [v1 - v2;0];
    b = [pt - v2;0];
    distance = norm(cross(a,b)) / norm(a);
    direction = [0 -1; 1 0]*(v2-v1)/norm(v2-v1);
    
    line_pt = pt + distance*direction;
    
    if norm(cross([line_pt-v1;0],-a)) > 10^-5
        direction = -direction; 
    end
end

