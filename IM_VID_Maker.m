%%This makes a nice animation of grasps, after "Main" has been run

myVideo = VideoWriter('myVideoFile'); %open video file
myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
open(myVideo)
%% Plot in a loop and grab frames
for ii=1:100
    Finger_Places = MyConfigs(ii).Configuration;
    splt = scatter(Finger_Places(:,1),Finger_Places(:,2),'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',[1 0 0],...
        'LineWidth',1.5);
    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
    delete(splt)
end
close(myVideo)


myVideo = VideoWriter('myVideoFile2'); %open video file
myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
open(myVideo)
Finger_Places = MyConfigs(1).Configuration;
for ii=1:117

splt2 = plot([Grasp_Center(ii,1),Finger_Places(1,1)],[Grasp_Center(ii,2),Finger_Places(1,2)],'-k','LineWidth',3);
splt3 = plot([Grasp_Center(ii,1),Finger_Places(2,1)],[Grasp_Center(ii,2),Finger_Places(2,2)],'-k','LineWidth',3);
splt4 = plot([Grasp_Center(ii,1),Finger_Places(3,1)],[Grasp_Center(ii,2),Finger_Places(3,2)],'-k','LineWidth',3);
splt = scatter(Grasp_Center(ii,1),Grasp_Center(ii,2),'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',[0 0 1],...
        'LineWidth',1.5);
    
pause(0.01)
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
delete(splt);
delete(splt2); delete(splt3); delete(splt4);
end

