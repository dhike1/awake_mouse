clc;clear all;close all
fr=60;
for name={'A2yellow1', 'A2yellow2', 'A4black', 'A4white', 'M1black', 'M1red', 'M1white', 'M1yellow'}
namelist=dir(['0*',name{:},'*.mat']);
Out=[];Psd={};f={};
for i=1:length(namelist)
    load(namelist(i).name);
    t=1:length(Ps);
    t=t/fr;
    Pp=filloutliers(Ps,"clip","movmedian",fr*5);

    Out(i)=length(find(Pp~=Ps));
    Pp=detrend(Pp,2);
    % Pf=smoothdata(Pp,1,"movmean",fr*2);
    Pf=Pp-mean(Pp);
    [Psd{i},f{i}] = pmtm(zscore(detrend(Pf,2)),2,1024*8,fr);
    figure;plot(t,Ps,t,Pp,t,Pf);
    close all
end
save(name{:},"Out", "Psd","f")
end

%%

j=0;Psdall02=[];Psdall05=[];Psdall0205=[];Psdall051=[];Psdall1m=[];PSDall=[];
for name={'A2yellow1', 'A2yellow2','A4black', 'A4white', 'M1black', 'M1red', 'M1white', 'M1yellow'}
    load([name{:},'.mat']);
    load([name{:},'date.mat']);
    % eval(['plot(',name{:},'date,','Out)']);
    eval(['date=',name{:},'date;']);
    j=1+j;
    for i=1:length(Psd)
        tf=f{i};
        tPsd=Psd{i}/sum(Psd{i});
        eval(['PSDall(j,',name{:},'date(i)',',:)=tPsd;']);
        
        Psdall02(j,date(i))=sum(tPsd(tf<0.02));
        Psdall05(j,date(i))=sum(tPsd(tf<0.05));
        Psdall0205(j,date(i))=sum(tPsd(tf>0.02&tf<0.05));
        Psdall051(j,date(i))=sum(tPsd(tf>0.05&tf<0.1));
        Psdall1m(j,date(i))=sum(tPsd(tf<0.1));

    end
end
PSDall(PSDall==0)=nan;
PSDmean=[];lg={};
realdate=[3,5,7,9,10,11,13,15,17,25,27];
realdate=[1,1,2,3,4,5,6,7,8,1,2];
for i=1:11
    lg{i}=['day',num2str(realdate(i))];
end
for i=1:12
    PSDmean(i,:)=mean(squeeze(PSDall(:,i,:)),1,"omitnan");
end
PSDmean(2,:)=[];
figure(Position=[100 100 450 350]);
mycolor=colormap(gray(12));
mycolor=flip(mycolor,1);
mycolor=[mycolor(3:11,:);0.83 0.14 0.14;0.25 0.80 0.54];
colororder(mycolor)
plot(tf(tf<0.1),PSDmean(:,tf<0.1)',LineWidth=2);
legend(lg,'box','off')
xlabel('Frequency (Hz)')
ylabel('Normalized PSD')
fontsize(gca,14,"points")
print(gcf,['trainingPSD.jpg'],'-djpeg','-r300');
print(gcf,['trainingPSD.eps'],'-depsc','-r300');

figure(Position=[100 100 300 200]);
% p=waterfall(tf(tf<0.1),realdate,PSDmean(:,tf<0.1));

for i=1:5
    PSDmean_m(:,i)=mean(PSDmean(:,tf<0.02*i&tf>0.02*(i-1)),2);
end
p=waterfall(0.02:0.02:0.1,realdate,PSDmean_m);

set(p,"LineWidth",2)
set(p,'FaceAlpha',0.5)
% set(p,'EdgeColor','k')
xticks(0.02:0.02:0.1)
xlabel('Frequency (Hz)')
zlabel('Normalized PSD')
ylabel('Training date')
fontsize(gca,12,"points")

Psdall02(Psdall02==0)=nan;
Psdall0205(Psdall0205==0)=nan;
Psdall051(Psdall051==0)=nan;
Psdall1m(Psdall1m==0)=nan;

Psdall02(:,2)=[];
Psdall0205(:,2)=[];
Psdall051(:,2)=[];
Psdall1m(:,2)=[];
% 
% figure(Position=[100 100 700 800]);
% subplot(4,1,1)
% boxplot(Psdall02,'BoxStyle','filled','MedianStyle','target','Symbol','o',Labels=lg)
% ylabel('<0.02Hz')
% subplot(4,1,2)
% boxplot(Psdall0205,'BoxStyle','filled','MedianStyle','target','Symbol','o',Labels=lg)
% ylabel('0.02-0.05Hz')
% subplot(4,1,3)
% boxplot(Psdall051,'BoxStyle','filled','MedianStyle','target','Symbol','o',Labels=lg)
% ylabel('0.05-0.1Hz')
% subplot(4,1,4)
% boxplot(Psdall1m,'BoxStyle','filled','MedianStyle','target','Symbol','o',Labels=lg)
% ylabel('>0.1Hz')
% xlabel('training date')
% print(gcf,['trainingPSDbox.jpg'],'-djpeg','-r300');

figure(Position=[100 100 400 250]);
% subplot(2,1,1)
boxplot(Psdall02,'BoxStyle','filled','MedianStyle','target','Symbol','o',Labels=lg)
ylabel({'Normalized PSD','<0.02Hz'})

% subplot(2,1,2)
% boxplot(Psdall1m,'BoxStyle','filled','MedianStyle','target','Symbol','o',Labels=lg)
% ylabel({'Normalized PSD','<0.1Hz'})
% xlabel('training date')
fontsize(gcf,12,"points")
print(gcf,['trainingPSDbox.jpg'],'-djpeg','-r300');
print(gcf,['trainingPSDbox.eps'],'-depsc','-r300');
%%
