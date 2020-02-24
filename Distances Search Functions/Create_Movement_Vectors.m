function [Movement_Vectors] = Create_Movement_Vectors(Dimension)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

Movement_Vectors = eye(Dimension);
Movement_Vectors = -(Movement_Vectors - 1);
Movement_Vectors(1,1) = 1;
end

