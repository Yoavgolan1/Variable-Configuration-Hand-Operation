Grasp_Item(Cracker_Box)
Set_In_Box(Cracker_Box)
robot.MoveL(Cracker_Box.Above_Frame)

Grasp_Item(Sugar_Box)
robot.MoveL(Cracker_Box.Above_Frame)
Set_In_Box(Sugar_Box)


robot.MoveL(Cracker_Box.Above_Frame)

Hand_Adjust([120,240],[50+30,50+30,105])
Reorient_And_Redistance(1,Power_Drill.Angles(1),0,1)
Reorient_And_Redistance(2,Power_Drill.Angles(2),30,1)
Grasp_Item(Power_Drill)
Set_In_Box(Power_Drill)