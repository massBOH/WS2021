% RSY 2020/21
% T. Thuilot und A. Heid

% berechnet die inverse Kinematik für die Bewegung zur Zielposition


function theta = inverse_youbot_real(target_)


    % Linklängen, Offsets und Zielpositionen
    DH_array = [  33, pi/2,   147, 0;
                 155,    0,     0, 0;
                 135,    0,     0, 0;
                   0, pi/2,     0, 0;
                   0,    0, 217.5, 0
               ];

    x = target_(1);
    y = target_(2);
    z = target_(3);
    psi = target_(4);

    a1 = DH_array(1,3); 
    a2 = DH_array(2,1);
    a3 = DH_array(3,1);
    a4 = DH_array(5,3);
    d1 = DH_array(1,1);

    % Ziel in XY-Ebene
    d = sqrt(x^2+y^2);
    
    % Ziel in Z minus Laenge Joint1
    zd = z - a1;
    
    % Winkel Joint1
    % mit atan2 und nicht acos(x/d) wegen Vorzeichen
    theta1 = atan2(y,x);
    
    if(abs(theta1)<deg2rad(160)) % ?
    
        % Ziel in XY-Ebene minus Offset Joint1
        rd = d - d1;
        
        % Ziel Joint4 XY
        r4 = rd - a4 *cos(psi);
        
        % Ziel Joint4 Z
        z4 = zd + a4 *sin(psi);
        
        % Strecke zwischen Joint2 und Joint4
        s = sqrt(z4^2 + r4^2);
        
        % Winkel zur Strecke Joint2 und Joint4
        alpha = atan2(z4,r4);
        
        % Gegenwinkel Joint3
        % Cosinussatz mit s = b, a2 = a, a3 = c
        % s^2 = a2^2 + a3^2 - 2 * a2 * a3 * cos(beta)
        beta = acos((-s^2 + a2^2 + a3^2)/(2*a2*a3));
        
        % Winkel Joint3
        theta3 = -(beta - pi);
        
        % Winkel Joint2
        % Sinussatz s/sin(beta) = a3/sin(epsilon)
        % epsilon = asin(sin(beta)*a3/s);
        theta2 = pi/2 -(alpha + asin((sin(beta)*a3)/s));
        
        % Winkel Joint4
        theta4 = (psi - theta2 - theta3 + pi/2);
        
        % Winkel Joint5
        theta5 = target_(5);
    else % ?
        
        % Ziel in XY-Ebene plus Offset Joint1
        rd = d + d1;
        if(theta1>0) % ?
            theta1 = theta1 - pi;
        else % ?
            theta1 = theta1 + pi;
        end
        
        % Ziel Joint4 XY
        r4 = rd - a4*cos(psi);
    
        % Ziel Joint4 Z
        z4 = zd - a4*sin(psi);
    
        % Strecke zwischen Joint2 und Joint4
        s = sqrt(r4^2 + z4^2);
    
        % Winkel zur Strecke Joint2 und Joint4
        alpha = atan2(z4,r4);
    
        % Gegenwinkel Joint3
        beta = acos((-s^2 + a2^2 + a3^2)/(2*a2*a3));
    
        % Berechnung der Winkel
        theta3 = -(beta - pi);
        theta2 = pi/2 -(alpha + asin((sin(beta)*a3)/s));
        % psi = 0 = -theta2 - theata3 - theta4 + pi/2
        theta4 = -(psi + theta2 + theta3 - (pi/2));
        theta5 = target_(5);  
        theta3 = -theta3;
        theta2 = -theta2;
        theta4 = -theta4;
        
        
    end
        
    % Winkel als Vektor
    theta = [ theta1 theta2 theta3 theta4 theta5 ];
end

