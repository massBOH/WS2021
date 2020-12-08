clear all;
createSerialLink_ZeroModify;
%Darstellung Kreisbahn

p0 = [346 150 308]; % Startpunkt
R = 80; % Radius
p1 = [300 150 358]; % Endpunkt

%Berechnung der Stützpunkte
a = 0 : 0.01 : 1; % a von 0 bis 1 in 0.01 Schritten
a = transpose(a);
Y = a * p0;
for c = 1:101
    Y(c,1) = p0(1);
    Y(c,2) = p0(2)+R*cos(2*pi*a(c));
    Y(c,3) = p0(3)+R*sin(2*pi*a(c));
end
