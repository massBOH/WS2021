clear all;
createSerialLink_ZeroModify()
% Darstellung Haus vom Nikolaus 50x50

CP = [361 0 302]; % Mittelpunkt
p1 = [361 25 277]; % links unten
p2 = [361 -25 277]; % rechts unten
p3 = [361 -25 327]; % rechts oben
p4 = [361 25 327]; % links oben
p5 = [361 0 387]; % Dachspitze

% Route
reihenfolge = [CP; p1; p2; p3; p1; p4; p3; p5; p4];

% einzelne Linien
gerade0 = p1-CP;
gerade1 = p2-p1;
gerade2 = p3-p2;
gerade3 = p1-p3;
gerade4 = p4-p1;
gerade5 = p3-p4;
gerade6 = p5-p3;
gerade7 = p4-p5;
gerade8 = p2-p4;

% Berechnung der Stützpunkte
a = 0 : 0.1 : 1; % a von 0 bis 1 in 0.01 Schritten
a = transpose(a);

% Wege
Y0 = CP + a*gerade0;
Y1 = p1 + a*gerade1;
Y2 = p2 + a*gerade2;
Y3 = p3 + a*gerade3;
Y4 = p1 + a*gerade4;
Y5 = p4 + a*gerade5;
Y6 = p3 + a*gerade6;
Y7 = p5 + a*gerade7;
Y8 = p4 + a*gerade8;

% Pause zwischen Wegen
pause_ = 0.01;

% Inverse Kinematik und Plot
for i = 1:11
    target = PositionBestimmen([Y0(i,1) Y0(i,2) Y0(i,3) 0 0]);
    Arbeitsraum([Y0(i,1) Y0(i,2) Y0(i,3) 0 0]);
    PunktGeradeAbstand([Y0(i,1) Y0(i,2) Y0(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y1(i,1) Y1(i,2) Y1(i,3) 0 0]);
    Arbeitsraum([Y1(i,1) Y1(i,2) Y1(i,3) 0 0]);
    PunktGeradeAbstand([Y1(i,1) Y1(i,2) Y1(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y2(i,1) Y2(i,2) Y2(i,3) 0 0]);
    Arbeitsraum([Y2(i,1) Y2(i,2) Y2(i,3) 0 0]);
    PunktGeradeAbstand([Y2(i,1) Y2(i,2) Y2(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y3(i,1) Y3(i,2) Y3(i,3) 0 0]);
    Arbeitsraum([Y3(i,1) Y3(i,2) Y3(i,3) 0 0]);
    PunktGeradeAbstand([Y3(i,1) Y3(i,2) Y3(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y4(i,1) Y4(i,2) Y4(i,3) 0 0]);
    Arbeitsraum([Y4(i,1) Y4(i,2) Y4(i,3) 0 0]);
    PunktGeradeAbstand([Y4(i,1) Y4(i,2) Y4(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y5(i,1) Y5(i,2) Y5(i,3) 0 0]);
    Arbeitsraum([Y5(i,1) Y5(i,2) Y5(i,3) 0 0]);
    PunktGeradeAbstand([Y5(i,1) Y5(i,2) Y5(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y6(i,1) Y6(i,2) Y6(i,3) 0 0]);
    Arbeitsraum([Y6(i,1) Y6(i,2) Y6(i,3) 0 0]);
    PunktGeradeAbstand([Y6(i,1) Y6(i,2) Y6(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y7(i,1) Y7(i,2) Y7(i,3) 0 0]);
    Arbeitsraum([Y7(i,1) Y7(i,2) Y7(i,3) 0 0]);
    PunktGeradeAbstand([Y7(i,1) Y7(i,2) Y7(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
for i = 1:11
    target = PositionBestimmen([Y8(i,1) Y8(i,2) Y8(i,3) 0 0]);
    Arbeitsraum([Y8(i,1) Y8(i,2) Y8(i,3) 0 0]);
    PunktGeradeAbstand([Y8(i,1) Y8(i,2) Y8(i,3) 0 0]);
    YouBot.plot(target);
    pause(pause_);
end
