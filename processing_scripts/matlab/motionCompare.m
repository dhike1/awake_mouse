clc;clear all;close all;
MR_train=[];
namelist=dir('D:\24\training pupil\motion\motionfile_training\*censor.1D');
for i=1:length(namelist)
    motion=load([namelist(i).folder,'/',namelist(i).name]);
    MR_train(i)=(length(motion)-sum(motion))/length(motion);
    % MR_train(i)=sum(motion);
end

MR_real=[];
namelist=dir('D:\24\training pupil\motion\motionfile_real\*censor.1D');
for i=1:length(namelist)
    motion=load([namelist(i).folder,'/',namelist(i).name]);
    MR_real(i)=(length(motion)-sum(motion))/length(motion);
    % MR_real(i)=sum(motion);
end

figure(Position=[100 100 150 200]);
boxplot([MR_train(4:6)';MR_real'], ...
    [repmat({'train'},length(MR_train(4:6)),1);repmat({'real'},length(MR_real),1)], ...
    'BoxStyle','filled','MedianStyle','target','Symbol','o');
fontsize(gcf,12,"points")
ylabel('Motion ratio')
[h,p]=ttest2(MR_train(1:3),MR_real)
print(gcf,['trainVSreal_motion.jpg'],'-djpeg','-r300');
print(gcf,['trainVSreal_motion.eps'],'-depsc','-r300');
%%
clc;clear all;close all;
MR_train=[];
namelist=dir('D:\24\training pupil\motion\censors_train\*.1D');
for i=1:length(namelist)
    motion=load([namelist(i).folder,'/',namelist(i).name]);
    MR_train(i)=(length(motion)-sum(motion))/length(motion);
    % MR_train(i)=sum(motion);
end

MR_real=[];
namelist=dir('D:\24\training pupil\motion\censors_real\*.1D');
for i=1:length(namelist)
    motion=load([namelist(i).folder,'/',namelist(i).name]);
    MR_real(i)=(length(motion)-sum(motion))/length(motion);
    % MR_real(i)=sum(motion);
end

figure(Position=[100 100 150 200]);
boxplot([MR_train(7:end)';MR_real'], ...
    [repmat({'train'},length(MR_train(7:end)),1);repmat({'real'},length(MR_real),1)], ...
    'BoxStyle','filled','MedianStyle','target','Symbol','o');
fontsize(gcf,12,"points")
ylabel('Censor ratio')
[h,p]=ttest2(MR_train(1:3),MR_real)
print(gcf,['trainVSreal_censor.jpg'],'-djpeg','-r300');
print(gcf,['trainVSreal_censor.eps'],'-depsc','-r300');