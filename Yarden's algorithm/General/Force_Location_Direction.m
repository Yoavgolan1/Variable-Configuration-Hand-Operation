function [ distance, line_pt ] = Force_Location_Direction(Force_loc, Shape)
% This MATLAB function returns the distance between the activate location
% to the Polygon and the closest point on the Polygon.
%
% A = [Xpt-X1 xpt-X2 ....]   B = [X2-X1 X3-X2 .... X1-Xn]   K = [X1 X2 .... Xn]
%     [Ypt-Y1 Ypt-Y2 ....]       [Y2-Y1 Y3-Y2 .... Y1-Yn]       [Y1 Y2 .... Yn]
%     [  0      0    ....]       [  0     0   ....   0  ]       [0  0  .... 0 ]
    
R = [ cos(Shape.teta) , -sin(Shape.teta) ; sin(Shape.teta) , cos(Shape.teta) ]; % R(teta) is the rotation matrix 

K = [R*Shape.Vertex' + Shape.d*ones(1,length(Shape.Vertex(:,1))); zeros(1,length(Shape.Vertex(:,1)))];
A = -(K - [Force_loc ; 0]*ones(1,length(Shape.Vertex(:,1))));
B = [K(:,2:length(Shape.Vertex(:,1))), K(:,1)] - K;

C = (cross(B,A)).^2;
C = (C(1,:) + C(2,:) + C(3,:)).^0.5;
D = B.^2;
D = (D(1,:) + D(2,:)).^0.5;

distance = C./D;

line_pt = (ones(2,1)*(-distance./D)).*([0 -1 ; 1 0]*B(1:2,:)) + Force_loc*ones(1,length(A));

E = cross([line_pt; zeros(1,length(Shape.Vertex(:,1)))]-K , B);  

for ii = 1:length(Shape.Vertex(:,1))
    if abs(E(3,ii)) > 10^-5
        line_pt(:,ii) = (distance(ii)/D(ii))*[0 -1 ; 1 0]*B(1:2,ii) + Force_loc;
    end
end

InOut_1 = (K - [line_pt ; zeros(1,length(Shape.Vertex(:,1)))]).^2;
InOut_2 = ([K(:,2:length(Shape.Vertex(:,1))), K(:,1)] - [line_pt ; zeros(1,length(Shape.Vertex(:,1)))]).^2;
InOut_1 = (InOut_1(1,:) + InOut_1(2,:)).^0.5;
InOut_2 = (InOut_2(1,:) + InOut_2(2,:)).^0.5;
F = D - InOut_1 - InOut_2;

A_2 = [A(:,2:end) , A(:,1)];
K_2 = [K(:,2:end) , K(:,1)];

for ii = 1:length(Shape.Vertex(:,1)) 
    if abs(F(ii)) > 10^-5
        [distance(ii),I] = min([norm(A(:,ii)), norm(A_2(:,ii))]);
        if I == 1
            line_pt(:,ii) = K(1:2,ii);
        else
            line_pt(:,ii) = K_2(1:2,ii);
        end      
    end
end

[distance, I] = min(distance);
line_pt = line_pt(:,I);

end

