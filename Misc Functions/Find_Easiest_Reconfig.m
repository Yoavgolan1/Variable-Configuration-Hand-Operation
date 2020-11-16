function [Best_Config, Distance_Instructions] = Find_Easiest_Reconfig(Hand_Configuration, Possible_Hand_Configs)
%FIND_EASIEST_RECONFIG takes a list of hand centers, and finds the one that
%requires the least adjustments to achieve as a hand structure.
%   A hand center, along with fingertip placements, describes a hand
%   structure. Given multiple hand structures, and the initial hand
%   configuration, we check which of the hand configurations requires the
%   least time to adjust to (least number of distance changes). Special
%   structures are given priority.

N_Fingers = length(Possible_Hand_Configs(1).Distances);
N_Configs = length(Possible_Hand_Configs);

Lowest_N_Steps = Inf;
Best_Path = [];
for ii = 1:N_Configs
    disp([num2str(ii),'/',num2str(N_Configs),' Hand center options tested']);
    This_Config = Possible_Hand_Configs(ii);
    [IsPossible, N_Steps, Path] = Produce_Distance_Instructions_Vec_Decomp(Hand_Configuration, Possible_Hand_Configs(ii).Distances, Lowest_N_Steps);
    [IsPossible, N_Steps, Path] = Produce_Distance_Instructions(Hand_Configuration, Possible_Hand_Configs(ii).Distances, Lowest_N_Steps);

    if N_Steps < Lowest_N_Steps && IsPossible
        Lowest_N_Steps = N_Steps;
        Best_Path = Path;
        Best_Center = This_Config.Center;
        Best_Config = This_Config;
        if Lowest_N_Steps<=N_Fingers
            break
        end
    end
end
Best_Path = flipud(Best_Path);

Distance_Instructions = Path2Instructions(Hand_Configuration,Best_Path);
%Center = Best_Center;
Best_Config.Abs_Angles = Rel2Abs_Angles(Best_Config.Angles');
%Best_Path.Location;
disp('A hand center has been selected, and raw instructions have been produced.');
end

