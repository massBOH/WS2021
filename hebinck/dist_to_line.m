% RoboterSysteme WS2020/21
% dist_to_line
% 01.12.2020 Gerald Hebinck
% takes vector r and target, both with x and y part
% calculates abs distance of a target to a line perpendicular to r
% returns -1 if target is behind the line else the distance

function retval = dist_to_line(r, target)

    r_halbe = r / 2;
    r_inv = [r_halbe(2); r_halbe(1)];

    % Geradengleichungen
    % a = r_halbe + eps * r_inv
    % b = eecp_ebene + mue * r_halbe

    % gleichsetzen fuer Schnittpunkt
    % r_halbe + eps * r_inv = eecp_ebene + mue * r_halbe
    % mue * r - eps * r_inv = r_halbe - eecp_ebene

    % Vektorschreibweise
    % (r(1) * mue - r_inv(1) * eps) = (r_halbe(1) - eecp_ebene(1))
    % (r(2) * mue - r_inv(2) * eps) = (r_halbe(2) - eecp_ebene(2))

    % Umstellen zu Matrix x Vektor
    %           A      *  c   =             b
    % (r(1)  -r_inv(1)) (mue) = (r_halbe(1) - eecp_ebene(1))
    % (r(2)  -r_inv(2)) (eps) = (r_halbe(2) - eecp_ebene(2))

    % Umstellen mit inverser Matrix
    % (mue) = A^-1 (r_halbe(1) - eecp_ebene(1))
    % (eps)        (r_halbe(2) - eecp_ebene(2))
    A = [r(1) -r_inv(1); r(2) -r_inv(2)];
    b = [r_halbe(1)-target(1); r_halbe(2)-target(2)];
    c = A\b

    % Abstand s = mue * r
    mue = c(1);
    % Sanitycheck mue > 0
    if (mue < 0)
        retval = -1;
    else
        s = mue * r;
        retval = sqrt(s(1)^2+s(2)^2);
    end
end


