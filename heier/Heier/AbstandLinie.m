
function abstand = AbstandLinie(r,Koordinaten)

Xr = r(1);
Yr = r(2);
Xcp = Koordinaten(1);
Ycp = Koordinaten(2);

A = [Xr-(Yr/2);Yr-(Xr/2)];
B = [(Xr/2)-Xcp;(Yr/2)-Ycp];
C  = A\B;

mue = C(1);
eps = C(2);

s = mue *[Xr;Yr];
abstand = sqrt(s(1)^2+s(2)^2);

if abstand<10
    error("Kollision mit der Begrenzung");
end

