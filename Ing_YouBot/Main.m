%Main

% TODO: ROS Interface, Ablegen, Kommentare und Doku

clear all;
close all;
clc;
%ROS-Verbindung initialisieren
ros = runROS();

myPub = rospublisher('YB1','std_msgs/Byte');
rosmsg = rosmessage(myPub);
mySub = rossubscriber('YB2','std_msgs/Byte');

%Festlegen bestimmter Positionen
kerzePos = deg2rad(ros.Arm.Info.JointUp); %[0 0 0 0 0];
sicherPos = [0 deg2rad(-60) deg2rad(60) pi/2 0];
parkPos = deg2rad(ros.Arm.Info.JointRes); %[0 deg2rad(-65) deg2rad(146) deg2rad(-102) 0];
camera_youbotPos = [0 0 0 deg2rad(-30) 0];
camera_klotzPos = [deg2rad(-170) 0 0 0 deg2rad(-12) 0];

%Kommunikation zwischen den Youbots
aktiv = 1;
master_msg = 2;
posi = 4;
gripper = 8;
gedreht = 16;
ACK = 32;

%Initialisierungsfahrt in die Kerze
disp('Fahre in Kerze');
GelenkPos(ros,kerzePos);

%Greifer öffnen
disp('Oeffne Greifer');
GreiferPos(ros, 20);

receive_state(myPub,mySub,aktiv,aktiv);

yb2_nichtbereit = 0;
disp('Pruefe YB2 bereit')
while(~yb2_nichtbereit)
    yb2_nichtbereit = input('Ist YB2 bereit (0 = Nein, 1 = Ja)?: ');
    pause(0.1)
end

detect = 0;
YB2master = 0;
YB1master = 0;
disp('Klotz erkennen')
while (~detect && ~YB2master)
    try
        GelenkPos(ros, camera_klotzPos);
        klotz_Pos=Klotz_Position();
        klotz_Pos(3); %Prüfung
        detect = 1;
        YB1master = 1;
    catch ME
        disp("Keinen Klotz erkannt");
            try
                submsg = receive(mySub, 1);
                YB2master=submsg.Data;
            catch
                
            end
        %YB2master = input('Ist YB2 Master (0 = Nein, 1 = Ja)?: ');
        
    end
end

%Festlegung, ob dieser Youbot übergibt oder übernimmt
if(YB1master ==1)
    disp('Ich bin Master')
    master=1;   % -> dieser Youbot übergibt
    send_state(myPub,mySub,master_msg,ACK);
    disp('Nachricht gesendet');
else
    disp('Ich bin Slave')
    master=0;    % -> dieser Youbot übernimmt
    receive_state(myPub,mySub,ACK,master_msg);
    disp('Nachricht empfangen');
end

%Position des Klotzes anfahren, falls dieser Youbot übergibt
if master==1
    disp('Picke Klotz')
    Klotz_aufnehmen(ros, klotz_Pos);
    GelenkPos(ros,kerzePos);
end

%Position des anderen Youbots messen
detect = 0;
disp('Suche YB2')
while (~detect)
    try
        GelenkPos(ros,camera_youbotPos);
        Youbot_Pos=Youbot_Position();
        detect = 1;
    catch ME
        disp("YouBot2 not detected");
        pause(1);
    end
end

%Übergabeposition bestimmen
psi = 0;
r = Youbot_Pos(1)/2;
phi = Youbot_Pos(2);
x_Uebergabe = (r)*cos(phi);
y_Uebergabe = (r)*sin(phi);
z_Uebergabe = Berechnung_Z(x_Uebergabe,y_Uebergabe,psi);

%Position vor der Übergabe bestimmen
x_Vorgabe = (r-20)*cos(phi);
y_Vorgabe = (r-20)*sin(phi);
z_Vorgabe = z_Uebergabe;

%falls dieser Youbot den Klotz abgibt, muss Theta 5 angepasst werden
if master==1
    Theta_5 = pi/2;
    sicherPos(5) = Theta_5; 
else
    Theta_5 = 0;
end

%Vorgabeposition anfahren
%Sicherheitsabstand prüfen
GelenkPos(ros,sicherPos);
GelenkPos(ros, Inverskinematik([x_Vorgabe y_Vorgabe z_Vorgabe 0 Theta_5]));
%Trajektorien_Youbot(ros, [x_Vorgabe, y_Vorgabe, z_Uebergabe; x_Uebergabe, y_Uebergabe, z_Uebergabe],Theta_5);

yb2_uebergabe = 0;
if master==1
    receive_state(myPub,mySub,ACK,posi);
%     while(~yb2_uebergabe)
%         yb2_uebergabe = input('Ist YB2 in UebergabePos (0 = Nein, 1 = Ja)?: ');
%         pause(0.1)
%     end
end

GelenkPos(ros, Inverskinematik([x_Uebergabe y_Uebergabe z_Uebergabe 0 Theta_5]));

%Übergabeposition anfahren
%Trajektorien_Youbot(ros, [x_Uebergabe, y_Uebergabe, z_Uebergabe; x_Vorgabe, y_Vorgabe, z_Uebergabe],Theta_5);

if master==0
    send_state(myPub,mySub,posi,ACK);
end

%Klotz übernehmen/übergeben
yb2_greiferzu = 0;
if master==1
    send_state(myPub,mySub,posi,ACK);
    receive_state(myPub,mySub,ACK,gripper);
%     while(~yb2_greiferzu)
%         yb2_greiferzu = input('Ist YB2 Greifer geschlossen? (0 = Nein, 1 = Ja)?: ');
%         pause(0.1)
%     end
    GreiferPos(runROS(), 20);
    send_state(myPub,mySub,gripper,ACK);
else
    receive_state(myPub,mySub,ACK,posi);
%     while(~yb2_uebergabe)
%         yb2_uebergabe = input('Ist YB2 in UebergabePos (0 = Nein, 1 = Ja)?: ');
%         pause(0.1)
%     end
    GreiferPos(runROS(), 0);
    send_state(myPub,mySub,gripper,ACK);
end

yb2_wegdrehen = 0;
if master==1
    receive_state(myPub,mySub,ACK,gedreht);
%     while(~yb2_wegdrehen)
%         yb2_wegdrehen = input('Ist YB2 weggedreht (0 = Nein, 1 = Ja)?: ');
%         pause(0.1)
%     end
else
    receive_state(myPub,mySub,ACK,gripper);
end

wegdrehPOS = Inverskinematik([x_Uebergabe y_Uebergabe z_Uebergabe 0 Theta_5]);
wegdrehPOS(1) = pi/4;
GelenkPos(ros,wegdrehPOS);
if master == 0
    send_state(myPub,mySub,gripper,ACK);
end

GelenkPos(ros,kerzePos);

if master == 0
    Klotz_ablegen(ros, [-201.44 39.39 61.31 0 0]);
end

GelenkPos(ros,kerzePos);
disp('Übergabe abgeschlossen');