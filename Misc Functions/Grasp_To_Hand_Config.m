function [Hand_Configs] = Grasp_To_Hand_Config(Hand_Centers,Finger_Placements)
%GRASP_TO_HAND_CONFIG transforms a hand center and finger placements to a
%hand structure, comprised of finger angles and fingertip distances.

N_Fingers = size(Finger_Placements,1);
N_Centers = size(Hand_Centers,1);
N_Configs = N_Fingers*N_Centers;

%Hand_Configs = zeros(N_Configs,1);
Angles = zeros(N_Fingers,1);

for ii=1:N_Centers
    This_Center = Hand_Centers(ii,:);
    Temp_Distances = pdist([This_Center;Finger_Placements])';
    Distances = Temp_Distances(1:N_Fingers);
    
    Vecs = Finger_Placements - This_Center;
    
    
    Temp_Angles = zeros(N_Fingers,1);
    for jj=1:N_Fingers
        V1 = [1 0]; %x axis vector
        V2 = Vecs(jj,:);
        %Temp_Angles(jj) = acos(min(1,max(-1, V1(:).' * V2(:) / norm(V1) / norm(V2) )));
        Temp_Angles(jj) = atan2d(V1(1)*V2(2)-V1(2)*V2(1),V1(1)*V2(1)+V1(2)*V2(2));
    end
    t = Temp_Angles < 0;
    Temp_Angles(t) = Temp_Angles(t) + 360;
    [~,Ind] = sort(Temp_Angles);
    Vecs = Vecs(Ind,:);
    
    Vecs = [Vecs;Vecs(1,:)];
    for jj=1:N_Fingers
        V1 = Vecs(jj,:);
        V2 = Vecs(jj+1,:);
        %Angles(jj) = acos(min(1,max(-1, V1(:).' * V2(:) / norm(V1) / norm(V2) )));
        Angles(jj) = atan2d(V1(1)*V2(2)-V1(2)*V2(1),V1(1)*V2(1)+V1(2)*V2(2));
    end
    %t = Angles < 0;
    %Angles(t) = Angles(t) + 360;
    Angles = deg2rad(Angles); %atan2d returns the value in degrees for some reason. acos returns rads
    
    This_Config.Distances = Distances;
    This_Config.Angles = Angles;
    This_Config.Center = This_Center;
    Hand_Configs((ii-1)*N_Fingers+1) = This_Config;
    for jj=2:N_Fingers
        Distances = [Distances(2:end);Distances(1)];
        Angles = [Angles(2:end);Angles(1)];
        This_Config.Distances = Distances;
        This_Config.Angles = Angles;
        This_Config.Center = This_Center;
        Hand_Configs((ii-1)*N_Fingers+jj) = This_Config;
    end
    
end

end

