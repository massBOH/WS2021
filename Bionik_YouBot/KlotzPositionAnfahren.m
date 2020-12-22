

GelenkPos(runROS,[170, 0, 0, 0, 0.296]);
GreiferPos(runROS(),20);
PaketPos_YB2 = KreisErkennung(runROS,'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild');

disp(PaketPos_YB2);

PunktZuGreiferX = -PaketPos_YB2.Y-43;
PunktZuGreiferY = -PaketPos_YB2.X+3;
PunktZuGreiferZ = PaketPos_YB2.Z;

z_sicherheit = 30;
inverse = inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ+z_sicherheit -pi/2 0]); 



disp(inverse)

GelenkPos(runROS,inverse); %vorgreif position

GelenkPos(runROS,inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ -pi/2 0])); %runter zum greifen

GreiferPos(runROS(),0);

GelenkPos(runROS,inverse); 

GelenkPos(runROS,[0, 0, 0, 0, 0]);
