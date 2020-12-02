% RoboterSysteme WS2020/21
% where_to_give
% 02.12.2020 Gerald Hebinck
% takes distance to counterpart in r and psi 
% returns a target and a 0 for valid and -1 for invalid distance

function [target, retval] = where_to_give(r, psi)

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
    
    target(1) = link12_offset;
    target(2) = 0;
    target(3) = link12_length + link23_offset + link34_offset + link45_length;
    target(4) = pi/2;
    target(5) = 0;
    retval    = -1;
    
    platform_width = 376;
    wheel_offset   = 84.5;
    wheel_diameter = 100;
    
    link24_offset  = link23_offset + link34_offset;
    link45_cos_psi = link45_length * cos(psi);
    link45_sin_psi = link45_length * sin(psi);
    r_half_abs     = sqrt((r(1)/2+r(2)/2)^2);
    
    pos_max = link24_offset + link45_cos_psi + link12_offset - 10;
    if (pos_max >= r_half_abs)
        pos_min = sqrt((1/2 * platform_width)^2 + (wheel_offset + wheel_diameter / 2)^2);
        if (pos_min < r_half_abs)
            theta2  = asin((r_half_abs - link12_offset - link45_cos_psi)/(link24_offset));
            pos_z  = link12_length + link45_sin_psi + link24_offset * cos(theta2);
            target(1) = r(1)/2;
            target(2) = r(2)/2;
            target(3) = pos_z*0.9;
            target(4) = psi;
            retval = 0;
        end
    end
end