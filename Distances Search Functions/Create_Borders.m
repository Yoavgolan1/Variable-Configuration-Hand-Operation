function [Borders] = Create_Borders()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global f0_min f0_max f1_min f1_max Dimension

Borders = zeros(Dimension, 2);
Borders(:,1) = f1_min;
Borders(:,2) = f1_max;
Borders(1,1) = f0_min;
Borders(1,2) = f0_max;
end

