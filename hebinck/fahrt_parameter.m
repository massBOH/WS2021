% RoboterSysteme WS2020/21
% Linear trajectory planning
% 18.11.2020 Gerald Hebinck
% takes array of points in x/y/z, stepsize between points,
% pause duration, instance of YouBot

function fahrt_parameter(points, step_, pause_, YouBot)

% Count Points
n = size(points);
% Create Step-Vector
a = transpose(0 : step_: 1);
% Count Steps
steps = size(a);
% Memory allocation of 3dim Array
way = zeros(steps(1),3,n(1)-1);

% Calculate trajectory
for i = 1 : n-1
    way(:,:,i) = a * (points(i+1,:) - points(i,:)) + points(i,:);
end

%InverseKinematics and execution in plot
for i = 1 : n-1
    for j = 1:steps(1)
        target = inverse_youbot([way(j,1,i) way(j,2,i) way(j,3,i) 0 0]);
        YouBot.plot(target);
        pause(pause_);
    end
end
