function theta = Youbot_trans_invers(target_)

%Eingabewerte
%r=385.5
x=target_(1)
y=target_(2)
z=target_(3)
psi=target_(4)

% syms theta_1 theta_2 theta_3 theta_4 theta_5
% syms alpha beta
% syms r_d z_d r_4 z_4 s

a_1=147;
a_2=155;
a_3=135;
a_4=218;
d_1=33;

%benötigte Werte
r_d=sqrt(x^2+y^2)-d_1;

%r_d=r-d_1

z_d=z-a_1;

r_4=r_d-a_4*cos(psi);

z_4=z_d-a_4*sin(psi);

s=sqrt(r_4^2+z_4^2);

alpha=atan2(z_4,r_4);

beta=acos((-s^2+a_2^2+a_3^2)/(2*a_2*a_3));

%Berechnung der Winkel
theta_1=atan2(y,x);
theta_3=beta-pi;
theta_2=alpha+ asin((sin(beta)*a_3)/s);
theta_4=psi-theta_2-theta_3+(pi/2);
theta_5= target_(5);
theta = [theta_1 theta_2 theta_3 theta_4 theta_5];
end
