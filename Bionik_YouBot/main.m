% RSY 2020/21
% T. Thuilot und A. Heid

% Main Funktion
% zusätzlich zu starten sind:
% roscore
% roslaunch youbot_driver_ros_interface youbot_driver.launch            % Hardware
% roslaunch astra_launch astra.launch                                   % Tiefenkamera
% /usr/local/MATLAB/R2018b/bin/matlab -nodesktop -nosplash -r Hermes    % Datenaustausch


% Initialisieren von ROS
rosshutdown

rosinit

% Variablen definieren
active_int      = 1; % ist youbot bereit?
master_int      = 2; % ist youbot master?
ubergabe_int    = 4; % ist youbot in erwarteter Position ?
gripperz_int    = 8; % default = zu

% publisher und subscriber festlegen
Publisher = rospublisher('/YB1','std_msgs/Byte'); % Publisher für Hermes
Nachricht = rosmessage(Publisher);%Nachricht initialisieren
Subscriber = rossubscriber('/YB2','std_msgs/Byte'); % Subscriber für Hermes

% check if ready
lauschen = 1;
while lauschen == 1
        Nachricht.Data = active_int;
        send(Publisher,Nachricht);
        disp("bereit und warte")
        
        try
           NaYB2 = receive(Subscriber, 0.1);
           if NaYB2.Data == active_int
               lauschen = 0;
           end

        catch
        end
end


disp('Beide Bots bereit')
master = 2;

% wird ein Klotz erkannt?
while master == 2
    klotz_arr_ = KlotzPositionErkennen(); % versuchen einen Klotz zu erkennen
    disp(klotz_arr_)
    if isnan(klotz_arr_) % wenn kein Klotz erkannt wurde
            disp('gibts master?')
            try
               NaYB2 = receive(Subscriber, 0.1); % lauschen, ob anderer Youbot master ist
               if NaYB2.Data == master_int % wenn anderer youbot Master ist, sind wir slave
                   master = 0;
                    disp("slave")
                    GreiferPos(runROS(),20); % Greifer offen
               end

            catch
                continue
            end
        
    else % wenn ein Klotz gefunden wurde

        master = 1; % wir sind master
        Nachricht.Data = master_int;
        send(Publisher,Nachricht); % Nachricht wird an anderen youbot gesendet
        KlotzPositionAnfahren(klotz_arr_); % KLotz wird angefahren und aufgenommen
        disp("master")
    
    end
    
   
end


for i = 1:20 % mehrmals versuchen anderen youbot zu erkennen
    try
        erkannte_uebergabe = 0;
        erkannte_uebergabe = ubergabe_erkennung(); % versuchen anderen youbot zu erkennen 
        if erkannte_uebergabe ~= 0 % wenn die Position des anderen youbots erkannt wurde
         break
        end
    catch
        disp("LICHT") % anderer youbot wird häufig nicht erkannt, weil es zu wenig Licht gibt
        continue
    end

end

% (vor-)übergabe Positionen festlegen
uebergabeX    = erkannte_uebergabe(1);
uebergabeY    = erkannte_uebergabe(2);
uebergabeZ    = erkannte_uebergabe(3);
voruebergabeX = erkannte_uebergabe(4);
voruebergabeY = erkannte_uebergabe(5);
voruebergabeZ = erkannte_uebergabe(3);

% Greifer horizontal oder vertikal drehen je nach master oder slave
if master == 1
    theta5 = pi/2;
    
    Nachricht.Data = master_int;
    send(Publisher,Nachricht);

    
else 
    theta5 = 0;
end

% inverse Kinematik für (vor-)übergabe Positionen berechnen
voruebergabe = inverse_youbot_real([voruebergabeX voruebergabeY voruebergabeZ 0 theta5]); 
uebergabe = inverse_youbot_real([uebergabeX uebergabeY uebergabeZ 0 theta5]); 

GelenkPos(runROS,voruebergabe); %voruebergabe position

% wenn master -> warte das slave in der Übergabeposition ist
if master ==1
    lauschen = 1;
    while lauschen == 1
            disp('Ist Slave in Ubergabe?')
            try
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data == ubergabe_int
                   lauschen = 0;
               end

            catch
            end
    end
    
end

GelenkPos(runROS,uebergabe); % Übergabeposition

% wenn slave -> sende das Übergabeposition erreicht
if master == 0
   Nachricht.Data = ubergabe_int;
   send(Publisher,Nachricht); 
end


if master == 1
    lauschen = 1;
    while lauschen == 1 % wartet das slave den Greifer schließt
            disp('Ist der Gripper von Slave zu?')
            try
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data == gripperz_int
                   lauschen = 0;
               end

            catch
            end
    end 
    GreiferPos(runROS(),20); % Greifer offen
else  % wenn slave, wartet, dass mater 
    lauschen = 1;
    while lauschen == 1
        disp('Ist Master in Ubergabe?')
            try
               Nachricht.Data = ubergabe_int;
               send(Publisher,Nachricht);
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data == ubergabe_int
                   Nachricht.Data = 32;
                   send(Publisher,Nachricht);
                   lauschen = 0;
               end

            catch
            end
    end 
    GreiferPos(runROS(),0); % Greifer schließen
    % noch warten auf geöffneten Greifer des Masters
    lauschen = 1;
    while lauschen == 1
        disp('Ist Greifer von Master offen?')
            try
               NaYB2 = receive(Subscriber, 0.1);
               if NaYB2.Data == gripperz_int
                   lauschen = 0;
               end

            catch
            end
    end 
    
    
end

% aus Übergabeposition mit Sicherheitsrotation bewegen
safe_rot = [pi/4 0 0 0 0];
GelenkPos(runROS,uebergabe+safe_rot); % Voruebergabe position



if master == 1
    GelenkPos(runROS,[0, 0, 0, 0, 0]); % wenn slave, in Kerzenposition
else 
    GelenkPos(runROS,[-0.1877 ,  -0.7055 ,  -0.6348 ,  -1.8013   ,      0]); % Ablage mit Sicherheit
    GelenkPos(runROS,[ -0.1876 ,  -0.6757 ,  -0.9024 ,  -1.5635 ,0]); % Ablageposition für den Klotz
    GreiferPos(runROS(),20); % Greifer offen
    GelenkPos(runROS,[-0.1877 ,  -0.7055 ,  -0.6348 ,  -1.8013   ,      0]); % Ablage mit Sicherheit
    GelenkPos(runROS,[0, 0, 0, 0, 0]); % Kerze
end

         
