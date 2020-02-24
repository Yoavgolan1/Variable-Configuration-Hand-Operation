function Target_HyperPlanes = Create_Target_Hyperplanes(Target, Movement_Vectors)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
Dim = length(Target);

% 2D
if Dim==2
    Two_Dim_Vecs = zeros(Dim,Dim*2);
    for ii=1:Dim
        Two_Dim_Vecs(ii,:) = [Target, Movement_Vectors(ii,:)*[cos(pi/2) -sin(pi/2); sin(pi/2) cos(pi/2)]];
    end
    Target_HyperPlanes = Two_Dim_Vecs;
    Target_HyperPlanes = round(Target_HyperPlanes,5);
    return
end

% 3D
if Dim == 3
    Three_Dim_Vecs = zeros(Dim,Dim*2);
    counter = 0;
    for ii=1:Dim
        for jj=1:Dim
            if ii==jj
                continue
            else
                counter = counter + 1;
                New_Dir = SuperCross(Movement_Vectors(ii,:),Movement_Vectors(jj,:));
                if New_Dir(1) < 0
                    New_Dir = -New_Dir;
                end
                New_Dir = round(New_Dir,5);
                Three_Dim_Vecs(counter,:) = [Target, New_Dir];
            end
        end
    end
    Three_Dim_Vecs = unique(Three_Dim_Vecs,'rows');
    
    Target_HyperPlanes = Three_Dim_Vecs;
    return
end

Four_Dim_Vecs = zeros(Dim,Dim*2);
counter = 0;
for ii=1:Dim
    for jj=1:Dim
        for kk=1:Dim
            if ii==kk || jj==kk || ii==jj
                continue
            else
                counter = counter + 1;
                New_Dir = SuperCross(Movement_Vectors(ii,:),Movement_Vectors(jj,:),Movement_Vectors(kk,:));
                if New_Dir(1) <0
                    New_Dir = -New_Dir;
                end
                New_Dir = round(New_Dir,5);
                Four_Dim_Vecs(counter,:) = [Target, New_Dir];
            end
        end
    end
end
Four_Dim_Vecs = unique(Four_Dim_Vecs,'rows');
if Dim == 4
    Target_HyperPlanes = Four_Dim_Vecs;
end

