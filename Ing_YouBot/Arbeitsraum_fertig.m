function Arbeitsraum_fertig(Koordinaten)

%Eingabewerte einlesen
x=Koordinaten(1);   %Einlesen der x-Koordinate
y=Koordinaten(2);   %Einlesen der y-Koordinate
z=Koordinaten(3);   %Einlesen der z-Koordinate
psi=Koordinaten(4); %Einlesen von Psi

%vorgegebene Parameter
theta_3_max=deg2rad(150);
theta_3_min=deg2rad(-150);
z_Versatz=147;
r_Versatz=33;
LinkLaenge_1=147;
LinkLaenge_2=155;
LinkLaenge_3=135;
LinkLaenge_4=217.5;
l_2=LinkLaenge_2;
l_3=LinkLaenge_3;
l_4=LinkLaenge_4;
Rmax=508;
erreichbar=0;

%Berechnung für die Überprüfung des maximalen Radius
theta_3=0;
theta_2=acos((z-LinkLaenge_1-LinkLaenge_4*sin(psi))/(LinkLaenge_2+LinkLaenge_3));
theta_4=pi/2-theta_2+psi;
R_1=sqrt((z-z_Versatz)^2+x^2+y^2)+LinkLaenge_4*cos(theta_4)-(r_Versatz*sin(theta_2));

%Berechnung für die Überprüfung des minimalen Radius
a=sqrt(x^2+y^2)-r_Versatz-cos(psi)*l_4;
b=z-z_Versatz-l_4*sin(psi);
R_2=sqrt(a^2+b^2);
Rmin= sqrt(l_2^2+l_3^2-2*l_2*l_3*cos(pi-theta_3_max));

%Ueberpruefung und Ausgabe
if(R_1<=Rmax) && (R_2>=Rmin)
    erreichbar=1;
elseif (R_1>Rmax)
    erreichbar=0;
    error("Koordinaten sind nicht erreichbar, Arm zu kurz")
elseif (R_2<Rmin)
    erreichbar=0;
    error("Koordinaten sind nicht erreichbar, Koordinate zu nah")
end 