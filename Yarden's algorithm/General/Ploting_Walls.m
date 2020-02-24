function [] = Ploting_Walls( Wall )
% This MATLAB function's input is a struct that contains information about a
% wall, and plots it.

for ii = 1:Wall.Num
    Wall.Plot{ii} = plot(Wall.Corr(1:2:3,ii),Wall.Corr(2:2:4,ii),'k-','LineWidth',2);
    Wall.Plot{ii}.HandleVisibility = 'off';
end

end

