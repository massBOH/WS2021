%KlotzPositionErkennen
function [klotz_arr_]  = KlotzPositionErkennen()

GelenkPos(runROS,[170, 0, 0, 0, 0.296]); %Erkennung Klotz
GreiferPos(runROS(),20); % Greifer offen
for i = 1:5
    disp("versuch:")
    disp(i)
    PaketPos_YB2 = [];
    PaketPos_YB2 = KreisErkennung(runROS,'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild');
    if  ~isempty(PaketPos_YB2.X)
        disp("Würfel erkannt :)")
     
        disp(PaketPos_YB2);

        PunktZuGreiferX = -PaketPos_YB2.Y-47;
        PunktZuGreiferY = -PaketPos_YB2.X+3;
        PunktZuGreiferZ = PaketPos_YB2.Z;

        z_sicherheit = 30;
        inverse = inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ+z_sicherheit -pi/2 0]); 
        end_inverse = inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ -pi/2 0]);

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
        klotz_arr_ = [inverse end_inverse];
     
        break
    end
    
    %%%% abfrage nach winkelüberschreitung
    
   klotz_arr_ = NaN;
end
end
