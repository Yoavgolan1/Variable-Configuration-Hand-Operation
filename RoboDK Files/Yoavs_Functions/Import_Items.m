% This code imports items to RoboDK. All poses are set in
% "Stabuli/Mecademic" position mode.



Sugar_Box.Item = RDK.AddFile('D:\Google Drive\Research\4th Hand\RoboDK\Objects\004_sugar_box\poisson\textured.obj');
Sugar_Box.Item.setName('Sugar box');
Sugar_Box.Item.setPose(transl(560,260,14)*rotx(90*pi/180)*roty(40*pi/180)*rotz(-38*pi/180));
Sugar_Box.Above_Frame = RDK.AddTarget('Above Sugar box');
Sugar_Box.Above_Frame.setPose(transl(614.129,184.3345,safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz((-140.450-45)*pi/180));
Sugar_Box.Angles = [45,180,180+45];
Sugar_Box.Grasp_Dist = [10,20,10,20];
Sugar_Box.Pre_Grasp_Dist = Sugar_Box.Grasp_Dist + 50;



Cracker_Box.Item = RDK.AddFile('D:\Google Drive\Research\4th Hand\RoboDK\Objects\003_cracker_box\poisson\textured.obj');
Cracker_Box.Item.setName('Cracker box');
Cracker_Box.Item.setPose(transl(54,468,47.8)*rotx(-88*pi/180)*roty(12.7*pi/180)*rotz(98.1*pi/180));
Cracker_Box.Above_Frame = RDK.AddTarget('Above Cracker box');
Cracker_Box.Above_Frame.setPose(transl(90.257,583.120,safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz(169.338*pi/180));
Cracker_Box.Angles = [90,180,270];
Cracker_Box.Grasp_Dist = [55,22,55,22];
Cracker_Box.Pre_Grasp_Dist = Cracker_Box.Grasp_Dist + 50;


Power_Drill.Item = RDK.AddFile('D:\Google Drive\Research\4th Hand\RoboDK\Objects\035_power_drill\poisson\textured.obj');
Power_Drill.Item.setName('Power drill');
Power_Drill.Item.setPose(transl(337.721,205.439,39.596)*rotx(-90.956*pi/180)*roty(-6.836*pi/180)*rotz(-37.049*pi/180));
Power_Drill.Above_Frame = RDK.AddTarget('Above Power drill');
Power_Drill.Above_Frame.setPose(transl(346.223,331.004,safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz(-174.788*pi/180));
Power_Drill.Angles = [100,190];
Power_Drill.Grasp_Dist = [0, 0, 65];
Power_Drill.Pre_Grasp_Dist = Power_Drill.Grasp_Dist + 40;


Mustard_Bottle.Item = RDK.AddFile([pwd,'\RoboDK Files\Objects\Mustard_Bottle\textured.obj']);
Mustard_Bottle.Item.setName('Mustard Bottle');
Mustard_Bottle.Item.setPose(transl(-42.28,-1034,29.6)*rotx(-89.28*pi/180)*roty(-6.6*pi/180)*rotz(-126.8*pi/180));
Mustard_Bottle.Above_Frame = RDK.AddTarget('Above Mustard Bottle');
Mustard_Bottle.Above_Frame.setPose(transl(346.223,331.004,safe_height)*rotx(0*pi/180)*roty(0*pi/180)*rotz(-174.788*pi/180));
Mustard_Bottle.Angles = [100,190];
Mustard_Bottle.Grasp_Dist = [0, 0, 65];
Mustard_Bottle.Pre_Grasp_Dist = Mustard_Bottle.Grasp_Dist + 40;