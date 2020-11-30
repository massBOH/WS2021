% RoboterSysteme WS2020/21
% CheckTarget KUKA youbot
% 30.11.2020 Gerald Hebinck

target = [310 0 0 -pi/2 0];

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
theta5 = target(5);

theta2_num = z - link12_length - link45_length * sin(psi);
theta2_denum = link23_offset + link34_offset;
theta2 = acos(theta2_num / theta2_denum);

theta4 = (pi/2) - psi - theta2;

part_xyz = sqrt((z - link12_length)^2 + x^2 + y^2);
part_l45 = link45_length * (1 - cos(theta4));
part_l12 = link12_offset * sin(theta2);

max_length = link23_offset + link34_offset + link45_length;
max_test = part_xyz + part_l45 - part_l12;

min_a = sqrt(x^2 + y^2) - link12_offset - cos(psi) * link45_length;
min_b = z - link12_length - link45_length * sin(psi);
min_test = sqrt(min_a^2 + min_b^2)
min_length = sqrt(link23_offset^2 + link34_offset^2 - (2*link23_offset * link34_offset * cos(pi - theta3_max)))

