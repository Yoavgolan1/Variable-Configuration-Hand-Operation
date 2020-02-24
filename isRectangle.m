function [answer, Quality] = isRectangle(Shape,epsilon)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    epsilon = 0.1;
end

answer = false;


Poly = Shape.Vertex;
if size(Poly,1) ~=4
    error('Not a 4 sided polygon');
end

Corner1 = Poly(1,:);
Corner2 = Poly(2,:);
Corner3 = Poly(3,:);
x1 = Corner1(1);
y1 = Corner1(2);
x2 = Corner2(1);
y2 = Corner2(2);
x3 = Corner3(1);
y3 = Corner3(2);

M = [(x1+x3)/2, (y1+y3)/2];

Fake_Corner = 2*M - [x2,y2];

poly1 = polyshape(Poly(:,1), Poly(:,2));
fake_rectangle = polyshape([x1 x2 x3 Fake_Corner(1)],[y1 y2 y3 Fake_Corner(2)]);

polyout1 = subtract(poly1,fake_rectangle);
polyout2 = subtract(fake_rectangle,poly1);


Original_Area = area(poly1);
A = area(polyout1)+area(polyout2);

Quality = A/Original_Area;
if A/Original_Area < epsilon
    answer = true;
end

end

