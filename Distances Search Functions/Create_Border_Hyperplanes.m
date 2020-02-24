function Border_HyperPlanes = Create_Border_Hyperplanes(Borders)
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

Dim = length(Borders(:,1));
Border_HyperPlanes = zeros(2*Dim, 2*Dim); %A hypercube has 2n sides, n is the dimension.
Normal_Vectors = eye(Dim);
Border_HyperPlanes(:,Dim+1:end) = [Normal_Vectors;Normal_Vectors];
Border_HyperPlanes(Dim+1:end,1:Dim) = ones(Dim);

for ii=1:Dim
    Border_HyperPlanes(ii,1:Dim) = Borders(:,1)';
end
for ii=Dim+1:Dim*2
    Border_HyperPlanes(ii,1:Dim) = Borders(:,2)';
end
end

