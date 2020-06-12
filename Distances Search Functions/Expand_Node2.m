function New_Nodes = Expand_Node2(Node)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global Dimension Borders Movement_Vectors Border_HyperPlanes Last_Index All_Locations
New_Nodes = [];
Useful_Mov_Vecs = Movement_Vectors;
Useful_Mov_Vecs(Node.Parent_Vec,:) = [];
Movement_Vec_Indices = 1:Dimension;
Movement_Vec_Indices(Node.Parent_Vec) = [];
Origin = Node.Location;
counter = 0;
for ii=1:(length(Useful_Mov_Vecs(:,1)))
    Current_Movement_Vector = Useful_Mov_Vecs(ii,:);
    Current_Movement_Vector_Index = Movement_Vec_Indices(ii);
    Ray = [Origin, Current_Movement_Vector];
     for jj=1:2*Dimension %The number of hypercube facets is 2*dimension
        Border_Intersection = Line_Hyperplane_Intersection(Ray, Border_HyperPlanes(jj,:));
        if ~isempty(Border_Intersection)
            if ~isequal(Border_Intersection,Origin)
                if Point_In_HyperCube(Border_Intersection, Borders)
                    if ~ismember(Border_Intersection,All_Locations,'rows') %Avoids duplicates
                        All_Locations = [All_Locations;Border_Intersection];
                        counter = counter + 1;
                        Last_Index = Last_Index + 1;
                        New_Nodes(counter).Index = Last_Index ;
                        New_Nodes(counter).Parent = Node.Index;
                        New_Nodes(counter).Depth = Node.Depth + 1;
                        New_Nodes(counter).Location = Border_Intersection;
                        New_Nodes(counter).Parent_Vec = Current_Movement_Vector_Index;
                    end
                end
            end
        end
     end
end


end

