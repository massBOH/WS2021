%Main

%ROS-Verbindung initialisieren

%Initialisierungsfahrt in die Kerze
%GelenkPos(runROS(),[0 0 0 0 0]);

%Greifer öffnen
%GreiferPos(runROS(), 20);

%Position des anderen Youbots messen
%Youbot_Pos=Youbot_Position()

%Festlegung, ob dieser Youbot übergibt oder übernimmt
%Geber=0/1; %Geber=1 -> dieser Youbot übergibt
            %Geber=0 -> dieser Youbot übernimmt

%Position des Klotzes messen und anfahren, falls dieser Youbot übergibt
%if Geber==1
    %Klotz_aufnehmen;
    %end
    
%Position vor der Übergabe bestimmen
%psi=0;
%x_Vorgabe=(Youbot_Pos(1)/2-20)*cos(Youbot_Pos(2));
%y_Vorgabe=(Youbot_Pos(1)/2-20)*sin(Youbot_Pos(2));
%z_Vorgabe=Berechnung_Z(x_Vorgabe,y_Vorgabe,psi);

%falls dieser Youbot den Klotz annimmt, muss Theta 5 angepasst werden
%if Geber==1
        %Theta_5=0; 
%else if Geber==0
        %Theta_5=pi/2;
%end

%Vorgabeposition anfahren
%Winkel_Vorgabe=Inverskinematik([x_Vorgabe y_Vorgabe z_Vorgabe 0 Theta_5]);
%Sicherheitsabstand prüfen
%GelenkPos(runROS(),Winkel_Vorgabe);

%Übergabeposition bestimmen
%x_Uebergabe=(Youbot_Pos(1)/2)*cos(Youbot_Pos(2));
%y_Uebergabe=(Youbot_Pos(1)/2)*sin(Youbot_Pos(2));
%z_Uebergabe=Berechnung_Z(x_Uebergabe,y_Uebergabe,psi);
%Trajektorien_Youbot([x_Vorgabe, y_Vorgabe, z_Uebergabe; x_Uebergabe, y_Uebergabe, z_Uebergabe],Theta_5);

%falls dieser Youbot den Klotz annimmt, muss Theta 5 angepasst werden
%if Geber==1
        %Theta_5=0;
%else if Geber==0
        %Theta_5=pi/2;
%end

%Übergabeposition anfahren
%Trajektorien_Youbot([x_Uebergabe, y_Uebergabe, z_Uebergabe; x_Vorgabe, y_Vorgabe, z_Uebergabe],Theta_5);

%Klotz übernehmen/übergeben
%if Geber==1
    %GreiferPos(runROS(), 20);
%else if Geber==0
    %GreiferPos(runROS(), 0);
%end

%Vorgabeposition anfahren
%Trajektorien_Youbot
%GelenkPos(runROS(),Winkel_Vorgabe);

%disp('Übergabe erfolgreich abgeschlossen')