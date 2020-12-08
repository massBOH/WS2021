% RoboterSysteme WS2020/21
% Haus vom Nikolaus in y/z
% 17.11.2020 Gerald Hebinck

clear all;
clc;
createSerialLink_zeroModify()

%Targets
center = [ 361 0 302];
p0 = [0 -50 -50] + center;
p1 = [0  50 -50] + center;
p2 = [0  50  50] + center;
p3 = [0 -50  50] + center;
p4 = [0   0  50+100/sqrt(2)] + center;

%Route
points = [p0; p1; p2; p0; p3; p4; p2; p3; p1; p0 ];

%Steps
a = 0 : 0.5: 1;
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

GelenkPos(runROS,[0, 0, 0, 0, 0]);

%Pause between Steps
pause_ = 0;

%InverseKinematics and execution in plot
%target = inverse_youbot([361 0 302 0 0])
%target2= inverse_youbot([361 0 402 0 0])
%target3= inverse_youbot([0 361 402 0 0])
%GelenkPos(runROS,target); 

for i = 1:2
    target = inverse_youbot_real([way1(i,1) way1(i,2) way1(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way2(i,1) way2(i,2) way2(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way3(i,1) way3(i,2) way3(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way4(i,1) way4(i,2) way4(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way5(i,1) way5(i,2) way5(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way6(i,1) way6(i,2) way6(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way7(i,1) way7(i,2) way7(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way8(i,1) way8(i,2) way8(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end
for i = 1:2
    target = inverse_youbot_real([way9(i,1) way9(i,2) way9(i,3) 0 0]);
    GelenkPos(runROS,target);
    pause(pause_);
end


