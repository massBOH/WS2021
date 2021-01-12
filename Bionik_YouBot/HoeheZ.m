function z_Koord = HoeheZ(x,y,psi)

a2=155;
a3=135;
a4=217.5;


Theta2=asin((sqrt(x^2+y^2)-33-cos(psi)*a4)/(a2+a3))

z_Koord=147+a4*sin(psi)+(a2+a3)*cos(Theta2)