function [ V ] = cross2D( V1,V2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
J=[0 1;-1 0];
if isequal(size(V1),[1,2])
    V=V1*J*V2';
elseif isequal(size(V1),[2,1])
    V=V1'*J*V2;
end

