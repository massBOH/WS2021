% RoboterSysteme WS2020/21
% Test for fahrt_parameter
% 18.11.2020 Gerald Hebinck

clear all;
clc;

%Create YouBot
createSerialLink_zeroModify()

%Targets
center = [ 361 0 302];
p0 = [0 -25 -25] + center;
p1 = [0  25 -25] + center;
p2 = [0  25  25] + center;
p3 = [0 -25  25] + center;
p4 = [0   0  25+50/sqrt(2)] + center;

%Route
points = [center; p0; p1; p2; p0; p3; p4; p2; p3; p1];

%Function call
fahrt_parameter(points, 0.1, 0.01, YouBot)