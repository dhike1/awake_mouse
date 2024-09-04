% Before detection, have a look at the pupil image and find the pupil/reference area manually.
close all; clear all; clc;
 %load the movie  
date='03182024A2yellow2';
enum='E19'; 
vd=['D:\24\training pupil/',date,'.mp4'];
rotate=50;
v = VideoReader(vd);
f=[];frame=[];
for i=1:10*40
    f = uint8(imrotate(readFrame(v),rotate,'bilinear','crop'));
    frame(:,:,:,i)=f;
end
rp=squeeze(mean(mean(frame(:,:,1,:))));
figure;image(f)

%% detection
close all; clear all; clc;

for en=[19]
%load the movie & have a look 
dummy=40;
enum=['E',num2str(en)]
fr=60;
rotate=60;
date='04122024A2yellow2';
 vd=['D:\24\training pupil/',date,'.mp4'];

v = VideoReader(vd);
f=[];frame=[];
for i=1:8*fr %chose the frame. the 8 second and 30 is the sample rate of the camera
    f = uint8(imrotate(readFrame(v),rotate,'bilinear','crop'));
    frame(:,:,:,i)=f;
end
rp=squeeze(mean(mean(frame(:,:,1,:))));

figure;image(f)
[xpupil, ypupil] = ginput(4);  % Manually click two points
 %%
xpupil=round(xpupil);
ypupil=round(ypupil);
figure;image(f(ypupil(1):ypupil(2),xpupil(1):xpupil(2),:))

%%
ctst=[0.0001 1];%ctst=[0.05 0.2]; contrast threshold setting of pupil area
ctstr=[0.0001 1]; %contrast threshold setting of reference area


v = VideoReader(vd);
i=1;frame=[];rp=[];r=[];ap=[];a=[];gp=[];g=[];b=[];bp=[];
while hasFrame(v) & i<=fr*60*10 %8 mins  
    f = uint8(imrotate(readFrame(v),rotate,'bilinear','crop'));
    frame(:,:,:,i)=f(ypupil(1):ypupil(2),xpupil(1):xpupil(2),:); 
    tf=f(ypupil(1):ypupil(2),xpupil(1):xpupil(2),:); 
    ga=rgb2gray(tf);
%seperate the channels 
%pupil
    ap(i)=mean(mean(imadjust(ga,ctst)));
    rp(i)=mean(mean(imadjust(tf(:,:,1),ctst)));
    gp(i)=mean(mean(imadjust(tf(:,:,2),ctst)));
    bp(i)=mean(mean(imadjust(tf(:,:,3),ctst)));

%reference    
    a(i)=mean(mean(imadjust(rgb2gray(f(ypupil(3):ypupil(4),xpupil(3):xpupil(4),:)),ctstr)));
    r(i)=mean(mean(imadjust(f(ypupil(3):ypupil(4),xpupil(3):xpupil(4),1),ctstr)));
    g(i)=mean(mean(imadjust(f(ypupil(3):ypupil(4),xpupil(3):xpupil(4),2),ctstr)));
    b(i)=mean(mean(imadjust(f(ypupil(3):ypupil(4),xpupil(3):xpupil(4),3),ctstr)));

    i=i+1;
end

figure;subplot(4,1,1);imshow(imadjust(uint8(frame(:,:,1,15*fr)),ctst));subplot(4,1,2);image(uint8(frame(:,:,:,15*fr)))
subplot(4,1,3);imshow(imadjust(f(ypupil(3):ypupil(4),xpupil(3):xpupil(4),1),ctstr));subplot(4,1,4);image(uint8(f(ypupil(3):ypupil(4),xpupil(3):xpupil(4),:)));

%%
st=1;
x=1:length(r);
x=x/fr;
figure;plot(x(st:end),mapminmax(ap(st:end)),x(st:end),mapminmax(a(st:end)));


% % %%
figure;
subplot(4,1,1);plot(x(st:end),zscore(r(st:end)),x(st:end),zscore(rp(st:end)));
subplot(4,1,2);plot(x(st:end),zscore(g(st:end)),x(st:end),zscore(gp(st:end)));
subplot(4,1,3);plot(x(st:end),zscore(b(st:end)),x(st:end),zscore(bp(st:end)));
subplot(4,1,4);plot(x(st:end),zscore(a(st:end)),x(st:end),zscore(ap(st:end)));

%%
starttime=0;%(dummy-3)*30; %find the stimulation start time

span=1;hp=1;
[~,d]=lowpass(r,span,fr,ImpulseResponse="iir",Steepness=0.95);
% first step normalization
[r1,rp1]=ampadj(r,rp,st,d);
[g1,gp1]=ampadj(g,gp,st,d);
[b1,bp1]=ampadj(b,bp,st,d);
[a1,ap1]=ampadj(a,ap,st,d);

% chose the second step normalization methods based on detection results
bt=r(st:end)';
bpt=rp(st:end)';
% bt=mapminmax(b1(st:end),0,1);
% bpt=mapminmax(bp1(st:end),0,1);
% bt=zscore(r1(st:end));
% bpt=zscore(rp1(st:end));
% bt=bt-mean(bt);
% bpt=bpt-mean(bpt);
t=1:length(bt);t=t/fr;
figure;plot(t,bt,t,bpt);

% lowpass/ smooth for denoise
pb=smoothdata(bt,10)-smoothdata(bpt,10);
% pb=smooth(bt-bpt,32,'sgolay');

%[~,dpb]=lowpass(pb,1,30,ImpulseResponse="iir");
%pb=filtfilt(dpb,pb);

figure;plot(t,smoothdata(bt,10),t,smoothdata(bpt,10),t,pb);

% tP1=ones(starttime+411*30+st-1,1)*mean(pb);
% tP1(st:st+length(pb)-1)=pb;

% pb=filloutliers(pb,"clip","median");
P1=pb;
P3=P1(starttime+1:floor(length(P1)/(30*fr))*30*fr);
% P3=P1(starttime+1:7*60*fr);
Ps=P3;
t=1:length(P1);t=t/fr;
figure();plot(t(1:length(Ps)),Ps);
save([date,'.mat'],'Ps');
end
%%
fs=fr;
pupil_normalized=zscore(Ps);
figure;
time=1:length(pupil_normalized);
time=time/fs;
ax(1)=subplot(2,1,1);
plot(time,pupil_normalized,LineWidth=1.5)
ylabel({'Normalized';'Pupil (a.u.)'})
xlim('tight')

ax(2)=subplot(2,1,2);
[p,f,t]=pspectrum(pupil_normalized,fs,"spectrogram",FrequencyLimits=[0.05,1.5],FrequencyResolution=0.1,Reassign=false,...
    OverlapPercent=95,Leakage=0.85);
sh = surf(t,f,10*log10(p));
view(0, 90)
axis tight
yticks([0.1,1])
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
ylabel('Freq (Hz)')
xlabel('Time (s)')
linkaxes(ax,'x');
cb=colorbar(ax(2));
   

%%
function [x1] = no_ev(x,p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x1=x;
x=sort(x);
n=round(p*length(x));
minx=x(n+1);
maxx=x(length(x)-n);
x1(x1>maxx)=maxx;x1(x1<minx)=minx;

end

%%

function [r1,rp1]=ampadj(r,rp,st,d)

r1 = filtfilt(d,r);rp1 = filtfilt(d,rp);
r1=r;rp1=rp;
end