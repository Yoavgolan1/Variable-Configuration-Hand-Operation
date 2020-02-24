x1 = [0;-1];
x2 = [-cos(deg2rad(30));sin(deg2rad(30))];
x3 = [cos(deg2rad(30));sin(deg2rad(30))];
n1 = [0;1];
n2 = [cos(deg2rad(30));-sin(deg2rad(30))];
n3 = [-cos(deg2rad(30));-sin(deg2rad(30))];

w1=[x1;cross2D(n1,x1)];
w2=[x2;cross2D(n2,x2)];
w3=[x3;cross2D(n3,x3)];

G=[w1,w2,w3];