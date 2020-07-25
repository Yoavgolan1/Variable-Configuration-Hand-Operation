function [Borders] = Create_Borders(margin)
%CREATE_BORDERS creates a vector of the fingertip distance limits
%   If a margin is specified, the borders are limited.
if nargin<1
    margin = 0;
end
global f0_min f0_max f1_min f1_max Dimension

Borders = zeros(Dimension, 2);
Borders(:,1) = f1_min + margin;
Borders(:,2) = f1_max - margin;
Borders(1,1) = f0_min + margin;
Borders(1,2) = f0_max - margin;
end


