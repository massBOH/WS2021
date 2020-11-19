% RoboterSysteme WS2020/21
% Haus vom Nikolaus in y/z
% 17.11.2020 Gerald Hebinck

clear all;
clc;
createSerialLink_zeroModify()

%Targets
center = [ 361 0 302];
p0 = [0 -25 -25] + center;
p1 = [0  25 -25] + center;
p2 = [0  25  25] + center;
p3 = [0 -25  25] + center;
p4 = [0   0  25+50/sqrt(2)] + center;

%Route
points = [p0; p1; p2; p0; p3; p4; p2; p3; p1; p0 ];

%Steps
a = 0 : 0.1: 1;
a = transpose(a);

%Ways
way1 = a * (p0 - center) + center;
way2 = a * (p1 - p0) + p0;
way3 = a * (p2 - p1) + p1;
way4 = a * (p0 - p2) + p2;
way5 = a * (p3 - p0) + p0;
way6 = a * (p4 - p3) + p3;
way7 = a * (p2 - p4) + p4;
way8 = a * (p3 - p2) + p2;
way9 = a * (p1 - p3) + p3;

%Pause between Steps
pause_ = 0.01;

%InverseKinematics and execution in plot
for i = 1:11
    target = inverse_youbot([way1(i,1) way1(i,2) way1(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way2(i,1) way2(i,2) way2(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way3(i,1) way3(i,2) way3(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way4(i,1) way4(i,2) way4(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way5(i,1) way5(i,2) way5(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way6(i,1) way6(i,2) way6(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way7(i,1) way7(i,2) way7(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way8(i,1) way8(i,2) way8(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = inverse_youbot([way9(i,1) way9(i,2) way9(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end


