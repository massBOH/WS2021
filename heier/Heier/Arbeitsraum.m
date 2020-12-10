function Arbeitsraum(Koordinaten)

x = Koordinaten(1);
y = Koordinaten(2);
z = Koordinaten(3);
psi = Koordinaten(4);

a_1=147;
a_2=155;
a_3=135;
a_4=218;
R_max = 508;
Theta_3max = deg2rad(150);

Theta_2 = acos((z-a_1-(a_4*sin(psi)))/(a_2+a_3));

a = sqrt(x^2+y^2)-33-cos(psi)*a_4;
b = z-147-a_4*sin(psi);
l23 = sqrt(a_2^2+a_3^2-(2*a_2*a_3*cos(pi-Theta_3max)));
%Max = sqrt((z-147)^2+x^2+y^2)-a_4*(cos((pi/2)+psi-Theta_2))-(33*sin(Theta_2)); %<=508
Max = sqrt((sqrt(x^2+y^2)-a_4*cos(psi))^2+(z-147-sin(psi)*a_4)^2)-33*sin(Theta_2); %Neue Berechnung vom 1.12
Min = sqrt(a^2+b^2); % >=l23

if Max<=R_max && Min>=l23
    disp("Das schaffe ich");
else
    error("Die Koordinaten sind außerhalb meiner Reichweite");
end
    