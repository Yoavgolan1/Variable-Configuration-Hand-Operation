function [Intersection_Point] = Line_Line_Intersection(Vec1,Vec2)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Dim = length(Vec1)/2;
Vec1_Origin = Vec1(1:Dim);
Vec2_Origin = Vec2(1:Dim);
Vec1_Dir = Vec1(Dim+1:end);
Vec2_Dir = Vec2(Dim+1:end);
if Are_Parallel(Vec1_Dir,Vec2_Dir)
    Intersection_Point = [];
    return
end

Vec1_Origin = Vec1(1:Dim);
Vec2_Origin = Vec2(1:Dim);
Vec1_Dir = Vec1(Dim+1:end);
Vec1_Dir = Vec1_Dir/norm(Vec1_Dir);
Vec2_Dir = Vec2(Dim+1:end);
Vec2_Dir = Vec2_Dir/norm(Vec2_Dir);

A = inv((eye(Dim) - Vec1_Dir*Vec1_Dir') + (eye(Dim) - Vec2_Dir*Vec2_Dir'));
B = (eye(Dim) - Vec1_Dir*Vec1_Dir')*Vec1_Origin' + (eye(Dim) -  Vec2_Dir*Vec2_Dir')*Vec2_Origin';
C = A*B;

R1 = eye(Dim) - Vec1_Dir'*Vec1_Dir;
R2 = eye(Dim) - Vec2_Dir'*Vec2_Dir;
R = R1+R2;
q = (eye(Dim) - Vec1_Dir'*Vec1_Dir)*Vec1_Origin' + (eye(Dim) - Vec2_Dir'*Vec2_Dir)*Vec2_Origin';
%Formula from http://cal.cs.illinois.edu/~johannes/research/LS_line_intersect.pdf



Intersection_Point = inv(R)*q;

D1 = (Vec1_Origin' - Intersection_Point)' * (eye(Dim) - Vec1_Dir'*Vec1_Dir) * (Vec1_Origin' - Intersection_Point);
D2 = (Vec2_Origin' - Intersection_Point)' * (eye(Dim) - Vec2_Dir'*Vec2_Dir) * (Vec2_Origin' - Intersection_Point);
D = abs(D1)+abs(D2);
if D > 0.001
    Intersection_Point = [];
end
end

