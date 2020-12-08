% Arbeitsraumabschätzung
function Arbeitsraum(target_)

    a1 = 147; % Laenge Link 1 (Achsversatz z)
    a2 = 155; % Laenge Link 2
    a3 = 135; % Laenge Link 3
    a4 = 217.5; % Laenge Link 4
    d1 = 33; % Achsversatz x
    fehler = 1;
    
    x = target_(1);
    y = target_(2);
    z = target_(3);
    psi = target_(4);
    theta5 = target_(5);

    % außen
    theta2 = acos((z - a1 - a4 * sin(psi))/(a2 + a3));
    theta3 = 0;
    theta4 = (pi/2) - theta2 - psi;
    % r1 = sqrt((z - a1)^2 + x^2 + y^2) + a4*(1 - cos(theta4)) - (d1*sin(theta2));
    r1 = sqrt((sqrt(x^2 + y^2) - a4*cos(psi))^2 + (z - a1 - sin(psi))^2) - (d1*sin(theta2));
    r_max = a2 + a3; % r_max = 290

    % innen
    theta3max = deg2rad(150);
    theta3min = deg2rad(-150);

    a = sqrt(x^2 + y^2) - d1 - cos(psi)*a4;
    b = z - a1 - a4*sin(psi);
    r_min = sqrt(a2^2 + a3^2 - (2*a2*a3*cos(pi - theta3max)));
    r2 = sqrt(a^2 + b^2);

    if (r_max >= r1) && (r_min <= r2)
        fehler = 0;
    elseif (r1 > r_max)
        fehler = 1;
        error("Koordinaten sind außerhalb der Reichweite")
    elseif (r2 < r_min)
        fehler = 1;
        error("Koordinaten sind zu nah")
    end
end