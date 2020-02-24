function Path =  Reconstruct_Path(Node,Closed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if Node.Index == 1
    Path = Node;
    return
end

My_Parent = Node.Parent;
for ii=1:length(Closed)
    if Closed(ii).Index == My_Parent
        Parent_Node = Closed(ii);
        Path = [Node, Reconstruct_Path(Parent_Node,Closed)];
        return
    end
end


end

