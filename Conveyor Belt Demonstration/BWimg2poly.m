function [Polygon, normpolyfactor,Centroid] = BWimg2poly(snap, polytol,one_mm_is_X_pixels,showresults)
%BWIMG2POLY accepts an image, finds an object in it, and converts it to a polygon.
%   img2poly accepts an black and white image "snap", a fit tolerance for polygonal
%   appoximation "polytol", a ration between pixels and cm in the real
%   world "one_mm_is_X_pixels", and an option to show the results
%   "showresults". The lower the value of polytol, the better the
%   approximation, but the longer the runtime and noise of the polygon.
global Finger_Radius  Rectangle_Flag
if nargin < 4
    showresults = false;
end
if nargin < 3
    one_mm_is_X_pixels = 12.549;
end
if nargin < 2
    polytol = 0.02;
end
Rectangle_Flag = false;

snap = flipud(snap);

%Transfer to configuration space by eroding the image (dilating the object)
SE = strel('disk', floor(one_mm_is_X_pixels*Finger_Radius));
imgBW3 = imdilate(snap,SE);

% Find the object boundaries
xyBlob = bwboundaries(imgBW3);
xyBlob = xyBlob{1};

Centroid = [mean(xyBlob(:,2)),length(snap(:,1))-mean(xyBlob(:,1))];
Centroid = Centroid/one_mm_is_X_pixels; %Convert to mm
% Convert boundaries to polygon
[Polygon, ~] = Blob2Poly(xyBlob,polytol);
% Remove duplicate end
Polygon(end,:) = [];

normpolyfactor = 1/mean(mean(Polygon)); % move analysis to X-Y's ranging from 0~2 (normalization) (seems to run faster idk...)
Polygon = normpolyfactor*Polygon;
fprintf('____________________________________________');
fprintf('\n[#] Converted snapshot to polygon');

if showresults
    
    % show original image
    subplot(1,3,1)
    imshow(snap);
    
    % show initial acquired borders
    subplot(1,3,2)
    imshow(imgBW3);
    hold on;
    plot(xyBlob(:,2),xyBlob(:,1))
    
    % show polygon approx.
    subplot(1,3,3)
    imshow(snap)
    hold on
    plot([Polygon(:,1);Polygon(1,1)]/ normpolyfactor,[Polygon(:,2);Polygon(1,2)]/ normpolyfactor,'r','LineWidth',2)
    hold off
    %pause
    %close all
    
    
    
end


answer = questdlg('Is the object rectangular?', ...
    'Object query', 'Yes',	'No', 'No');
if isequal(answer,'Yes')
    Rectangle_Flag = true;
    rect_disp = figure;
    imshow(imgBW3);
    hold on;
    plot(xyBlob(:,2),xyBlob(:,1))
    
    f = msgbox('Please click on the four corners counterclockwise','createmode','modal');
    
    [x1,y1]= ginput(1);
    plot(x1,y1,'or','MarkerFaceColor','r')
    [x2,y2]= ginput(1);
    plot(x2,y2,'or','MarkerFaceColor','r')
    [x3,y3]= ginput(1);
    plot(x3,y3,'or','MarkerFaceColor','r')
    [x4,y4]= ginput(1);
    plot(x4,y4,'or','MarkerFaceColor','r')
    
    
    %d1_x = x3 - x1; d1_y = y3 - y1; %diagonal from p1 to p3
    %c_x = (x1 + x2) / 2; c_y = (y1 + y2) / 2; %rectangle center
    %d2_x = d1_y; d2_y = -d1_x;
    
    e1_x = x2 - x1; e1_y = y2 - y1; E1 = [e1_x, e1_y];
    e2_x = x3 - x2; e2_y = y3 - y2; E2 = [e2_x, e2_y];
    e3_x = x4 - x3; e3_y = y4 - y3; E3 = [e3_x, e3_y];
    e4_x = x1 - x4; e4_y = y1 - y4; E4 = [e4_x, e4_y];
    
    edge1_length = mean([sqrt(sum(E1.^2)), sqrt(sum(E3.^2))]);
    edge2_length =  mean([sqrt(sum(E2.^2)), sqrt(sum(E4.^2))]);
    
    edge2_from_normal = [E1(2),-E1(1)]; %normal to the firse edge;
    
    p1 = [x1, y1];
    p2 = p1 + (E1/norm(E1))*edge1_length;
    p3 = p2 + (edge2_from_normal/norm(edge2_from_normal))*edge2_length;
    p4 = p3 - (E1/norm(E1))*edge1_length;
    P = [p1;p2;p3;p4;p1];
    
    Polygon = P;
    normpolyfactor = 1/mean(mean(Polygon)); % move analysis to X-Y's ranging from 0~2 (normalization) (seems to run faster idk...)
    Polygon = normpolyfactor*Polygon;
    
    plot(P(:,1),P(:,2),'-','color',[0 0.7 0],'linewidth',2)
    
    pause(1.5);
    close(rect_disp)
end
