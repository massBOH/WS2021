rosshutdown

rosinit

standby_int= 0;
active_int = 1;
master_int = 2;
ubergabe_int  = 3;
gripperz_int= 4; %zu


Publisher=rospublisher('/YB1','std_msgs/Byte'); % Publisher für Hermes
Nachricht=rosmessage(Publisher);%Nachricht initialisieren
Subscriber=rossubscriber('/YB2','std_msgs/Byte'); % Subscriber für Hermes

% check if ready
lauschen=1;
while lauschen == 1
        Nachricht.Data =active_int;
        send(Publisher,Nachricht);
        
        try
           NaYB2 = receive(Subscriber, 0.1);
           if NaYB2.Data==active_int
               lauschen = 0;
           end

        catch
        end
end


disp('Beide Bots bereit')


try 
    KlotzPositionAnfahren();
    master = 1;
    disp("master")
    
catch exception
    master = 0;
    disp("slave")
    GreiferPos(runROS(),20); % Greifer offen
    
end


for i = 1:5

    erkannte_uebergabe = 0;
    erkannte_uebergabe = ubergabe_erkennung();
    if erkannte_uebergabe > 0
     break
    end

end

uebergabeX    = erkannte_uebergabe(1);
uebergabeY    = erkannte_uebergabe(2);
uebergabeZ    = erkannte_uebergabe(3);
voruebergabeX = erkannte_uebergabe(4);
voruebergabeY = erkannte_uebergabe(5);
voruebergabeZ = erkannte_uebergabe(3);

if master == 1
    theta5 = pi/2;
    
    Nachricht.Data =master_int;
    send(Publisher,Nachricht);

    
else 
    theta5 = 0;
end

voruebergabe = inverse_youbot_real([voruebergabeX voruebergabeY voruebergabeZ 0 theta5]); 
uebergabe = inverse_youbot_real([uebergabeX uebergabeY uebergabeZ 0 theta5]); 

GelenkPos(runROS,voruebergabe); %voruebergabe position
%wenn master -> warte das slave in übergabe pos
if master ==1
    lauschen=1;
    while lauschen == 1
            disp('Ist Slave in Ubergabe?')
            try
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data==ubergabe_int
                   lauschen = 0;
               end

            catch
            end
    end
    
end
GelenkPos(runROS,uebergabe); %uebergabe position
% wenn slave -> sende das ubergabeposition erreicht
if master == 0
   Nachricht.Data =ubergabe_int;
   send(Publisher,Nachricht); 
end

%wartet das slave
%greifer schließt
%master oeffnet greifer -> sendet das greifer offen ist 
if master == 1
    lauschen=1;
    while lauschen == 1
            disp('Ist der Gripper von Slave zu?')
            try
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data==gripperz_int
                   lauschen = 0;
               end

            catch
            end
    end 
    GreiferPos(runROS(),20); % Greifer offen
else 
    lauschen=1;
    while lauschen == 1
        disp('Ist Master in Ubergabe?')
            try
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data==ubergabe_int
                   lauschen = 0;
               end

            catch
            end
    end 
    GreiferPos(runROS(),0); % Greifer schließen
end


safe_rot = [pi/4 0 0 0 0];
GelenkPos(runROS,uebergabe+safe_rot); %voruebergabe position



if master == 1
    GelenkPos(runROS,[0, 0, 0, 0, 0]);
else 
    GelenkPos(runROS,[-0.1877 ,  -0.7055 ,  -0.6348 ,  -1.8013   ,      0]); %ablage mit sicherheit
    GelenkPos(runROS,[ -0.1876 ,  -0.6757 ,  -0.9024 ,  -1.5635 ,0]);
    GreiferPos(runROS(),20); % Greifer offen
    GelenkPos(runROS,[-0.1877 ,  -0.7055 ,  -0.6348 ,  -1.8013   ,      0]); %ablage mit sicherheit
    GelenkPos(runROS,[0, 0, 0, 0, 0]);
end

         
