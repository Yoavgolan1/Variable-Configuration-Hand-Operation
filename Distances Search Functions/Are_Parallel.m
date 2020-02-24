function [Answer] = Are_Parallel(Vec1, Vec2)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

Vec1_Normalized = Vec1/norm(Vec1);
Vec2_Normalized = Vec2/norm(Vec2);

if abs(dot(Vec1_Normalized,Vec2_Normalized)-1) < 0.00001
    Answer = true;
else
    Answer = false;

end

