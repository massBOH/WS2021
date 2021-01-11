%Anfahren Kameraposition
GelenkPos(runROS(),[deg2rad(15) 0 0 deg2rad(15) pi]);

%Klotzposition bestimmen und anfahren
Pos=Klotz_Position;
Winkel_1=Inverskinematik_fertig([Pos(1) Pos(2) Pos(3)+10 -pi/2 0]);
GelenkPos(runROS(),Winkel_1);

%Greifen
GreiferPos(runROS(), 20);
Winkel_2=Inverskinematik_fertig([Pos(1) Pos(2) Pos(3)-20 -pi/2 0]);
GelenkPos(runROS(),Winkel_2);
GreiferPos(runROS(), 0);
GelenkPos(runROS(),Winkel_1);
GelenkPos(runROS(),Winkel_2);
GreiferPos(runROS(), 20);