figure(1)
load('handCameraParams.mat','handCameraParams');

img = takeSnapshot(cam);
rgbimg = permute(img,[2 1 3]);
img = undistortImage(rgbimg,handCameraParams);
img = permute(img,[2 1 3]);
imshow(img);
hold on

Hand_Center = object_type.Possible_Hand_Configs(1).Center;
Hand_Center_Pixels = Hand_Center;
R = rotz(deg2rad(-object.Orientation));
R = R(1:2,1:2);
Rotated_Hand_Center_Pixels = Hand_Center_Pixels*R;
Rotated_Hand_Center_Pixels = [Rotated_Hand_Center_Pixels(1),-Rotated_Hand_Center_Pixels(2)];
Hand_Center_Cam_Frame = Rotated_Hand_Center_Pixels + object.Centroid;
hold on
CTRPLT = plot(object.Centroid(1),object.Centroid(2),'xr');
HCPLT = plot(Hand_Center_Cam_Frame(1),Hand_Center_Cam_Frame(2),'xg');

poly = object_type.Polygon;
poly_pix = poly;
rotated_poly = poly_pix*R;
rotated_poly = [rotated_poly(:,1),-rotated_poly(:,2)];
poly_cam_frame = rotated_poly + object.Centroid;

polyplot = plot(poly_cam_frame(:,1),poly_cam_frame(:,2),'-y');
ctr = object.Centroid;
theta = object.Orientation;
xMajor = ctr(1)  +  [ -1 +1 ] * object.MajorAxisLength*cosd(-theta)/2;
yMajor = ctr(2)  +  [ -1 +1 ] * object.MajorAxisLength*sind(-theta)/2;
axl = line(xMajor,yMajor);

UFP = object_type.Untilted_Finger_Placements;
TFP = UFP*R;
TFP = [TFP(:,1),-TFP(:,2)];
FP = TFP + object.Centroid;
fpp1 = plot(FP(1,1),FP(1,2),'om','MarkerFaceColor','g');
fpp2 = plot(FP(2:end,1),FP(2:end,2),'om','MarkerFaceColor',[1 1 1]);