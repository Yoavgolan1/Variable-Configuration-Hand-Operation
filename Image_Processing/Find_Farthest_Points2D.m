function [ Selected_Points, Max_Distance ] = Find_Farthest_Points2D( Point_List )
%Find_Farthest_Points receives a 3-column matrix of 3D points and returns
%the three farthest points from each other, and the sum of their distances
%to each other.


K = convhull(Point_List(:,1),Point_List(:,2));
Points_On_Hull = zeros(length(K(:,1)), 2);
for ii=1:length(K(:,1))

    Points_On_Hull((ii),:) = [ Point_List(K(ii,1),1),Point_List(K(ii,1),2)];

    
end

Point_List = unique(Points_On_Hull,'rows');


Max_Distance = 0;
N = length(Point_List(:,1));

for ii=1:N
    %clc
    %disp([num2str(round(100*ii/N)),'% complete']);
    x1 = Point_List(ii,1);
    y1 = Point_List(ii,2);
    for jj=1:N
        x2 = Point_List(jj,1);
        y2 = Point_List(jj,2);
        
        Distance1 = ((x1-x2)^2+(y1-y2)^2)^0.5;
        
        Total_Distance = Distance1;
        if Total_Distance > Max_Distance
            Max_Distance = Total_Distance;
            Selected_Points = [x1 y1; x2 y2;];
        end
    end
end


end

