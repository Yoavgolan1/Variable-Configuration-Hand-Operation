function [Final_Polygon, Current_Centroid] = Blob2Poly(xyBlob,polytol)
% BLOB2POLY gets xy coordinates of an img blob with calculation
% tolerance and returns xy cooridnates of converted polygon and its center

Area = polyarea(xyBlob(:,1),xyBlob(:,2));
% Perimeter = Find_Perimeter(xyBlob);

N_Vertices = 3; % start from trying 3 vertices
Centroid = polygonCentroid(xyBlob);
Area_Dif = 10e10; 
Cent_Dif = 10e10;

[ ~, Max_Distance ] = Find_Farthest_Points2D(xyBlob);

% reduce blob until tolerance is met
while Area_Dif>polytol || Cent_Dif>polytol
    N_Vertices = N_Vertices +1;
    poly = reduce_poly(xyBlob',N_Vertices);
    poly = (flipud(poly))';
    T_Area = polyarea(poly(:,1),poly(:,2));
    Area_Dif = abs(T_Area-Area)/Area;
    Current_Centroid = polygonCentroid(poly);
    Centroid_Dist = DistTwoPoints(Centroid(1),Centroid(2),Current_Centroid(2),Current_Centroid(1));
    Cent_Dif = (Centroid_Dist/Max_Distance)^0.5;
end

Final_Polygon = poly;
end


function [ dist ] = DistTwoPoints( x1,y1,x2,y2 )

dist = ((x1-x2)^2+(y1-y2)^2)^0.5;

end

