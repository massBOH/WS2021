clear all;
createSerialLink_zeroModify;

% Das Haus vom Nikolaus
t0 = [361 25 277];
t1 = [361 -25 277];
t2 = [361 -25 327];
t3 = [361 25 277];
t4 = [361 25 327];
t5 = [361 0 362.4];
t6 = [361 -25 327];
t7 = [361 25 327];
t8 = [361 -25 277];


a = 0 : 0.05 : 1;
a = transpose(a);


x1 = t0 + a*(t1-t0);
x2 = t1 + a*(t2-t1);
x3 = t2 + a*(t3-t2);
x4 = t3 + a*(t4-t3);
x5 = t4 + a*(t5-t4);
x6 = t5 + a*(t6-t5);
x7 = t6 + a*(t7-t6);
x8 = t7 + a*(t8-t7);

pause_ = 0.05;

for i = 1:20
Arbeitsraum([x1(i,1) x1(i,2) x1(i,3) 0 0]);
target = Youbot_trans_invers([x1(i,1) x1(i,2) x1(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x2(i,1) x2(i,2) x2(i,3) 0 0]);
target = Youbot_trans_invers([x2(i,1) x2(i,2) x2(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x3(i,1) x3(i,2) x3(i,3) 0 0]);
target = Youbot_trans_invers([x3(i,1) x3(i,2) x3(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x4(i,1) x4(i,2) x4(i,3) 0 0]);
target = Youbot_trans_invers([x4(i,1) x4(i,2) x4(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x5(i,1) x5(i,2) x5(i,3) 0 0]);
target = Youbot_trans_invers([x5(i,1) x5(i,2) x5(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x6(i,1) x6(i,2) x6(i,3) 0 0]);
target = Youbot_trans_invers([x6(i,1) x6(i,2) x6(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x7(i,1) x7(i,2) x7(i,3) 0 0]);
target = Youbot_trans_invers([x7(i,1) x7(i,2) x7(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end
for i = 1:20
Arbeitsraum([x8(i,1) x8(i,2) x8(i,3) 0 0]);
target = Youbot_trans_invers([x8(i,1) x8(i,2) x8(i,3) 0 0]);
YouBot.plot(target);
pause(pause_);
end