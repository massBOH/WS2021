
function PunktGeradeAbstand(target_)
    r = [0; 200];
    x_r = r(1);
    y_r = r(2);
    x_cp = target_(1);
    y_cp = target_(2);

    % a = r/2 + e*[y_r/2; x_r/2];
    % b = [x_cp; y_cp] + n*r;

    % [x_r*n-(y_r/2)*e; y_r*n-(x_r/2)*e] = [(x_r/2)-x_cp; (y_r/2)-y_cp];

    A = [x_r -(y_r/2); y_r -(x_r/2)];
    B = A^(-1)*[(x_r/2)-x_cp; (y_r/2)-y_cp];

    n = B(1);
    % e = B(2);

    s = n*r;
    abstand = sqrt(s(1)^2+s(2)^2)
end