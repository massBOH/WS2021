
clear all

GelenkPos(runROS,[170, 0, 0, 0, 17]);

PaketPos_YB2 = KreisErkennung(runROS,'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild');

disp(PaketPos_YB2);

PunktZuGreiferX = PaketPos_YB2.Y;
PunktZuGreiferY = PaketPos_YB2.X - 6.5;
PunktZuGreiferZ = PaketPos_YB2.Z + 10;

inverse_youbot_real([PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ 0 0])



%KoordinatenTransKameraYoubot(94, 223, 42, 0.27)
