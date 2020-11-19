% RoboterSysteme WS2020/21
% Kreisfahrt in x/z
% 17.11.2020 Gerald Hebinck

clear all;
clc;
createSerialLink_zeroModify()

%Start and radius
start = [ 361 0 302];
radius = 50;

%Steps
step = 1/100;
a = transpose(0 : step: 1);
steps = size(a);

%Allocation of memory
way = zeros(steps(1), 3);

%Calculation of waypoints
for i=1:steps(1)
    way(i,:) = [start(1) + radius*cos(2*pi*a(i)) start(2) start(3) + radius*sin(2*pi*a(i))];
end

%Pause between Steps
pause_ = 0.01;

%InverseKinematics and execution in plot
for i = 1:steps(1)
    target = inverse_youbot([way(i,1) way(i,2) way(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
