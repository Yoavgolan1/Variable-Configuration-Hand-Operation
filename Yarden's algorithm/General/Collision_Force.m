function [ Shape, Wall ] = Collision_Force( Shape, Wall) %, Velocity )
% 
% 
% 
% 
% 

% if Wall.Num > 0
% 
%     
%     R = [ cos(Shape.teta) , -sin(Shape.teta) ; sin(Shape.teta) , cos(Shape.teta) ]; % R(teta) is the rotation matrix 
%     
%     jj = 0; delta = 0; direction = 0; index = 0;
%     Wall.Torque = 0; Wall.Force = [0 0]';    
% 
%     TorqueDamper = 0.05;
%     
%     for WallIndex = 1:size(Wall.Corr,2)
%         ShapeWorldFrame = [R*Shape.Vertex' + Shape.d*ones(1,length(Shape.Vertex(:,1))); zeros(1,length(Shape.Vertex(:,1)))];
%         MatA{WallIndex} = ShapeWorldFrame - [Wall.Corr(1:2,WallIndex) ; 0]*ones(1,length(ShapeWorldFrame));
%         MatB{WallIndex} = [Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex); 0]*ones(1,length(ShapeWorldFrame));
%         MatC{WallIndex} = cross(MatA{WallIndex},MatB{WallIndex});
%         IsInside1{WallIndex} = [min(MatC{WallIndex}(3,:)), max(MatC{WallIndex}(3,:))];
%         
%         if IsInside1{WallIndex}(1)*IsInside1{WallIndex}(2) < 0  % the polygon penetrated the wall line         
% %             MatD{WallIndex} = ShapeWorldFrame - [Wall.Corr(3:4,WallIndex) ; 0]*ones(1,length(ShapeWorldFrame));                
% %             IsInside2{WallIndex} = sum([MatA{WallIndex}.*MatB{WallIndex}, MatD{WallIndex}.*(-MatB{WallIndex})],1);
% %          
% %             if  sum(sign(IsInside2{WallIndex})) ~= 0
% %                 for ii = 1:length(MatC{WallIndex}(3,:))
% %                     if sign(MatC{WallIndex}(3,ii)) ~= sign(max(abs(MatC{WallIndex}(3,:))))
% %                         jj = jj+1;
% %                         [direction(1:2,jj), delta(jj)] = Point2Line(ShapeWorldFrame(1:2,ii),Wall.Corr(1:2,WallIndex),Wall.Corr(3:4,WallIndex));
% %                         index(jj) = ii;
% %                     end
% %                 end
% %                 Wall.Force = Wall.Force + sum((ones(2,1)*delta*Wall.K).*direction,2);
% %                 Wall.Torque = Wall.Torque + TorqueDamper*sum(sum(cross( ShapeWorldFrame(:,index) - [Shape.d;0]*ones(1,length(index)), [(ones(2,1)*delta*Wall.K).*direction; zeros(1,length(index))] )));
% %             end
%             
% % %             Conj{WallIndex} = sum(MatA{WallIndex}.*MatB{WallIndex},1)/norm(Wall.Corr(1:2)-Wall.Corr(3:4));
%             
%             SignCM{WallIndex} = cross([ Shape.d - Wall.Corr(1:2,WallIndex); 0],[Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex); 0]);
%             SignCM{WallIndex} = sign(SignCM{WallIndex}(3));
%             
%             % Ind is the indices which are over the wall line
%             Ind = find( sign(MatC{WallIndex}(3,:)) ~= SignCM{WallIndex});
%             
%             
% %             an attempt to solve
%             if Wall.Corr(3,WallIndex) == Wall.Corr(1,WallIndex)
%                 a = inf;
%                 b = inf;
%             else
%                 a = (Wall.Corr(4,WallIndex)-Wall.Corr(2,WallIndex))/((Wall.Corr(3,WallIndex)-Wall.Corr(1,WallIndex)));
%                 b = Wall.Corr(4,WallIndex)-a*Wall.Corr(3,WallIndex);
%             end
%             
%             for ii = 1:size(Ind)
%                 
%                 if Ind(ii) == 1
%                    
%                     if ShapeWorldFrame(1,Ind(ii)) == ShapeWorldFrame(1,end)
%                         m1 = inf;
%                         n1 = inf;
%                     else
%                         m1 = (ShapeWorldFrame(2,Ind(ii))-ShapeWorldFrame(2,end))/(ShapeWorldFrame(1,Ind(ii))-ShapeWorldFrame(1,end));
%                         n1 = ShapeWorldFrame(2,Ind(ii))-m1*ShapeWorldFrame(1,Ind(ii));
%                     end
%                     
%                     if ShapeWorldFrame(1,Ind(ii)) == ShapeWorldFrame(1,Ind(ii)+1)
%                         m2 = inf;
%                         n2 = inf;
%                     else
%                         m2 = (ShapeWorldFrame(2,Ind(ii))-ShapeWorldFrame(2,Ind(ii)+1))/(ShapeWorldFrame(1,Ind(ii))-ShapeWorldFrame(1,Ind(ii)+1));
%                         n2 = ShapeWorldFrame(2,Ind(ii))-m2*ShapeWorldFrame(1,Ind(ii));
%                     end
%                     
%                 elseif Ind(ii) == size(Shape.Vertex,1);
%                     
%                     if ShapeWorldFrame(1,Ind(ii)) == ShapeWorldFrame(1,Ind(ii)-1)
%                         m1 = inf;
%                         n1 = inf;
%                     else
%                         m1 = (ShapeWorldFrame(2,Ind(ii))-ShapeWorldFrame(2,Ind(ii)-1))/(ShapeWorldFrame(1,Ind(ii))-ShapeWorldFrame(1,Ind(ii)-1));
%                         n1 = ShapeWorldFrame(2,Ind(ii))-m1*ShapeWorldFrame(1,Ind(ii));
%                     end
%                     
%                     if ShapeWorldFrame(1,Ind(ii)) == ShapeWorldFrame(1,1)
%                         m2 = inf;
%                         n2 = inf;
%                     else
%                         m2 = (ShapeWorldFrame(2,Ind(ii))-ShapeWorldFrame(2,1))/(ShapeWorldFrame(1,Ind(ii))-ShapeWorldFrame(1,1));
%                         n2 = ShapeWorldFrame(2,Ind(ii))-m2*ShapeWorldFrame(1,Ind(ii));
%                     end
%                     
%                 else
%                     
%                     if ShapeWorldFrame(1,Ind(ii)) == ShapeWorldFrame(1,Ind(ii)-1)
%                         m1 = inf;
%                         n1 = inf;
%                     else
%                         m1 = (ShapeWorldFrame(2,Ind(ii))-ShapeWorldFrame(2,Ind(ii)-1))/(ShapeWorldFrame(1,Ind(ii))-ShapeWorldFrame(1,Ind(ii)-1));
%                         n1 = ShapeWorldFrame(2,Ind(ii))-m1*ShapeWorldFrame(1,Ind(ii));
%                     end
%                     
%                     if ShapeWorldFrame(1,Ind(ii)) == ShapeWorldFrame(1,Ind(ii)+1)
%                         m2 = inf;
%                         n2 = inf;
%                     else
%                         m2 = (ShapeWorldFrame(2,Ind(ii))-ShapeWorldFrame(2,Ind(ii)+1))/(ShapeWorldFrame(1,Ind(ii))-ShapeWorldFrame(1,Ind(ii)+1));
%                         n2 = ShapeWorldFrame(2,Ind(ii))-m2*ShapeWorldFrame(1,Ind(ii));
%                     end
%                     
%                 end
%                 
%             end
%             
%             
% 
% %             if ((  ) && (  )) 
%                 %% case I: The shape penetrated the wall
%   
% %                 might not be necessary
% %             elseif 1 %% Case II: The wall penetrated the shape
%            
% %             end
%         end
%     end
% end

%% Original
if Wall.Num > 0  
    R = [ cos(Shape.teta) , -sin(Shape.teta) ; sin(Shape.teta) , cos(Shape.teta) ]; % R(teta) is the rotation matrix 
    TorqueDamper = 0.05;
    for WallIndex = 1:size(Wall.Corr,2)
        ShapeWorldFrame = [R*Shape.Vertex' + Shape.d*ones(1,length(Shape.Vertex(:,1))); zeros(1,length(Shape.Vertex(:,1)))];
        MatA{WallIndex} = ShapeWorldFrame - [Wall.Corr(1:2,WallIndex) ; 0]*ones(1,length(ShapeWorldFrame));
        MatB{WallIndex} = [Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex); 0]*ones(1,length(ShapeWorldFrame));
        MatC{WallIndex} = cross(MatA{WallIndex},MatB{WallIndex});
        IsInside1{WallIndex} = [min(MatC{WallIndex}(3,:)), max(MatC{WallIndex}(3,:))];
    end
    
    % Checks if the polygon penetrated to the wall, and calculates the delta. 
    jj = 0; delta = 0; direction = 0; index = 0;
    Wall.Torque = 0; Wall.Force = [0 0]';

    for WallIndex = 1:size(Wall.Corr,2)
        if IsInside1{WallIndex}(1)*IsInside1{WallIndex}(2)<0         
            for ii = 1:length(MatC{WallIndex}(3,:))
                if sign(MatC{WallIndex}(3,ii)) ~= sign(max(abs(MatC{WallIndex}(3,:))))
                    jj = jj+1;
                    [direction(1:2,jj), delta(jj)] = Point2Line(ShapeWorldFrame(1:2,ii),Wall.Corr(1:2,WallIndex),Wall.Corr(3:4,WallIndex));
                    index(jj) = ii;
                    
                    
% %                     EdgeVel(1:3,jj) = [Velocity(1:2);0] + [R, [0;0];0 0 1]*cross([0;0;Velocity(3)],[Shape.Vertex(ii,:)';0]);
% %                     if EdgeVel(1:2,jj)'*(Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex))>0
% %                         Dirrr(1:2,jj) = Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex)/norm(Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex));
% %                     else                        
% %                         Dirrr(1:2,jj) = -Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex)/norm(Wall.Corr(3:4,WallIndex)-Wall.Corr(1:2,WallIndex));
% %                     end
% %                     VelNorm(jj) = norm(EdgeVel(1:3,jj));
                end
            end
            Wall.Force = Wall.Force + sum((ones(2,1)*delta*Wall.K).*direction,2);
% %                 +sum((ones(2,1)*Wall.Mu*VelNorm).*Dirrr,2);
            Wall.Torque = Wall.Torque + TorqueDamper*sum(sum(cross(ShapeWorldFrame(:,index) - [Shape.d;0]*ones(1,length(index)), [(ones(2,1)*delta*Wall.K).*direction; zeros(1,length(index))] )));
% %                 +TorqueDamper*sum(sum(cross(ShapeWorldFrame(:,index) - [Shape.d;0]*ones(1,length(index)), [(ones(2,1)*VelNorm*Wall.Mu).*Dirrr; zeros(1,length(index))] )));
        end
    end
end


end

