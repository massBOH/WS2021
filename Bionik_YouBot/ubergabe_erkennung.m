function [ubergabe_vektor] = ubergabe_erkennung()

GelenkPos(runROS,[0, 0, 0, -pi/9, 0]); %erkennung anderer youbot in rad

YB2_pos = KreisErkennung(runROS,'s','1',19,'Sens',0.8,'Bild'); %erkennungspunkte 
Pos_YB2_1 = YB2_pos(:,1);
Pos_YB2_2 = YB2_pos(:,2);

disp(Pos_YB2_1);
disp(Pos_YB2_2);

x_offset = (475 - 239);

mittelpunkt.Y = (Pos_YB2_1.X+Pos_YB2_2.X)/2;
mittelpunkt.X = ((Pos_YB2_1.Y+Pos_YB2_2.Y)/2)+ x_offset;
mittelpunkt.Z = (Pos_YB2_1.Z+Pos_YB2_2.Z)/2;
disp(mittelpunkt);

alpha1 = atan(mittelpunkt.Y/mittelpunkt.X);

betrag_YB2_1 = sqrt(Pos_YB2_1.X^2 + (Pos_YB2_1.Y+x_offset)^2);
betrag_YB2_2 = sqrt(Pos_YB2_2.X^2 + (Pos_YB2_2.Y+x_offset)^2);

 
b = (betrag_YB2_1); %Hypotenuse
c = 0.5 * sqrt((Pos_YB2_1.X - Pos_YB2_2.X)^2 + (Pos_YB2_1.Y - Pos_YB2_2.Y)^2); % Kathete

a = 0.5 * sqrt((Pos_YB2_1.X + Pos_YB2_2.X)^2 + (Pos_YB2_1.Y+x_offset + Pos_YB2_2.Y+x_offset)^2); % Kathete

alpha2 = -(-pi/2 + (acos( (-b^2 + c^2 + a^2)/(-(2*a*c))))); % in rad


offset_base = 110;
YB2BaseCPX = mittelpunkt.X + offset_base*cos(alpha2);
YB2BaseCPY = mittelpunkt.Y + offset_base*sin(alpha2);
r = norm([YB2BaseCPX YB2BaseCPY]);
phi = asin(offset_base/r*(sin(pi-abs(alpha2)))) + alpha1; % in rad phi %muss positiv sein?

psi = 0;
uebergabeX = YB2BaseCPX/2;
uebergabeY = YB2BaseCPY/2;
uebergabeZ = HoeheZ(uebergabeX,uebergabeY,psi)*0.9;

vorubergabeX = ((r/2)-20)*cos(phi);
vorubergabeY = ((r/2)-20)*sin(phi);

ubergabe_vektor = [uebergabeX uebergabeY uebergabeZ vorubergabeX vorubergabeY];

end
