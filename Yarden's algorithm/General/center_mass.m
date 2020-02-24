function [ CM ] = center_mass( Shape )
% This function finds the center mass of polygons by spliting the polygons
% to triangles. It relevant only for convex shapes.
% The function has 2 modes:
% When the body frame origin is located inside the body, mode = 1,
% otherwise mode = 2.

mode = 1;

x = Shape.Vertex(:,1);
y = Shape.Vertex(:,2);
corners_num = length(Shape.Vertex(:,1));

for ii=1:corners_num
    if ii == corners_num    
        c = cross([x(ii);y(ii);0],[x(1);y(1);0]); 
    else
        c = cross([x(ii);y(ii);0],[x(ii+1);y(ii+1);0]); 
    end
    
    if c(3) < 0
        mode = 2;
    end
end

% X_0 and Y_0 are the coordinates of a point inside the shape, 
switch (mode)
    case 1
        X_0 = 0; 
        Y_0 = 0;
    case 2
        X_0 = sum(x)/corners_num;
        Y_0 = sum(y)/corners_num;
        
        x = x - ones(corners_num,1)*X_0; 
        y = y - ones(corners_num,1)*Y_0;
end

for ii=1:corners_num  
    if ii==corners_num
        cm(ii,1) = (x(ii)+x(1))/3;
        cm(ii,2) = (y(ii)+y(1))/3;
    
        if x(ii) == x(1)
            h(ii,1) = 0;
            h(ii,2) = y(ii);
        else
            h(ii,1) = ( (y(1)-y(ii))*( x(ii)*(y(1)-y(ii)) - y(ii)*(x(1)-x(ii)) ) )/( (y(1)-y(ii))^2 + (x(1)-x(ii))^2 );
            h(ii,2) = ((y(1)-y(ii))/(x(1)-x(ii)))*(h(ii,1)-x(ii))+y(ii);
        end
        
        A(ii) = ((norm([h(ii,1) h(ii,2)]))*(norm([y(1)-y(ii),x(1)-x(ii)])))/2;
    else
        cm(ii,1) = (x(ii)+x(ii+1))/3;
        cm(ii,2) = (y(ii)+y(ii+1))/3;
        
        if x(ii+1) == x(ii)
            h(ii,1) = 0;
            h(ii,2) = y(ii);
        else
            h(ii,1) = ( (y(ii+1)-y(ii))*( x(ii)*(y(ii+1)-y(ii)) - y(ii)*(x(ii+1)-x(ii)) ) )/( (y(ii+1)-y(ii))^2 + (x(ii+1)-x(ii))^2 );
            h(ii,2) = ((y(ii+1)-y(ii))/(x(ii+1)-x(ii)))*(h(ii,1)-x(ii))+y(ii);
        end
        
        A(ii) = ((norm([h(ii,1) h(ii,2)]))*(norm([y(ii+1)-y(ii),x(ii+1)-x(ii)])))/2;
    end  
end

CM(1,1) = (A*cm(:,1))/(sum(A)) + X_0;
CM(2,1) = (A*cm(:,2))/(sum(A)) + Y_0;

end

