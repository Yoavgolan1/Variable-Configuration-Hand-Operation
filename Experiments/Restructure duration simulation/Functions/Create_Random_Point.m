function [Point] = Create_Random_Point(Dimension, Borders)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
Point = zeros(1,Dimension);
for ii=1:Dimension
    Point(ii) = (Borders(ii,2)-Borders(ii,1))*rand() + Borders(ii,1);
end

end

