% RoboterSysteme WS2020/21
% ForwardKinematics KUKA youbot
% 12.11.2020 Gerald Hebinck
% takes vector of angles, returns transformation matrix

function eecp = forward_camera_youbot(theta_)


    % theta_ := rotation angles
    % theta_offset := angle zero points
    % DH_array := Denavit-Hartenberg-values
    % eecp = endEffectorCenterPoint
    % theta_ = input param;
    theta_offset = [ 0 pi/2 0 0 0];
    DH_array = [  33, pi/2,   147, theta_(1)+theta_offset(1);
                 155,    0,     0, theta_(2)+theta_offset(2);
                 135,    0,     0, theta_(3)+theta_offset(3);
%                  0, pi/2,     0, theta_(4)+theta_offset(4);
%                  0,    0, 217.5, theta_(5)+theta_offset(5)
                   0, -pi/2,     0, theta_(4)+theta_offset(4);
                  65,   pi,    50, theta_(5)+theta_offset(5)    
               ];
    eecp = 1;

    % calculation
    for c = 1:5
        % get params from DH_array
        a = DH_array(c,1);
        alpha = DH_array(c,2);
        l = DH_array(c,3);
        theta = DH_array(c,4);

        % build translation and rotation matrices
        rot_axis = [
                             1,          0,          0,          0;
                             0, cos(alpha),-sin(alpha),          0;
                             0, sin(alpha), cos(alpha),          0;
                             0,          0,          0,          1
                   ];
        rot_angle = [
                    cos(theta),-sin(theta),          0,          0;
                    sin(theta), cos(theta),          0,          0;
                             0,          0,          1,          0;
                             0,          0,          0,          1
                    ];
        trans_length = [
                             1,          0,          0,          0;
                             0,          1,          0,          0;
                             0,          0,          1,          l;
                             0,          0,          0,          1
                       ];
        trans_offset = [
                             1,          0,          0,          a;
                             0,          1,          0,          0;
                             0,          0,          1,          0;
                             0,          0,          0,          1
                       ];    

        % apply matrices to previous value
        eecp = eecp * rot_angle * trans_length * trans_offset * rot_axis;
    end
end