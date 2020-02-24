function [Intersection_Point] = Line_Hyperplane_Intersection(Line,HyperPlane)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
Dim = length(Line)/2;

Line_Origin = Line(1:Dim);
Line_Direction = Line(Dim+1:end);
HP_Origin = HyperPlane(1:Dim);
HP_Normal = HyperPlane(Dim+1:end);


if Are_Perpendicular(Line_Direction,HP_Normal) %If the line isparallel to the hyperplane, or inside it
    Intersection_Point = [];
    return
end

W = Line_Origin - HP_Origin;
s1 = -dot(HP_Normal, W)/dot(HP_Normal,Line_Direction);

Intersection_Point = Line_Origin + s1*Line_Direction;


end

