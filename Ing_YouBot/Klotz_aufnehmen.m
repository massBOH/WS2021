function Klotz_aufnehmen(ROS, klotzPos)
    kerzePos = [0 0 0 0 0];
    % Hoehenfsets
    zPre = 5;
    zPick = -20;

    % Inverskinematik der Positionen
    prePickup = Inverskinematik([klotzPos(1) klotzPos(2) klotzPos(3)+zPre -pi/2 0]);
    pickup = Inverskinematik([klotzPos(1) klotzPos(2) klotzPos(3)+zPick -pi/2 0]);

    % Pruefung IK gueltig
    if Winkelbegrenzung(prePickup)
        if Winkelbegrenzung(pickup)
            % Anfahren Kerze
            GelenkPos(ROS, kerzePos);
            % Anfahren prePickup
            GelenkPos(ROS, prePickup);
            % Trajektorie Pickup
            GelenkPos(ROS, pickup);
            GreiferPos(ROS, 0);
            % Trajektorie prePickup
            GelenkPos(ROS, prePickup);
            % Anfahren Kerze
            GelenkPos(ROS, kerzePos);
        else
            error('Winkelbegrenzung pickup überschritten');
        end
    else
        error('Winkelbegrenzung prePick überschritten');
    end
end