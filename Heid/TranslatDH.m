% tranlation Vorwärtskinematik

clear all

syms theta1 alpha1 d1 a1 

TrZAxShift1=[
1,  0,  0,  0;
0,  1,  0,  0;
0,  0   1,  d1;
0,  0,  0,  1
]

RotZLink1=[
cos(theta1), -sin(theta1),  0,    0;
sin(theta1),  cos(theta1),  0,    0;
0,          0,            1,    0;
0,          0,            0,    1
]


TrXArmLen1=[
1, 0,  0,  a1;
0,  1,  0,  0;
0,  0   1,  0;
0,  0,  0,  1
]

RotXAxShift1=[
1,            0,          0 ,   0 ;
0,   cos(alpha1), -sin(alpha1),    0;
0,   sin(alpha1),  cos(alpha1),    0;
0,            0,           0,   1
]

DH1 = RotZLink1 * TrZAxShift1 * TrXArmLen1 *RotXAxShift1

%*********************************************
%LINK2
syms theta2 alpha2 d2 a2 

TrZAxShift2=[
1,  0,  0,  0;
0,  1,  0,  0;
0,  0   1,  d2;
0,  0,  0,  1
]

RotZLink2=[
cos(theta2), -sin(theta2),  0,    0;
sin(theta2),  cos(theta2),  0,    0;
0,          0,            1,    0;
0,          0,            0,    1
]


TrXArmLen2=[
1, 0,  0,  a2;
0,  1,  0,  0;
0,  0   1,  0;
0,  0,  0,  1
]

RotXAxShift2=[
1,            0,            0,     0 ;
0,   cos(alpha2), -sin(alpha2),    0;
0,   sin(alpha2),  cos(alpha2),    0;
0,            0,           0,      1
]

DH2 = RotZLink2 * TrZAxShift2 * TrXArmLen2 *RotXAxShift2

%*********************************************
%LINK3
syms theta3 alpha3 d3 a3 

TrZAxShift3=[
1,  0,  0,  0;
0,  1,  0,  0;
0,  0   1,  d3;
0,  0,  0,  1
]

RotZLink3=[
cos(theta3), -sin(theta3),  0,    0;
sin(theta3),  cos(theta3),  0,    0;
0,          0,            1,    0;
0,          0,            0,    1
]


TrXArmLen3=[
1, 0,  0,  a3;
0,  1,  0,  0;
0,  0   1,  0;
0,  0,  0,  1
]

RotXAxShift3=[
1,            0,          0 ,   0 ;
0,   cos(alpha3), -sin(alpha3),    0;
0,   sin(alpha3),  cos(alpha3),    0;
0,            0,           0,   1
]

DH3 = RotZLink3 * TrZAxShift3 * TrXArmLen3 *RotXAxShift3

%*********************************************
%LINK4
syms theta4 alpha4 d4 a4 

TrZAxShift4=[
1,  0,  0,  0;
0,  1,  0,  0;
0,  0   1,  d4;
0,  0,  0,  1
]

RotZLink4=[
cos(theta4), -sin(theta4),  0,    0;
sin(theta4),  cos(theta4),  0,    0;
0,          0,            1,    0;
0,          0,            0,    1
]


TrXArmLen4=[
1, 0,  0,  a4;
0,  1,  0,  0;
0,  0   1,  0;
0,  0,  0,  1
]

RotXAxShift4=[
1,            0,          0 ,   0 ;
0,   cos(alpha4), -sin(alpha4),    0;
0,   sin(alpha4),  cos(alpha4),    0;
0,            0,           0,   1
]

DH4 = RotZLink4 * TrZAxShift4 * TrXArmLen4 *RotXAxShift4

%*********************************************
%LINK5
syms theta5 alpha5 d5 a5 

TrZAxShift5=[
1,  0,  0,  0;
0,  1,  0,  0;
0,  0   1,  d5;
0,  0,  0,  1
]

RotZLink5=[
cos(theta5), -sin(theta5),  0,    0;
sin(theta5),  cos(theta5),  0,    0;
0,          0,            1,    0;
0,          0,            0,    1
]


TrXArmLen5=[
1, 0,  0,  a5;
0,  1,  0,  0;
0,  0   1,  0;
0,  0,  0,  1
]

RotXAxShift5=[
1,            0,          0 ,   0 ;
0,   cos(alpha5), -sin(alpha5),    0;
0,   sin(alpha5),  cos(alpha5),    0;
0,            0,           0,   1
]

DH5 = RotZLink5 * TrZAxShift5 * TrXArmLen5 *RotXAxShift5

DHall = DH1*DH2*DH3*DH4*DH5

%DH-Params KUKA youbot
alpha1 = pi/2
a1 = 33
d1=147
theta1 = 0

alpha2 = 0
d2 = 0
a2 = 155
theta2 = pi/2

alpha3 =0
d3 = 0
a3=135
theta3 = 0

alpha4 = pi/2
d4 = 0
a4 = 0
theta4 = pi/2

alpha5 = 0
d5 = 217.5
a5 = 0
theta5 =0 

    
%vgl. berechnete Koordinate und die 
pos = subs(DHall);
%rückgerechnete Inverse mit 
%http://www.youbot-store.com/wiki/index.php/YouBot_Detailed_Specifications

direction=subs(DH1*DH2*DH3*DH4)
EEDirection=direction(1:3,4)

RotAll = pos(1:3,1:3)
PosAll = pos(1:3,4)
PosOfBase = RotAll*PosAll
double(direction)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Gradengleichungen
pos1=subs(DH1);
pos2=subs(DH1*DH2);
pos3=subs(DH1*DH2*DH3);
pos4=subs(DH1*DH2*DH3*DH4);
pos5=subs(DH1*DH2*DH3*DH4*DH5);
P1 = pos1(1:3,4);
P2 = pos2(1:3,4);
P3 = pos3(1:3,4);
P4 = pos4(1:3,4);
P5 = pos5(1:3,4);

X1 = P1 + a1 * (0-P1);
X2 = P2 + a2 * (P1-P2);
X3 = P3 + a3 * (P2-P3);
X4 = P4 + a4 * (P3-P4);
X5 = P5 + a5 * (P4-P5);

%für jedes Xn(a) norm(Xn(a) - POS) testen auf >20!