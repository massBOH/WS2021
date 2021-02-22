%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Skript com_test
%
% Testimplementierung der Kommunikationsfunktionen
% active_state, receive_state und send_state

clear all;
close all;
clc;

% ROS-Verbindung initialisieren
ros = runROS();

% Publisher und Subscriber instanzieren
myPub = rospublisher('YB1','std_msgs/Byte');
rosmsg = rosmessage(myPub);
mySub = rossubscriber('YB2','std_msgs/Byte');

% Kommunikation zwischen den Youbots
aktiv = 1;
master_msg = 2;
posi = 4;
greifer = 8;
gedreht = 16;
ACK = 32;

% Endlosschleife
while (1)
    bereit = 0;
    while(~bereit)
        bereit = input('Bereit (0 = Nein, 1 = Ja)?: ');
        pause(0.1)
    end
    active_state(myPub,mySub,aktiv,aktiv);

    state = 0;
    while(~state)
        state = input('State? (1 = Senden, 2 = Empfangen): ');
        pause(0.1)
    end
    
    if (state == 1)
        send_state(myPub,mySub,master,ACK)
        disp('Nachricht gesendet')
    else
        receive_state(myPub,mySub,ACK,master)
        disp('Nachricht empfangen')
    end
end
