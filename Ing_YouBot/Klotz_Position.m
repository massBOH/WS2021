%Ausgabe der Klotzposition für das Koordinatensystem des Armes

function k_Pos = Klotz_Position()

%GelenkPos(runROS,[deg2rad(15) 0 0 deg2rad(15) pi]);

PaketPos_YB1=KreisErkennung(runROS, 'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild');

disp(PaketPos_YB1);

PunktZuGreiferX = -PaketPos_YB1.Y-12;
PunktZuGreiferY = PaketPos_YB1.X -6.5;
PunktZuGreiferZ = PaketPos_YB1.Z + 50;

k_Pos=[PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ 0 0];