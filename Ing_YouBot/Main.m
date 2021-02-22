%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main-Funktion
%
% Flusssteuerung der Uebergabe eines Klotzes
% zwischen zwei Kuka Youbots 
%
% Zusaetzlich zu den implementierten Funktionen
% werden folgende Funktionen benoetigt:
%   - runROS
%   - GelenkPos
%   - GreiferPOS
%   - KreisErkennung
%   - Hermes
%
% Fuer die Ausfuehrung muessen folgende Programme
% gestartet werden:
%       Hardwareansteuerung
%   - roslaunch youbot_driver_ros_interface youbot_driver.launch
%       Tiefenkamera
%   - roslaunch astra_launch astra.launch
%       Datenaustausch zwischen den Youbots
%   - /usr/local/MATLAB/R2018b/bin/matlab -nodesktop -nosplash -r Hermes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Initialisierung von ROS und Definition von Variablen
%

clear all;
close all;
clc;
% ROS-Verbindung initialisieren
ros = runROS();

% Publisher und Subscriber instanzieren
myPub = rospublisher('YB1','std_msgs/Byte');
rosmsg = rosmessage(myPub);
mySub = rossubscriber('YB2','std_msgs/Byte');

% Festlegen der Positionen
kerzePos = deg2rad(ros.Arm.Info.JointUp); %[0 0 0 0 0];
sicherPos = [0 deg2rad(-60) deg2rad(60) pi/2 0];
parkPos = deg2rad(ros.Arm.Info.JointRes); %[0 deg2rad(-65) deg2rad(146) deg2rad(-102) 0];
camera_youbotPos = [0 0 0 deg2rad(-30) 0];
camera_klotzPos = [deg2rad(-170) 0 0 0 deg2rad(-12) 0];

% Kommunikation zwischen den Youbots
aktiv = 1;
master_msg = 2;
posi = 4;
greifer = 8;
gedreht = 16;
ACK = 32;

%
% Programmstart
%

% Initialisierungsfahrt in die Kerze
disp('Fahre in Kerze');
GelenkPos(ros,kerzePos);

% Greifer öffnen
disp('Oeffne Greifer');
GreiferPos(ros, 20);

% YB2 Bereit?
disp('Warte auf YB2 bereit')
receive_state(myPub,mySub,aktiv,aktiv);
disp('Nachricht empfangen');

% Manuelle Abfrage, als Sicherheitsfunktion
yb2_nichtbereit = 0;
while(~yb2_nichtbereit)
    yb2_nichtbereit = input('Ist YB2 bereit (0 = Nein, 1 = Ja)?: ');
    pause(0.1)
end

% Erkennen eines Klotzes
detect = 0;
YB2master = 0;
YB1master = 0;
disp('Klotz erkennen')
% Solange kein Klotz erkannt wurde oder YB2 nicht Master ist
while (~detect && ~YB2master)
    % Versuche den Klotz zu erkennen
    try
        GelenkPos(ros, camera_klotzPos);
        klotz_Pos=Klotz_Position(ros);
        klotz_Pos(3); %Pruefung ob Rueckgabe valide
        detect = 1;
        YB1master = 1;
    % Fehlerbehandlung
    catch ME
        disp("Keinen Klotz erkannt");
            % Hat YB2 einen Klotz gefunden?
            try
                submsg = receive(mySub, 1);
                YB2master=submsg.Data;
            % Fehler abfangen
            catch
            end
        % Manuell YB2 Master setzen
        %YB2master = input('Ist YB2 Master (0 = Nein, 1 = Ja)?: ');
    end
end

% Festlegung, ob Master oder Slave
if(YB1master ==1)
    disp('Ich bin Master')
    master=1;   % -> dieser Youbot uebergibt
    send_state(myPub,mySub,master_msg,ACK);
    disp('Nachricht gesendet');
else
    disp('Ich bin Slave')
    master=0;    % -> dieser Youbot uebernimmt
    receive_state(myPub,mySub,ACK,master_msg);
    disp('Nachricht empfangen');
end
% Falls Master
if master==1
    % Klotz aufnehmen
    disp('Picke Klotz')
    Klotz_aufnehmen(ros, klotz_Pos);
    disp('Fahre in Kerze');
    GelenkPos(ros,kerzePos);
end

% Position von YB2 messen
detect = 0;
disp('Suche YB2')
while (~detect)
    % Versuche YB2 zu erkennen
    try
        GelenkPos(ros,camera_youbotPos);
        Youbot_Pos=Youbot_Position(ros);
        detect = 1;
        disp("YouBot2 erkannt");
    % Fehlerbehandlung
    catch ME
        disp("YouBot2 nicht erkannt");
        pause(1);
    end
end

% Uebergabeposition bestimmen
psi = 0;
r = Youbot_Pos(1)/2;
phi = Youbot_Pos(2);
x_Uebergabe = (r)*cos(phi);
y_Uebergabe = (r)*sin(phi);
z_Uebergabe = Berechnung_Z(x_Uebergabe,y_Uebergabe,psi);

% Position vor der Uebergabe bestimmen
x_VorUebergabe = (r-20)*cos(phi);
y_VorUebergabe = (r-20)*sin(phi);
z_VorUebergabe = z_Uebergabe;

% Falls Master
if master==1
    % Theta 5 auf 90 Grad setzen
    Theta_5 = pi/2;
    sicherPos(5) = Theta_5;
% Falls Slave
else
    % Theta 5 auf 0 Grad setzen
    Theta_5 = 0;
end

% VorUebergabeposition anfahren
disp("Fahre in sichere Position");
GelenkPos(ros,sicherPos);
disp("Fahre in VorUebergabePosition");
GelenkPos(ros, Inverskinematik([x_VorUebergabe y_VorUebergabe z_VorUebergabe 0 Theta_5]));

% Falls Master

if master==1
    % warten bis YB2 in UebergabePos
    disp("Warte auf YB2 in UebergabePosition");
    receive_state(myPub,mySub,ACK,posi);
    disp('Nachricht empfangen');
end

% Uebergabeposition anfahren
disp("Fahre in UebergabePosition");
GelenkPos(ros, Inverskinematik([x_Uebergabe y_Uebergabe z_Uebergabe 0 Theta_5]));
%Trajektorien_Youbot(ros, [x_VorUebergabe, y_VorUebergabe, z_Uebergabe; x_Uebergabe, y_Uebergabe, z_Uebergabe],Theta_5);

% Falls Slave 
if master==0
    % YB2 mitteilen, dass in UebergabePos
    disp("Melde YB2 UebergabePos");
    send_state(myPub,mySub,posi,ACK);
    disp('Nachricht gesendet');
end

% Klotz nehmen/geben
% Falls Master
if master==1
    % YB2 mitteilen, dass in UebergabePos
    disp("Melde YB2 UebergabePos");
    send_state(myPub,mySub,posi,ACK);
    disp('Nachricht gesendet');
    % warten bis YB2 Greifer geschlossen
    disp("Warte auf YB2 Greifer geschlossen");
    receive_state(myPub,mySub,ACK,greifer);
    disp('Nachricht empfangen');
    % Greifer oeffnen
    GreiferPos(runROS(), 20);
    % YB2 mitteilen, dass Greifer offen
    disp("Melde YB2 Greifer offen");
    send_state(myPub,mySub,greifer,ACK);
    disp('Nachricht gesendet');
% Falls Slave
else
    % warten bis YB2 in UebergabePos
    disp("Warte auf YB2 in UebergabePos");
    receive_state(myPub,mySub,ACK,posi);
    disp('Nachricht empfangen');
    % Greifen

    GreiferPos(runROS(), 0);
    % YB2 mitteilen, dass Greifer geschlossen 
    disp("Melde YB2 Greifer geschlossen");
    send_state(myPub,mySub,greifer,ACK);
    disp('Nachricht gesendet');
end

% Falls Master
if master==1
    % warten bis YB2 weggedreht
    disp("Warte auf YB2 gedreht");
    receive_state(myPub,mySub,ACK,gedreht);
    disp('Nachricht empfangen');
% Falls Slave
else
    % warten bis YB2 Greifer offen
    disp("Warte auf YB2 Greifer offen");
    receive_state(myPub,mySub,ACK,greifer);
    disp('Nachricht empfangen');
end

% Wegdrehen
wegdrehPOS = Inverskinematik([x_Uebergabe y_Uebergabe z_Uebergabe 0 Theta_5]);
wegdrehPOS(1) = pi/4;
GelenkPos(ros,wegdrehPOS);
% Falls Slave
if master == 0
    % YB2 mitteilen, dass weggedreht
    disp("Melde YB2 gedreht");
    send_state(myPub,mySub,gedreht,ACK);
    disp('Nachricht gesendet');
end

% In Kerzenposition fahren
disp('Fahre in Kerze');
GelenkPos(ros,kerzePos);

% Falls Slave
if master == 0
    % Klotz ablegen
    disp('Klotz ablegen');
    Klotz_ablegen(ros, [-201.44 39.39 61.31 0 0]);
    % In Kerzenposition fahren
    disp('Fahre in Kerze');
    GelenkPos(ros,kerzePos);
end

disp('Uebergabe abgeschlossen');