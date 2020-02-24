clear all
close all

x_min = -400; x_max = -x_min;
y_min = -400; y_max = -y_min;
r_min = 64;
r_max = 195;

figure
axis([x_min  x_max y_min y_max])
axis equal
hold on
grid on

good_places = false;
while ~good_places
    P_1 = [randi([x_min,x_max]),randi([y_min,y_max])];
    P_2 = [randi([x_min,x_max]),randi([y_min,y_max])];
    P_3 = [randi([x_min,x_max]),randi([y_min,y_max])];
    
    if pdist([P_1;P_2])<2*r_max && pdist([P_2;P_3])<2*r_max && pdist([P_1;P_3])<2*r_max
        good_places = true;
    end
end
Points = [P_1;P_2;P_3];

plot(Points(:,1),Points(:,2),'*k')

Inner_Circ_1 = viscircles(P_1,r_min,'LineWidth',1,'LineStyle','-','Color','r');
Inner_Circ_2 = viscircles(P_2,r_min,'LineWidth',1,'LineStyle','-','Color','r');
Inner_Circ_3 = viscircles(P_3,r_min,'LineWidth',1,'LineStyle','-','Color','r');

Outer_Circ_1 = viscircles(P_1,r_max,'LineWidth',1,'LineStyle','-','Color','m');
Outer_Circ_2 = viscircles(P_2,r_max,'LineWidth',1,'LineStyle','-','Color','m');
Outer_Circ_3 = viscircles(P_3,r_max,'LineWidth',1,'LineStyle','-','Color','m');

List_Of_Good_Points = [];
for ii=1:10000
    point = [randi([P_1(1)-r_max,P_1(1)+r_max]),randi([P_1(2)-r_max,P_1(2)+r_max])];
    r1 = pdist([P_1;point]);
    if r1>r_max || r1<r_min
        continue
    end
    r2 = pdist([P_2;point]);
    if r2>r_max || r2<r_min
        continue
    end
    r3 = pdist([P_3;point]);
    if r3>r_max || r3<r_min
        continue
    end
    List_Of_Good_Points(end+1,:) = point;
end
plot(List_Of_Good_Points(:,1),List_Of_Good_Points(:,2),'.b')

List_Of_Very_Good_Points = [];
for ii=1:length(List_Of_Good_Points)
    point = List_Of_Good_Points(ii,:);
    
    V1 = P_1 - point;
    V2 = P_2 - point;
    V3 = P_3 - point;
    
    theta12 = acos(min(1,max(-1, V1(:).' * V2(:) / norm(V1) / norm(V2) )));
    theta13 = acos(min(1,max(-1, V1(:).' * V3(:) / norm(V1) / norm(V3) )));
    theta23 = acos(min(1,max(-1, V2(:).' * V3(:) / norm(V2) / norm(V3) )));
    
    
    if min([theta12,theta13,theta23])>deg2rad(45)
        List_Of_Very_Good_Points(end+1,:)=point;
    end
end
hold on
if ~isempty(List_Of_Very_Good_Points)
    plot(List_Of_Very_Good_Points(:,1),List_Of_Very_Good_Points(:,2),'.g')
end
