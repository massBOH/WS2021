function Winkel = Inverskinematik_fertig(Koordinaten)

% syms theta_1
% syms theta_2
% syms theta_3
% syms theta_4
% syms theta_5
% sym alpha
% sym beta
% syms r_d
% syms z_d
% syms r_4
% syms z_4
% syms s

x=Koordinaten(1);
y=Koordinaten(2);
z=Koordinaten(3);
psi=Koordinaten(4);

a_1=147;
a_2=155;
a_3=135;
a_4=217.5;
d_1=33;

theta_1=atan2(y,x);
d=sqrt(x^2+y^2);
z_d=z-a_1;

if(abs(theta_1)<deg2rad(170))
    
    %benötigte Werte
    r_d=d-d_1;
    
    r_4=r_d-a_4*cos(psi);

    z_4=z_d-a_4*sin(psi);

    s=sqrt(r_4^2+z_4^2);

    alpha=atan2(z_4,r_4);

    beta=acos((-s^2+a_2^2+a_3^2)/(2*a_2*a_3));

    %Berechnung der Winkel
    theta_3=-(beta-pi);
    theta_2=pi/2 -(alpha+ asin((sin(beta)*a_3)/s));
    %psi = 0 = -theta2-theata3-theta4+pi/2
    theta_4=-(psi+theta_2+theta_3-(pi/2));
    theta_5=Koordinaten(5);

else
    %benötigte Werte
    r_d=d+d_1;
    if(theta_1>0)
        theta_1=theta_1-pi;
    else
        theta_1=theta_1+pi;
    end

    r_4=r_d-a_4*cos(psi);

    z_4=z_d-a_4*sin(psi);

    s=sqrt(r_4^2+z_4^2);

    alpha=atan2(z_4,r_4);

    beta=acos((-s^2+a_2^2+a_3^2)/(2*a_2*a_3));

    %Berechnung der Winkel
    theta_3=-(beta-pi);
    theta_2=pi/2 -(alpha+ asin((sin(beta)*a_3)/s));
    %psi = 0 = -theta2-theata3-theta4+pi/2
    theta_4=-(psi+theta_2+theta_3-(pi/2));
    theta_5=Koordinaten(5);  
    theta_3=-theta_3;
    theta_2=-theta_2;
    theta_4=-theta_4;
end
Winkel=[theta_1 theta_2 theta_3 theta_4 theta_5]

