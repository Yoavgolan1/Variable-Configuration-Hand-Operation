function [] = Ploting_Arms( Arm )
% This function's input is a struct that contains information about a
% robotic arm, and plots it.

R = [ cos(Arm.teta) , -sin(Arm.teta) ; sin(Arm.teta) , cos(Arm.teta) ]; % R(teta) is the rotation matrix 
t = linspace(0, 2*pi); % fingertips element

BaseWorldFrame = Arm.d*ones(1,length(Arm.Base(1,:)))+R*[Arm.Base(1,:); Arm.Base(2,:)];
WristWroldFrame = Arm.d*ones(1,2)+R*[0 0; 0 Arm.Wrist];
FingerWorldFrame = Arm.d*ones(1,Arm.Type) + R*Arm.Finger.Location;

plot(WristWroldFrame(1,:),WristWroldFrame(2,:),'b-','lineWidth',1)
for ii = 1:Arm.Type
    plot([WristWroldFrame(1,2), FingerWorldFrame(1,ii)], [WristWroldFrame(2,2), FingerWorldFrame(2,ii)],'b-','lineWidth',1)
    fill(FingerWorldFrame(1,ii) + Arm.Finger.R*cos(t),FingerWorldFrame(2,ii) + Arm.Finger.R*sin(t),'k');
end
fill(BaseWorldFrame(1,:),BaseWorldFrame(2,:),'b');

end

