function OutHP = SuperCross(varargin)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

N_Vecs = nargin;
My_Matrix = zeros(N_Vecs,N_Vecs+1);
for ii=1:N_Vecs
    My_Matrix(ii,:) = varargin{ii};
end

OutHP = null(My_Matrix)';

end

