clear all;
close all;
clc;
%ROS-Verbindung initialisieren
ros = runROS();

aktiv = 1;
master = 2;
posi = 4;
gripperZu = 8;
gedreht = 16;
ACK = 32;

myPub = rospublisher('YB1','std_msgs/Byte');
rosmsg = rosmessage(myPub);
mySub = rossubscriber('YB2','std_msgs/Byte');

while (1)
    bereit = 0;
    while(~bereit)
        bereit = input('Bereit (0 = Nein, 1 = Ja)?: ');
        pause(0.1)
    end
    active_state(myPub,mySub,aktiv,aktiv);

    state = 0;
    while(~state)
        state = input('State? (0 = Warten, 1 = Senden, 2 = Empfangen): ');
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
