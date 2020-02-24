function [New_Object] = Create_RoboDK_Object(YCB_Object_Name,Object_Center)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global Hand_Configuration safe_height RDK Grasp_Finger_Placements Best_Config
if nargin<2
    Object_Center = [-42.28,-1034];
end
if nargin<1
    YCB_Object_Name = 'NONE';
end

Base_Finger_Vec = Grasp_Finger_Placements(1,:) - Best_Config.Center;
Base_Finger_Angle = atan2(Base_Finger_Vec(2),Base_Finger_Vec(1));
r_max = 195;
World2Camera_Center = transl(0,-790,0);
Hand_Center = transl(Best_Config.Center(1),Best_Config.Center(2),0);
THC = World2Camera_Center*Hand_Center; %True hand center

New_Object = [];
switch YCB_Object_Name
    case 'NONE'
        New_Object.Item = RDK.AddFile('D:\Google Drive\Research\4th Hand\RoboDK\Objects\box.sld');
        New_Object.Item.setName('Undefined Object');
        New_Object.Item.setPose(THC*transl(0,0,50)*rotx(0*pi/180)*roty(0*pi/180)*rotz(0*pi/180));
        New_Object.Above_Frame = RDK.AddTarget('Above Undefined Object');
        New_Object.Above_Frame.setPose(THC*transl(0,0,safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz(Base_Finger_Angle+deg2rad(90)));
        New_Object.Angles = Best_Config.Abs_Angles;
        New_Object.Grasp_Dist = Best_Config.Distances';
        New_Object.Pre_Grasp_Dist = New_Object.Grasp_Dist + r_max - max(New_Object.Grasp_Dist) - 20;
        
    case 'POWER_DRILL'
        New_Object.Item = RDK.AddFile('D:\Google Drive\Research\4th Hand\RoboDK\Objects\035_power_drill\poisson\textured.obj');
        New_Object.Item.setName('Power drill');
        New_Object.Item.setPose(THC*transl(0,0,39.596)*rotx(-90.956*pi/180)*roty(-6.836*pi/180)*rotz(-37.049*pi/180));
        New_Object.Above_Frame = RDK.AddTarget('Above Power drill');
        New_Object.Above_Frame.setPose(THC*transl(0,0,safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz(-174.788*pi/180));
        New_Object.Angles = Best_Config.Abs_Angles;
        New_Object.Grasp_Dist = Best_Config.Distances';
        New_Object.Pre_Grasp_Dist = New_Object.Grasp_Dist + r_max - max(New_Object.Grasp_Dist) - 20;
        
    case 'MUSTARD_BOTTLE'
        New_Object.Item = RDK.AddFile([pwd,'\RoboDK Files\Objects\Mustard_Bottle\textured.obj']);
        New_Object.Item.setName('Mustard Bottle');
        New_Object.Item.setPose(transl(Object_Center(1)+10,Object_Center(2)-90,29.6)*rotx(-89.28*pi/180)*roty(-6.6*pi/180)*rotz(-126.8*pi/180));
        New_Object.Above_Frame = RDK.AddTarget('Above Mustard Bottle');
        New_Object.Above_Frame.setPose(transl(Object_Center(1),Object_Center(2),safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz(-174.788*pi/180));
        New_Object.Angles = [100,190];
        New_Object.Grasp_Dist = [0, 0, 65];
        New_Object.Pre_Grasp_Dist = New_Object.Grasp_Dist + 40;
    otherwise
        
end

end

