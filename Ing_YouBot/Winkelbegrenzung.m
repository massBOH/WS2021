
function Winkel_test = Winkelbegrenzung(Winkel)

Winkel_test = 0;


theta1_min = deg2rad(-170);
theta1_max = deg2rad(170);
theta2_min = deg2rad(-65);
theta2_max = deg2rad(90);
theta3_min = deg2rad(-150);
theta3_max = deg2rad(150);
theta4_min = deg2rad(-95);
theta4_max = deg2rad(95);



if (Winkel(1)>theta1_min && Winkel(1)<theta1_max)
    if (Winkel(2)>theta2_min && Winkel(2)<theta2_max)
        if (Winkel(3)>theta3_min && Winkel(3)<theta3_max)
            if (Winkel(4)>theta4_min && Winkel(4)<theta4_max)
                Winkel_test=1;
            end
        end
    end
end    