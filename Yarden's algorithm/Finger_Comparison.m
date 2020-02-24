clear all
close all
x=[3,4,5,6,7,8];
%% 3 Fingers
% No_Friction_Mean(1) = 0.3635;     
% STDEV_No_Friction(1) = 0.0751;    
% Friction_At_No_Friction_Mean(1) = 1.1048;
% STDEV_Friction_At_No_Friction(1) = 0.3121;
% Best_Friction_Mean(1) = 2.4120;
% STDEV_Best_Friction(1) = 0.4474;
No_Friction_Mean(1) = 0.3512;     
STDEV_No_Friction(1) = 0.0861;    
Friction_At_No_Friction_Mean(1) = 1.1508;
STDEV_Friction_At_No_Friction(1) = 0.3079;
Best_Friction_Mean(1) = 2.4113;
STDEV_Best_Friction(1) = 0.4484;

%% 4 Fingers
No_Friction_Mean(2) = 3.4945;     
STDEV_No_Friction(2) = 0.5835;    
Friction_At_No_Friction_Mean(2) = 4.4204;
STDEV_Friction_At_No_Friction(2) = 0.6985;
Best_Friction_Mean(2) = 4.5348;
STDEV_Best_Friction(2) = 0.6817;

%% 5 Fingers
No_Friction_Mean(3) = 4.8961;     
STDEV_No_Friction(3) = 0.8097;    
Friction_At_No_Friction_Mean(3) = 6.1602;
STDEV_Friction_At_No_Friction(3) = 0.9791;
Best_Friction_Mean(3) = 6.2541;
STDEV_Best_Friction(3) = 0.9717;

%% 6 Fingers
No_Friction_Mean(4) = 6.3942;     
STDEV_No_Friction(4) = 1.0441;    
Friction_At_No_Friction_Mean(4) = 8.0157;
STDEV_Friction_At_No_Friction(4) = 1.2454;
Best_Friction_Mean(4) = 8.1387;
STDEV_Best_Friction(4) = 1.2576;

%% 7 Fingers
No_Friction_Mean(5) = 7.9258;     
STDEV_No_Friction(5) = 1.2950;    
Friction_At_No_Friction_Mean(5) = 9.9702;
STDEV_Friction_At_No_Friction(5) = 1.5112;
Best_Friction_Mean(5) = 10.0815;
STDEV_Best_Friction(5) = 1.5096;

%% 8 Fingers
No_Friction_Mean(6) = 9.5850;     
STDEV_No_Friction(6) = 1.5405;    
Friction_At_No_Friction_Mean(6) = 12.0777;
STDEV_Friction_At_No_Friction(6) = 1.8228;
Best_Friction_Mean(6) = 12.1982;
STDEV_Best_Friction(6) = 1.8338;

% %% 30 Fingers
% x=[3,4,5,6,7,8,50];
% No_Friction_Mean(7) = 120.026273839915;     
% STDEV_No_Friction(7) = 22.6787100498573;    
% Friction_At_No_Friction_Mean(7) = 157.863471879189;
% STDEV_Friction_At_No_Friction(7) = 22.3555635767428;
% Best_Friction_Mean(7) = 158.540624549921;
% STDEV_Best_Friction(7) = 21.5922272078835;

%% Plot

errorbar(x,No_Friction_Mean,STDEV_No_Friction,'-diamondb','markersize',5)
hold on
errorbar(x,Friction_At_No_Friction_Mean,STDEV_Friction_At_No_Friction,'-xr','markersize',9)
errorbar(x,Best_Friction_Mean,STDEV_Best_Friction,'-ok','markersize',4)
grid on

%plot(x,No_Friction_Mean,'diamondb','markersize',5)
%plot(x,Friction_At_No_Friction_Mean,'xr','markersize',9)
%plot(x,Best_Friction_Mean,'.k','markersize',12)
xlabel('Number of Fingers','Interpreter','Latex');
ylabel('Quality measure $Q$','Interpreter','Latex');
ax=gca;
ax.FontName = 'CMU Serif';
ax.XTick = x;
legend('Best-Case Frictionless Grasp','Friction Grasp at Best Case-Frictionless Configuration','Best-Case Friction Grasp','Location','northwest')