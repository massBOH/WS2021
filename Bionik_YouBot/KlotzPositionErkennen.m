% RSY 2020/21
% T. Thuilot und A. Heid

% Erkennt die Position des Klotzes auf der Ablagefläche des youbots


function [klotz_arr_]  = KlotzPositionErkennen()

GelenkPos(runROS,[170, 0, 0, 0, 0.296]); % Position zum Erkennen des Klotzes
GreiferPos(runROS(),20); % Greifer offen

for i = 1:5 % mehrmals versuchen den Kreis auf dem Klotz zu erkennen
    disp("versuch:")
    disp(i)
    PaketPos_YB2 = []; % Vektor der Position des Klotzes
    PaketPos_YB2 = KreisErkennung(runROS,'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild'); % es wird versucht einen weißen Kreis zu erkennen 
    if  ~isempty(PaketPos_YB2.X) % wenn Vektor nicht leer ist
        disp("Würfel erkannt :)")
     
        disp(PaketPos_YB2); % erkannte Position des Klotzes
        
        % X, Y, Z Koordinaten des Klotzes plus Korrekturoffsets und X, Y
        % vertauscht
      
        PunktZuGreiferX = -PaketPos_YB2.Y - 47;
        PunktZuGreiferY = -PaketPos_YB2.X + 3;
        PunktZuGreiferZ = PaketPos_YB2.Z;

        z_sicherheit = 30; % Sicherheitsabstand
        inverse = inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ+z_sicherheit -pi/2 0]); % Vorgreifposition
        end_inverse = inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ -pi/2 0]); % Greifposition

        
        % Abfrage nach Winkelüberschreitungen bei der Vorgreifposition
        if(abs(inverse(2))>deg2rad(160))
            input("ueberschritt in theta 2, bitte Würfel verschieben!") 
            continue

        end
        if(abs(inverse(3)>deg2rad(100)))
            input("ueberschritt in theta 3, bitte Würfel verschieben!") 
            continue

        end
        if(abs(inverse(3)<deg2rad(-75)))
            input("unterschritt in theta 3, bitte Würfel verschieben!")
            continue

        end
        if(abs(inverse(4))>deg2rad(105))
            disp(rad2deg(inverse(4)))
            input('ueberschritt in theta 4, bitte Würfel verschieben!')  
            continue

        end
        klotz_arr_ = [inverse end_inverse]; % Array besteht aus Vorgreifposition und Greifposition
     
        break
    end
    
    
    
   klotz_arr_ = NaN; % wenn kein Klotz gefunden wurde
end
end
