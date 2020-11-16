function [Hand_Center, Finger_Placements] = Best_Grasp_That_Works(Sorted_List_Of_Grasps,r_min,r_max)
%BEST_GRASP_THAT_WORKS takes finger placements and returns the best one
%that works with the hand geometry
%   Given a sorted list of possible grasp configurations (best to worst),
%   the function tries to find the first grasp configuration that is viable
%   considering the hand geometry.
global Polygon Hand_Center_Finger_Center_Dist Aux_Fig
if nargin<3
    r_min = Hand_Center_Finger_Center_Dist;
    r_max = r_min+144.44;
end
if isempty(Sorted_List_Of_Grasps)
    Hand_Center= []; Finger_Placements = [];
    warning('No valid grasps');
    return;
end

N_Fingers = size(Sorted_List_Of_Grasps(1).Configuration,1);
N_Configs = size(Sorted_List_Of_Grasps,2);
Angles = zeros(N_Fingers,1);
Good_Point = [];
MyPoly = Polygon.Vertex;

for ii=1:N_Configs
    disp([num2str(ii),'/',num2str(N_Configs),' Configurations tested']);
    Finger_Places = Sorted_List_Of_Grasps(ii).Configuration;
    Distances = pdist(Finger_Places);
    if max(Distances)>2*r_max %If two fingers are too far apart
        continue;
    end
    
    Point_Found = false;
    Give_Up = false;
    kk = 0;
    while kk<1000 && ~Give_Up && ~Point_Found
        kk = kk+1;
        [point(1),point(2)] = Random_Point_In_Donut(Finger_Places(1,1),Finger_Places(1,2),r_min,r_max);
        Bad_Point = false;
        
        if kk==1 && N_Fingers == 2
            point(1) = mean(Finger_Places(1,:));
            point(2) = mean(Finger_Places(2,:));
            
        elseif kk==1 && N_Fingers == 3 %Try special hand center for 3 fingers
            [point(1),point(2)] = Circle_Center_From_3_Points(Finger_Places);
            
        elseif kk==1 && N_Fingers == 4 %Try special hand center for 4 fingers
            %This requires the first grasp to be rectangular, otherwise it
            %doesn't do much
            point(1) = mean(Finger_Places(:,1));
            point(2) = mean(Finger_Places(:,2));
        end
        
        % Distance tests
        for ll=2:N_Fingers
            Point_Finger_Dist = pdist([point;Finger_Places(ll,:)]);
            if Point_Finger_Dist>r_max || Point_Finger_Dist<r_min
                Bad_Point = true;
            end
        end
        if Bad_Point
            continue;
        end
        
        % Angle tests
        Inter_Point_Vectors = Finger_Places - point;
        %Inter_Point_Vectors = [Inter_Point_Vectors; Inter_Point_Vectors(1,:)];
        
        Vector_Indexes = nchoosek(1:N_Fingers,2);
        for jj=1:size(Vector_Indexes,1)
            V1 = Inter_Point_Vectors(Vector_Indexes(jj,1),:);
            V2 = Inter_Point_Vectors(Vector_Indexes(jj,2),:);
            Angles(jj) = acos(min(1,max(-1, V1(:).' * V2(:) / norm(V1) / norm(V2) )));
        end
        if min(Angles)<deg2rad(45)
            continue;
        end
        
        
        % Squeezing test
        squeeze_flag = true;
        for jj=1:N_Fingers
            Vec = point - Finger_Places(jj,:);
            Vec = Vec/norm(Vec);
            test_point = Finger_Places(jj,:) + Vec*0.001; %Slightly close hand
            if ~inpolygon(test_point(1),test_point(2),MyPoly(:,1),MyPoly(:,2))
                squeeze_flag = false;
            end
        end
        if ~squeeze_flag
            continue;
        end
        
        %Point_Found = true;
        Good_Point(end+1,:) = point;
    end
    if ~isempty(Good_Point)
        break;
    end
end

%f = figure(1);
grid on
axis equal
hold on
fing_color = [0 1 0];
for jj=1:N_Fingers
    Inner_Circ(jj) = viscircles(Finger_Places(jj,:),r_min,'LineWidth',1,'LineStyle','-','Color','r');
    Outer_Circ(jj) = viscircles(Finger_Places(jj,:),r_max,'LineWidth',1,'LineStyle','-','Color','m');
    Circ_Cent(jj) =  plot(Finger_Places(jj,1),Finger_Places(jj,2),'ok','MarkerFaceColor',fing_color);
    fing_color = [1 0 0];
end
%savefig('Aux_Fig.fig')
%Aux_Fig.Finger_Placements = Circ_Cent;

Grasp = Good_Point;
Finger_Placements = Finger_Places;
Hand_Center = Grasp;
if isempty(Hand_Center)
    error('No valid grasp found');
else
    disp('Considering physical constraints, the best feasible grasp has been found.');
end
end


function [x,y]=Random_Point_In_Donut(x1,y1,r_in,r_out)
a = 2*pi*rand;
r = unifrnd(r_in,r_out);
x = (r)*cos(a)+x1;
y = (r)*sin(a)+y1;
end

function [x,y] = Circle_Center_From_3_Points(Finger_Places)
x1 = Finger_Places(1,1);
y1 = Finger_Places(1,2);
x2 = Finger_Places(2,1);
y2 = Finger_Places(2,2);
x3 = Finger_Places(3,1);
y3 = Finger_Places(3,2);

A = det([x1 y1 1; x2 y2 1; x3 y3 1]);
B = -det([x1^2+y1^2, y1, 1; x2^2+y2^2, y2, 1; x3^2+y3^2, y3, 1]);
C =  det([x1^2+y1^2, x1, 1; x2^2+y2^2, x2, 1; x3^2+y3^2, x3, 1]);

if A==0
    error('All three points on a line');
end
x = -B/(2*A);
y = -C/(2*A);
end