% Funktion Winkelbegrenzung
% prueft, ob die Winkel innerhalb der min/max-Werte liegen
% return 0 = false, 1 = true

function winkel_test = Winkelbegrenzung(winkel)

    % Rueckgabewert
    winkel_test = 0;

    % min/max-Werte YouBot
    theta1_min = deg2rad(-170);
    theta1_max = deg2rad(170);
    theta2_min = deg2rad(-65);
    theta2_max = deg2rad(90);
    theta3_min = deg2rad(-150);
    theta3_max = deg2rad(150);
    theta4_min = deg2rad(-95);
    theta4_max = deg2rad(95);

    if (winkel(1)>=theta1_min && winkel(1)<=theta1_max)
        if (winkel(2)>=theta2_min && winkel(2)<=theta2_max)
            if (winkel(3)>=theta3_min && winkel(3)<=theta3_max)
                if (winkel(4)>=theta4_min && winkel(4)<=theta4_max)
                    winkel_test=1;
                end
            end
        end
    end
end