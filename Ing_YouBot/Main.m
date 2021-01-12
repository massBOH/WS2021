%Main
clear all;
close all;
clc;
%ROS-Verbindung initialisieren
ros = runROS();

theta2_min = deg2rad(-65);
theta3_max = deg2rad(150);
theta4_min = deg2rad(-95);

kerzePOS = [0 0 0 0 0];
sicherPOS = [0 deg2rad(-60) deg2rad(60) pi/2 0];
parkPOS= [0 theta2_min theta3_max theta4_min 0];
camera_youbotPOS = [0 0 0 deg2rad(-30) 0];
camera_klotzPOS = [deg2rad(-170) 0 0 0 deg2rad(-12) 0];

%Initialisierungsfahrt in die Kerze
GelenkPos(ros,kerzePOS);

%Greifer öffnen
%GreiferPos(ros, 20);

%Position des anderen Youbots messen



%Festlegung, ob dieser Youbot übergibt oder übernimmt
master=1;   %master=1 -> dieser Youbot übergibt
            %master=0 -> dieser Youbot übernimmt           
            
%Position des Klotzes messen und anfahren, falls dieser Youbot übergibt
if master==1
    %Klotz_aufnehmen;
    GelenkPos(ros,kerzePOS);
end

GelenkPos(ros,camera_youbotPOS);
Youbot_Pos=Youbot_Position();

%Position vor der Übergabe bestimmen
psi=0;

%Übergabeposition bestimmen
x_Uebergabe=(Youbot_Pos(1)/2)*cos(Youbot_Pos(2));
y_Uebergabe=(Youbot_Pos(1)/2)*sin(Youbot_Pos(2));
z_Uebergabe=Berechnung_Z(x_Uebergabe,y_Uebergabe,psi);

x_Vorgabe=(Youbot_Pos(1)/2-20)*cos(Youbot_Pos(2));
y_Vorgabe=(Youbot_Pos(1)/2-20)*sin(Youbot_Pos(2));
z_Vorgabe=z_Uebergabe;
%falls dieser Youbot den Klotz annimmt, muss Theta 5 angepasst werden
if master==1
        Theta_5=pi/2; 
else
        Theta_5=0;
end

%Vorgabeposition anfahren

%Sicherheitsabstand prüfen
GelenkPos(ros,sicherPOS);
GelenkPos(ros, Inverskinematik([x_Vorgabe y_Vorgabe z_Vorgabe 0 Theta_5]))
GelenkPos(ros, Inverskinematik([x_Uebergabe y_Uebergabe z_Uebergabe 0 Theta_5]))
%Trajektorien_Youbot([x_Vorgabe, y_Vorgabe, z_Uebergabe; x_Uebergabe, y_Uebergabe, z_Uebergabe],Theta_5);

%Übergabeposition anfahren
%Trajektorien_Youbot([x_Uebergabe, y_Uebergabe, z_Uebergabe; x_Vorgabe, y_Vorgabe, z_Uebergabe],Theta_5);

%Klotz übernehmen/übergeben
if master==1
    GreiferPos(runROS(), 20);
else
    GreiferPos(runROS(), 0);
end

wegdrehPOS = Inverskinematik([x_Uebergabe y_Uebergabe z_Uebergabe 0 Theta_5])
wegdrehPOS(1) = pi/4;
GelenkPos(ros,wegdrehPOS);
GelenkPos(ros,kerzePOS);

%Vorgabeposition anfahren
%Trajektorien_Youbot
%GelenkPos(runROS(),Winkel_Vorgabe);

%disp('Übergabe erfolgreich abgeschlossen')