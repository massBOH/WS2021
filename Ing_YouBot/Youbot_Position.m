
%function Y_Pos = Youbot_Position()

%GelenkPos(runROS(),[0 0 0 deg2rad(-30) 0]);


x = 110; %Abstand Marker zu Base

Pos_Y=KreisErkennung(runROS, 'w','1',19,'Bild','Sens',0.8);
disp(Pos_Y);

YB21 = Pos_Y(1);
YB22 = Pos_Y(2);

YB21_vektor = [YB21.Y+280; YB21.X; YB21.Z+175];
YB22_vektor = [YB22.Y+280; YB22.X; YB22.Z+175];

alpha_1 = -atan2(((YB21_vektor(2)+YB22_vektor(2))/2),((YB21_vektor(1)+YB22_vektor(1))/2));
alp = rad2deg(alpha_1);

a = (1/2*norm(YB21_vektor-YB22_vektor));
b = (norm(YB21_vektor));
c = (1/2*norm(YB21_vektor+YB22_vektor));


alpha_2 = -(acos((a^2+c^2-b^2)/(2*a*c)) - pi/2);
alph = rad2deg(alpha_2);


r = sqrt(c^2+x^2-2*x*c*cos(pi-abs(alpha_2)));
alpha = asin(x/r*(sin(pi-abs(alpha_2))));

%Y_Pos=[r alpha];


                                                                                                    

