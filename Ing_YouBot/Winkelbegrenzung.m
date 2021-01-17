% Funktion Winkelbegrenzung
% prueft, ob die Winkel innerhalb der min/max-Werte liegen
% return 0 = false, 1 = true

function winkel_test = Winkelbegrenzung(winkel)

    % Rueckgabewert
    winkel_test = 0;

    % Aus runROS()
    JointMin=[-169 -65 -151 -102 -167];
    JointMax=[169 90 146 102 167];
    % Angabe Veranstaltung
    % JointMin=[-170 -65 -150 -95 -167];
    % JointMax=[170 90 150 95 167];
    % min/max-Werte YouBot
    theta1_min = deg2rad(JointMin(1)); 
    theta1_max = deg2rad(JointMax(1));
    theta2_min = deg2rad(JointMin(2));
    theta2_max = deg2rad(JointMax(2));
    theta3_min = deg2rad(JointMin(3));
    theta3_max = deg2rad(JointMax(3));
    theta4_min = deg2rad(JointMin(4));
    theta4_max = deg2rad(JointMax(4));

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