% RSY 2020/21
% T. Thuilot und A. Heid

% Berechnet die Höhe der Übergabeposition


function z_Koord = HoeheZ(x,y,psi)

% Länge der Achsen
a1 = 147;
a2 = 155;
a3 = 135;
a4 = 217.5;
d1 = 33;


Theta2 = asin((sqrt(x^2 + y^2) - d1 - cos(psi)*a4)/(a2 + a3)); % berechnet Theta2 bei theta3 = 0

z_Koord = a1 + a4*sin(psi) + (a2 + a3)*cos(Theta2); % z-Koordinate der Übergabe