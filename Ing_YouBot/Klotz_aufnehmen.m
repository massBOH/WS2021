% Anfahren Kameraposition
GelenkPos(ros,camera_klotzPos);

% Klotzposition bestimmen
klotzPos=Klotz_Position();

% Hoehenoffsets
zPre = 5
zPick = -20

% Inverskinematik der Positionen
prePickup = Inverskinematik([klotzPos(1) klotzPos(2) klotzPos(3)+zPre -pi/2 0]);
pickup = Inverskinematik([klotzPos(1) klotzPos(2) klotzPos(3)+zPick -pi/2 0]);

% Pruefung IK gueltig
if Winkelbegrenzung(prePickup)
    if Winkelbegrenzung(pickup)
        % Anfahren Kerze
        GelenkPos(ros,kerzePos);
        % Anfahren prePickup
        GelenkPos(ros,prePickup);
        % Trajektorie Pickup
        GelenkPos(ros,pickup);
        GreiferPos(ros, 0);
        % Trajektorie prePickup
        GelenkPos(ros,prePickup);
        % Anfahren Kerze
        GelenkPos(ros,kerzePos);
    else
        error('Winkelbegrenzung pickup überschritten');
    end
else
    error('Winkelbegrenzung prePick überschritten');
end