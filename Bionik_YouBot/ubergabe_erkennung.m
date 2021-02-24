% RSY 2020/21
% T. Thuilot und A. Heid

% erkennt die Position des anderen YouBots


function [ubergabe_vektor] = ubergabe_erkennung()

GelenkPos(runROS,[0, 0, 0, -pi/9, 0]); % Position zur Erkennung des anderen youbot in rad

YB2_pos = KreisErkennung(runROS,'s','1',19,'Sens',0.8,'Bild'); % versucht schwarze Kreise zu finden
Pos_YB2_1 = YB2_pos(:,1);
Pos_YB2_2 = YB2_pos(:,2);

disp(Pos_YB2_1); % Position Kreis 1
disp(Pos_YB2_2); % Position Kreis 2

x_offset = (475 - 239);

% Punkt in der Mitte der beiden Kreise am anderen YouBot
% X und Y wieder getauscht plus Offset in X
mittelpunkt.Y = (Pos_YB2_1.X + Pos_YB2_2.X)/2;
mittelpunkt.X = ((Pos_YB2_1.Y + Pos_YB2_2.Y)/2) + x_offset;
mittelpunkt.Z = (Pos_YB2_1.Z + Pos_YB2_2.Z)/2;
disp(mittelpunkt);

alpha1 = atan(mittelpunkt.Y/mittelpunkt.X); % Winkel, vom Centerpoint des ersten zum Mittelpunkt des zweiten youbots

betrag_YB2_1 = sqrt(Pos_YB2_1.X^2 + (Pos_YB2_1.Y+x_offset)^2); % Betrag zum Quadrat des Vektors der Position des ersten Kreises des anderen YouBots
% betrag_YB2_2 = sqrt(Pos_YB2_2.X^2 + (Pos_YB2_2.Y+x_offset)^2);

% Kosinussatz zur Berechnung von alpha2
b = (betrag_YB2_1); % Hypotenuse

c = 0.5 * sqrt((Pos_YB2_1.X - Pos_YB2_2.X)^2 + (Pos_YB2_1.Y - Pos_YB2_2.Y)^2); % Kathete

a = 0.5 * sqrt((Pos_YB2_1.X + Pos_YB2_2.X)^2 + (Pos_YB2_1.Y+x_offset + Pos_YB2_2.Y+x_offset)^2); % Kathete

alpha2 = -(-pi/2 + (acos( (-b^2 + c^2 + a^2)/(-(2*a*c))))); % (in rad) Winkel, im Mittelpunkt des anderen Youbots zum Verbindungsvektor r der beiden YouBots


offset_base = 110; % Offset zum Centerpoint
YB2BaseCPX = mittelpunkt.X + offset_base*cos(alpha2); % Centerpoint X anderer YouBot
YB2BaseCPY = mittelpunkt.Y + offset_base*sin(alpha2); % Centerpoint Y anderer YouBot
r = norm([YB2BaseCPX YB2BaseCPY]); % Länge von Verbindungsvektor r 
phi = asin(offset_base/r*(sin(pi-abs(alpha2)))) + alpha1; % (in rad) Winkel zwischen den Centerpoints der beiden YouBots (von Verbindungsvektor r)


% Übergabe bei r/2 [X/2 Y/2 HoeheZ]
psi = 0;
uebergabeX = YB2BaseCPX/2;
uebergabeY = YB2BaseCPY/2;
uebergabeZ = HoeheZ(uebergabeX,uebergabeY,psi)*0.9; % Übergabe 10% unter zMax

% Vorübergabposition 
sicherheit = 20;
vorubergabeX = ((r/2)-sicherheit)*cos(phi);
vorubergabeY = ((r/2)-sicherheit)*sin(phi);

ubergabe_vektor = [uebergabeX uebergabeY uebergabeZ vorubergabeX vorubergabeY]; % übergabeZ = vorübergabeZ

end
