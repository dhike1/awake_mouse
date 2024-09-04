clc;
figure
profile_values = xlsread('awake mouse snr line profiles.xlsx', 'avg-stdev-stderror');
x = profile_values(:,1);
x = x.';

%14t figure 8
m5 = profile_values(:,18);
stdev5 = profile_values(:,19);
sterror5 = profile_values(:,20);
lsd5 = (m5-stdev5);
lsd5 = lsd5.';
usd5 = (m5+stdev5);
usd5 = usd5.';
lse5 = (m5-sterror5);
lse5 = lse5.';
use5 = (m5+sterror5);
use5 = use5.';
shade5 = patch([x fliplr(x)], [use5 fliplr(lse5)], [0.0, 1, 0.0]);
hold on;
plot(x, m5);
hold on;

%9.4 figure 8
m3 = profile_values(:,10);
stdev3 = profile_values(:,11);
sterror3 = profile_values(:,12);
lsd3 = (m3-stdev3);
lsd3 = lsd3.';
usd3 = (m3+stdev3);
usd3 = usd3.';
lse3 = (m3-sterror3);
lse3 = lse3.';
use3 = (m3+sterror3);
use3 = use3.';
shade3 = patch([x fliplr(x)], [use3 fliplr(lse3)], [0, 0, 1]);
hold on;
plot(x, m3);
hold on;

%14t single loop
m4 = profile_values(:,14);
stdev4 = profile_values(:,15);
sterror4 = profile_values(:,16);
lsd4 = (m4-stdev4);
lsd4 = lsd4.';
usd4 = (m4+stdev4);
usd4 = usd4.';
lse4 = (m4-sterror4);
lse4 = lse4.';
use4 = (m4+sterror4);
use4 = use4.';
shade4 = patch([x fliplr(x)], [use4 fliplr(lse4)], [1, 1, 0.0]);
hold on;
plot(x, m4);
hold on;

%9.4 single loop
m2 = profile_values(:,6);
stdev2 = profile_values(:,7);
sterror2 = profile_values(:,8);
lsd2 = (m2-stdev2);
lsd2 = lsd2.';
usd2 = (m2+stdev2);
usd2 = usd2.';
lse2 = (m2-sterror2);
lse2 = lse2.';
use2 = (m2+sterror2);
use2 = use2.';
shade2 = patch([x fliplr(x)], [use2 fliplr(lse2)], [0.6, 0.7, 0.8]);
hold on;
plot(x, m2);
hold on;

% 4array
m1 = profile_values(:,2);
stdev1 = profile_values(:,3);
sterror1 = profile_values(:,4);
lsd1 = (m1-stdev1);
lsd1 = lsd1.';
usd1 = (m1+stdev1);
usd1 = usd1.';
lse1 = (m1-sterror1);
lse1 = lse1.';
use1 = (m1+sterror1);
use1 = use1.';
shade1 = patch([x fliplr(x)], [use1 fliplr(lse1)], [0.85, 1, 0.85]);
hold on;
plot(x, m1);
hold on;

legend('14 figure 8', '14 figure 8', '9.4 figure 8', '9.4 figure 8', '14t single loop', '14t single loop', '9.4 single loop', '9.4 single loop', '4 array', '4 array');



