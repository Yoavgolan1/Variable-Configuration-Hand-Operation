function New_Nodes = Expand_Node(Node, Movement_Vectors, Border_HyperPlanes, Target_HyperPlanes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global Borders Last_Index
Dim = length(Movement_Vectors(:,1));
New_Nodes = []; %% Check
Origin = Node.Location;
counter = 0;
for ii=1:Dim
    Current_Movement_Vector = Movement_Vectors(ii,:);
    Ray = [Origin, Current_Movement_Vector];
    Target_Intersection = [];
    for jj=1:Dim
        Target_Intersection = [Target_Intersection; Line_Hyperplane_Intersection(Ray,Target_HyperPlanes(jj,:))];
    end
    if ~isempty(Target_Intersection)
        if Point_In_HyperCube(Target_Intersection, Borders)
            counter = counter + 1;
            New_Nodes{counter}.Location = Target_Intersection;
            Last_Index = Last_Index + 1;
            New_Nodes{counter}.Index = Last_Index ;
            New_Nodes{counter}.Parent = Node.Index;
            New_Nodes{counter}.Depth = Node.Depth + 1;
            New_Nodes{counter}.Is_Feasible = true;
            New_Nodes{counter}.Resolved = false;
        end
    end
    for jj=1:2*Dim
        Border_Intersection = Line_Hyperplane_Intersection(Ray, Border_HyperPlanes(jj,:));
        if ~isempty(Border_Intersection)
            if Point_In_HyperCube(Border_Intersection, Borders)
                counter = counter + 1;
                New_Nodes{counter}.Location = Border_Intersection;
                Last_Index = Last_Index + 1;
                New_Nodes{counter}.Index = Last_Index ;
                New_Nodes{counter}.Parent = Node.Index;
                New_Nodes{counter}.Depth = Node.Depth + 1;
                New_Nodes{counter}.Is_Feasible = false;
                New_Nodes{counter}.Resolved = false;
            end
        end
    end
end

end

