clear all
close all
%% Duration histograms
load('Fingers_2.mat');
D2 = Evaluated_Duration_vec;
load('Fingers_3.mat');
D3 = Evaluated_Duration_vec;
load('Fingers_4.mat');
D4 = Evaluated_Duration_vec;
load('Fingers_5.mat');
D5 = Evaluated_Duration_vec;

%map = brewermap(5,'YlOrRd'); map(1,:) = [];
map = brewermap(4,'BrBG');
%map = brewermap(4,'PuOr');
%load('colorblind_colormap.mat');
%map = colorblind(5:end,:)
max_num = 40;
figure(1)
histogram(D2,0:1:max_num,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
hold on
histogram(D3,0:1:max_num,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
histogram(D4,0:1:max_num,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
histogram(D5,0:1:max_num,'facecolor',map(4,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
box off

histogram(D2,0:1:max_num,'edgecolor',map(1,:),'linewidth',2.5,'Normalization','probability','DisplayStyle','stairs')
histogram(D3,0:1:max_num,'edgecolor',map(2,:),'linewidth',2,'Normalization','probability','DisplayStyle','stairs')
histogram(D4,0:1:max_num,'edgecolor',map(3,:),'linewidth',1.5,'Normalization','probability','DisplayStyle','stairs')
histogram(D5,0:1:max_num,'edgecolor',map(4,:),'linewidth',1,'Normalization','probability','DisplayStyle','stairs')

axis([0,max_num,0,0.3])
%legalpha('Three Fingers','Four Fingers','Five Fingers','location','northeast')
legend('Two Fingers','Three Fingers','Four Fingers','Five Fingers','location','northeast')
legend boxoff

xlabel('Duration of restructure (s)');
ylabel('Probability')



%% CDF
figure(2)
map = brewermap(5,'YlOrRd'); map(1,:) = [];
map = brewermap(4,'BrBG');
map = brewermap(4,'RdYlBu');

%histogram(D3,0:1:20,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none','Normalization','cdf')
hold on
%histogram(D4,0:1:20,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none','Normalization','cdf')
%histogram(D5,0:1:20,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none','Normalization','cdf')
%box off
box on
%histogram(D3,1000,'edgecolor',map(1,:),'linewidth',2,'Normalization','cdf','DisplayStyle','stairs')
%histogram(D4,1000,'edgecolor',map(2,:),'linewidth',1.5,'Normalization','cdf','DisplayStyle','stairs')
%histogram(D5,1000,'edgecolor',map(3,:),'linewidth',1,'Normalization','cdf','DisplayStyle','stairs')

hD(1) = cdfplot(D2);
hD(2) = cdfplot(D3);
hD(3) = cdfplot(D4);
hD(4) = cdfplot(D5);

set(hD(1),'linewidth',2,'color',map(1,:))
set(hD(2),'linewidth',2,'color',map(2,:))
set(hD(3),'linewidth',2,'color',map(3,:))
set(hD(4),'linewidth',2,'color',map(4,:))

axis([0,47,0,1])
legend('Two Fingers','Three Fingers','Four Fingers','Five Fingers','location','southeast')
%legend boxoff

xlabel('Duration of restructure (s)');
ylabel('Probability')
title('')

t1 = text(4,0.4,'Two Fingers');
set(t1,'Rotation',82)
set(t1,'FontSize',12)

t2 = text(10.5,0.4,'Three Fingers');
set(t2,'Rotation',79)
set(t2,'FontSize',12)

t3 = text(15.7,0.4,'Four Fingers');
set(t3,'Rotation',76)
set(t3,'FontSize',12)

t4 = text(19.4,0.4,'Five Fingers');
set(t4,'Rotation',73)
set(t4,'FontSize',12)

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/CDF1.png'];
print(gcf,filename,'-dpng','-r300');

%% Experiment CDF
figure(3)
hold on
box on

map = brewermap(2,'Set1'); 

load('Real_Fingers_3.mat');
D3 = Evaluated_Duration_vec;
R3 = Real_Duration_vec;
load('Real_Fingers_4.mat');
D4 = Evaluated_Duration_vec;
R4 = Real_Duration_vec;

hD(1) = cdfplot(R3);
hD(2) = cdfplot(D3);
hD(3) = cdfplot(R4);
hD(4) = cdfplot(D4);

set(hD(1),'linewidth',2,'color',map(1,:))
set(hD(2),'linewidth',2,'color',map(1,:),'linestyle',':')
set(hD(3),'linewidth',2,'color',map(2,:))
set(hD(4),'linewidth',2,'color',map(2,:),'linestyle',':')

axis([0,30,0,1])
legend('Three Fingers, experiment','Three Fingers, simulation','Four Fingers, experiment','Four Fingers, simulation','location','northwest')
%legend boxoff

xlabel('Duration of restructure (s)');
ylabel('Probability')
title('')

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/CDF2.png'];
print(gcf,filename,'-dpng','-r300');

%% Alt experiment
figure(4)
map = brewermap(4,'Paired'); 
plot(sort(D3),'o','color',map(1,:)); hold on; plot(sort(R3),'x','color',map(2,:));
plot(sort(D4),'d','color',map(3,:)); plot(sort(R4),'^','color',map(4,:));
axis([0,50,5,27]);
box off
grid on
xlabel('Restructure scenario #, sorted');
ylabel('Duration of restructure (s)');

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/Sorted_exp.png'];
legend('Three Fingers, experiment','Three Fingers, simulation','Four Fingers, experiment','Four Fingers, simulation','location','southeast')
print(gcf,filename,'-dpng','-r300');
