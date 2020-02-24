%% Walls Information

% %% Regular Chamber
% Wall.K = 350;   % Elastic constant
% Wall.Mu             = 0.1;   % Friction coefficient. 
%  
% Wall.Corr(1:4,1) = [-20 -20 -20 20]';  %[x1 y1 x2 y2]'
% Wall.Corr(1:4,2) = [-20 20 20 20]';
% Wall.Corr(1:4,3) = [20 20 20 -20]';
% Wall.Corr(1:4,4) = [20 -20 -20 -20]';
% 
% Wall.Num = 2;
% Wall.Force = [0 0]';
% Wall.Torque = 0;


%% One Wall
Wall.K              = 100;   % Elastic constant
Wall.Mu             = 0.1;   % Friction coefficient.

Wall.Corr(1:4,1)    = [-20 -20 -20 20]';  %[x1 y1 x2 y2]'
% Wall.Corr(1:4,1)    = [-20 -20 -20 0]';  %[x1 y1 x2 y2]'

Wall.Num            = 1;
Wall.Force          = [0 0]';
Wall.Torque         = 0;

% %% Two Walls
% Wall.K = 350;   % Elastic constant
% Wall.Mu             = 0.1;   % Friction coefficient. 
% 
% Wall.Corr(1:4,1) = [-20 -20 -20 20]';  %[x1 y1 x2 y2]'
% Wall.Corr(1:4,2) = [-20 20 20 20]';
% 
% Wall.Num = 2;
% Wall.Force = [0 0]';
% Wall.Torque = 0;

