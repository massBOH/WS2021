clear all;
createSerialLink_ZeroModify;
%Darstellung Verbindungsvektor linear

p0 = [346 150 308]; % Startpunkt
p1 = [300 150 358]; % Endpunkt
gerade = p1-p0;

%Berechnung der Stützpunkte
a = 0 : 0.01 : 1; % a von 0 bis 1 in 0.01 Schritten
a = transpose(a);
Y = p0 + a*gerade;