
# Variable Configuration Hand Operation
 This project involves the operation of a variable configuration robot hand.
 Here you can find Matlab code for the simulation and operation of a variable configuration hand, as seen in a paper submitted to IROS2020/RA-L.
 ![The variable configuration hand ](https://github.com/Yoavgolan1/Variable-Configuration-Hand-Operation/blob/master/Hand_Pic.jpg)

# Software Requirements

## Matlab
This code was built in Matlab 2018a, but will probably run on earlier versions. To use the Arduino functionality, the Arduino addon must be installed. To use the webcam functionality, the Webcam addon must be installed. Simulation mode does not require either of these addons. The statistics toolbox is used for the pdist function.

## RoboDK
Simulations and robot operation are performed using the RoboDK simulator. The free version is enough to run everything, including the run-on-robot mode. RoboDK is available at http://robodk.com.The minimum version is v4.2.0, due to critical updates for the robotic arm used.
