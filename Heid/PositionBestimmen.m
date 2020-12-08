% Inverse Rückwärtskinematik
function theta = PositionBestimmen(target_)

        x = target_(1);
        y = target_(2);
        z = target_(3);
        psi = target_(4);

        a1 = 147; % Laenge Link 1 (Achsversatz z)
        a2 = 155; % Laenge Link 2
        a3 = 135; % Laenge Link 3
        a4 = 217.5; % Laenge Link 4
        d1 = 33; % Achsversatz x

        d = sqrt(x*x + y*y); % Abstabd Nullpunkt EECP
        rd = d - d1; % Radius ohne Achsversatz
        zd = z - a1; % z ohne Achsversatz

        theta1 = atan2(y, x); % Winkel Joint 1 

        r4 = rd - a4*cos(psi); % Ziel Joint4 XY
        z4 = zd - a4*sin(psi); % Ziel Joint4 Z

        % r4 = a2*cos(theta2) + a3*cos(theta2+theta3);
        % z4 = a2*sin(theta2) + a3*sin(theta2+theta3);

        s = sqrt(r4*r4 + z4*z4); % Abstand Joint 1 und Joint 4
        alpha = atan2(z4, r4); % Winkel zur Strecke Joint2Joint4
        beta = acos((-s*s +a2*a2 +a3*a3)/(2*a2*a3)); % Gegenwinkel Joint3 (Cosinussatz)

        theta3 = beta - pi; % Winkel Joint 3
        epsilon = asin(sin(beta)*a3/s);
        theta2 = alpha + epsilon; % Winkel Joint 2 (Sinussatz)
        theta4 = psi - theta2 - theta3; % Winkel Joint 4
        theta5 = theta1; % Winkel Joint 5
        theta = [ theta1 theta2 theta3 theta4 theta5 ]; % Winkel als Vektor
end
