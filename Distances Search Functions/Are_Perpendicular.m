function [Answer] = Are_Perpendicular(Vec1, Vec2)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

if abs(dot(Vec1,Vec2)) < 0.00001
    Answer = true;
else
    Answer = false;

end

