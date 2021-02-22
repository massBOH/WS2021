%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Funktion Klotz_handling
%
% Anfahren und aufnehmen/ablegen der uebergebenen
% Klotzposition unter Pruefung der Winkelbegrenzungen

function Klotz_handling(ROS, klotzPos, pick)
    kerzePos = [0 0 0 0 0];
    % Hoehenoffsets
    zPre = 5;
    zPick = -20;

    % Inverskinematik der Positionen
    preKlotz = Inverskinematik([klotzPos(1) klotzPos(2) klotzPos(3)+zPre -pi/2 0]);
    Klotz = Inverskinematik([klotzPos(1) klotzPos(2) klotzPos(3)+zPick -pi/2 0]);

    % Pruefung IK gueltig
    if Winkelbegrenzung(preKlotz)
        if Winkelbegrenzung(Klotz)
            % Anfahren Kerze
            GelenkPos(ROS, kerzePos);
            % Anfahren preKlotz
            GelenkPos(ROS, preKlotz);
            % Anfahren Klotz
            GelenkPos(ROS, Klotz);
            if pick
                GreiferPos(ROS, 0);
            else
                GreiferPos(ROS, 20);
            end
            % Anfahren preKlotz
            GelenkPos(ROS, preKlotz);
            % Anfahren Kerze
            GelenkPos(ROS, kerzePos);
        else
            error('Winkelbegrenzung Klotz ueberschritten');
        end
    else
        error('Winkelbegrenzung preKlotz ueberschritten');
    end
end