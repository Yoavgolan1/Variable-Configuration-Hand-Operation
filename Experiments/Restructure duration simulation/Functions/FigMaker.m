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

map = brewermap(4,'Set1'); 

figure
histogram(D2,0:1:20,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
hold on
histogram(D3,0:1:20,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
histogram(D4,0:1:20,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
histogram(D5,0:1:20,'facecolor',map(4,:),'facealpha',.5,'edgecolor','none','Normalization','probability')
box off

histogram(D2,0:1:20,'edgecolor',map(1,:),'linewidth',2.5,'Normalization','probability','DisplayStyle','stairs')
histogram(D3,0:1:20,'edgecolor',map(2,:),'linewidth',2,'Normalization','probability','DisplayStyle','stairs')
histogram(D4,0:1:20,'edgecolor',map(3,:),'linewidth',1.5,'Normalization','probability','DisplayStyle','stairs')
histogram(D5,0:1:20,'edgecolor',map(4,:),'linewidth',1,'Normalization','probability','DisplayStyle','stairs')

axis([0,20,0,0.55])
%legalpha('Three Fingers','Four Fingers','Five Fingers','location','northeast')
legend('Two Fingers','Three Fingers','Four Fingers','Five Fingers','location','northeast')
legend boxoff

xlabel('Duration of restructure (s)');
ylabel('Probability')

%% CDF
figure
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

axis([0,22,0,1])
legend('Two Fingers','Three Fingers','Four Fingers','Five Fingers','location','southeast')
%legend boxoff

xlabel('Duration of restructure (s)');
ylabel('Probability')
title('')

p = mfilename('fullpath');
p(end-length(mfilename):end) = [];
filename = [p,'/CDF1.png'];
print(gcf,filename,'-dpng','-r300');