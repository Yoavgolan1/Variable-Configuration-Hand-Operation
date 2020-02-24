function [Answer] = Point_In_HyperCube(Point,Borders)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
Answer = true;

Dim = length(Point);
for ii=1:Dim
    if Point(ii) < Borders(ii,1) || Point(ii) > Borders(ii,2)
        Answer = false;
    end
end
if isempty(Point)
    Answer = false;
end
end

