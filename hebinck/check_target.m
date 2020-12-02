% RoboterSysteme WS2020/21
% CheckTarget KUKA youbot
% 01.12.2020 Gerald Hebinck
% takes target as vector with x, y, z, psi
% returns 0 for reachable, -1 for to close, 1 for to far away

function retval = check_target(target)
    
    DH_array = [  33, pi/2,   147, 0;
                 155,    0,     0, 0;
                 135,    0,     0, 0;
                   0, pi/2,     0, 0;
                   0,    0, 217.5, 0
               ];

    link12_length = DH_array(1,3); 
    link23_offset = DH_array(2,1);
    link34_offset = DH_array(3,1);
    link45_length = DH_array(5,3);
    link12_offset = DH_array(1,1);
    theta3_max = 150/180*pi;
    
    x = target(1);
    y = target(2);
    z = target(3);
    psi = target(4);
    
    % Calculate theta2
    theta2_num   = z - link12_length - link45_length * sin(psi);
    theta2_denum = link23_offset + link34_offset;
    theta2       = acos(theta2_num / theta2_denum);

    % Calculate r, z, abs of both and offset
    part_r   = sqrt(x^2 + y^2) - link45_length * cos(psi)
    part_z   = z - link12_length - link45_length * sin(psi)
    part_xyz = sqrt( part_r^2 + part_z^2)
    part_l12 = link12_offset * sin(theta2);
    
    % Calculate max_length and the needed length
    max_length = link23_offset + link34_offset
    max_test   = part_xyz - part_l12;
    
    % Calculate the minimal target
    %min_r = sqrt(x^2 + y^2) - link12_offset - cos(psi) * link45_length;
    min_r = part_r - link12_offset;
    %min_z = z - link12_length - link45_length * sin(psi);
    min_z = part_z;

    % Calculate min_length and the needed length
    min_test   = sqrt(min_r^2 + min_z^2);
    min_length = sqrt(link23_offset^2 + link34_offset^2 - (2*link23_offset * link34_offset * cos(pi - theta3_max)));
    
    % Evaluation of results
    if(max_length > max_test)
        if(min_length < min_test)
            retval = 0;
        else
            retval = -1;
        end
    else
        retval = 1;
    end
end
