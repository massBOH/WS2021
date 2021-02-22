%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Funktion Klotz_Position
%
% Ermitteln der Klotz_Position anhand der KreisErkennung
% und Ueberfuehrung der Kamerakoordinaten in das
% Koordinatensystem des Roboters

function k_Pos = Klotz_Position(ROS)

    PaketPos_YB1 = KreisErkennung(ROS, 'w', '1', 20, 52, 'Dtol', 5, 'Atol', 10, 'Sens', 0.7, 'Bild');

    disp(PaketPos_YB1);

    PunktZuGreiferX = -PaketPos_YB1.Y - 5;
    PunktZuGreiferY = PaketPos_YB1.X + 13 ;
    PunktZuGreiferZ = PaketPos_YB1.Z + 10;

    k_Pos = [PunktZuGreiferX PunktZuGreiferY PunktZuGreiferZ 0 0];
end