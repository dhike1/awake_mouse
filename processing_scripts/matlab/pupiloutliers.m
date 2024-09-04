clc;clear all;close all
fr=60;
for name={'A2yellow1', 'A2yellow2', 'A4black', 'A4white', 'M1black', 'M1red', 'M1white', 'M1yellow'}
namelist=dir(['0*',name{:},'.mat']);
Out=[];Psd={};f={};
for i=1:length(namelist)
    load(namelist(i).name);
    t=1:length(Ps);
    t=t/fr;
    Pp=filloutliers(Ps,"clip","movmedian",fr*5);
    
    Out(i)=length(find(Pp~=Ps));
    Pp=detrend(Pp,2);
    Pf=smoothdata(Pp,1,"movmean",fr*2);
    [Psd{i},f{i}] = pmtm(zscore(detrend(Pf,2)),2,1024*8,fr);
    figure;plot(t,Ps,t,Pp,t,Pf);
    close all
end
save(name{:},"Out", "Psd","f")
end
%%
% 
realdate=[3,5,7,9,10,11,13,15,17,25,27];
realdate=[1,1,2,3,4,5,6,7,8,1,2];
lb={};
for i=1:11
    lb{i}=['day',num2str(realdate(i))];
end
figure(Position=[100 100 300 250]);
Outall=[];i=0;
for name={'A2yellow1', 'A2yellow2','A4black', 'A4white', 'M1black', 'M1red', 'M1white', 'M1yellow'}
    i=i+1;
    load([name{:},'.mat']);
    load([name{:},'date.mat']);
    eval(['plot(',name{:},'date,','Out)']);
    hold on
    eval(['Outall(i,',name{:},'date',')=Out;']);
end
Outall(Outall==0)=nan;
Outall(:,2)=[];
figure(Position=[100 100 400 250]);
boxplot(Outall,'BoxStyle','filled','MedianStyle','target','Symbol','o','Labels',lb)
xlabel('Training date')
ylabel({'','Eye movements'})
fontsize(gca,12,'point')
print(gcf,['training.jpg'],'-djpeg','-r300');
print(gcf,['traing.eps'],'-depsc','-r300');
%%

j=0;Psdall02=[];Psdall05=[];Psdall0205=[];Psdall051=[];Psdall1m=[];
for name={'A2yellow1', 'A2yellow2','A4black', 'A4white', 'M1black', 'M1red', 'M1white', 'M1yellow'}
    load([name{:},'.mat']);
    j=1+j;
    for i=1:length(Psd)
        tf=f{i};
        tPsd=Psd{i}/sum(Psd{i});
        Psdall02(j,i)=sum(tPsd(tf<0.02));
        Psdall05(j,i)=sum(tPsd(tf<0.05));
        Psdall0205(j,i)=sum(tPsd(tf>0.02&tf<0.05));
        Psdall051(j,i)=sum(tPsd(tf>0.05&tf<0.1));
        Psdall1m(j,i)=sum(tPsd(tf>0.1));
    end
end
Psdall02(Psdall02==0)=nan;
Psdall0205(Psdall0205==0)=nan;
Psdall051(Psdall051==0)=nan;
Psdall1m(Psdall1m==0)=nan;
figure;
subplot(4,1,1)
boxplot(Psdall02)
subplot(4,1,2)
boxplot(Psdall0205)
subplot(4,1,3)
boxplot(Psdall051)
subplot(4,1,4)
boxplot(Psdall1m)