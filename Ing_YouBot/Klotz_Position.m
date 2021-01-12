%Ausgabe der Klotzposition für das Koordinatensystem des Armes

function k_Pos = Klotz_Position()

    PaketPos_YB1=KreisErkennung(runROS, 'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild');

    disp(PaketPos_YB1);

    PunktZuGreiferX = -PaketPos_YB1.Y-5;
    PunktZuGreiferY = PaketPos_YB1.X+10 ;
    PunktZuGreiferZ = PaketPos_YB1.Z + 10;

    k_Pos=[PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ 0 0];
end