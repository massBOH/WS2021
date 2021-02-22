function z_Koord=Berechnung_Z(x,y,psi)

    LinkOffset_1=33;
    LinkLaenge_2=155;
    LinkLaenge_3=135;
    LinkLaenge_4=217.5;

    Theta_2=asin((sqrt(x^2+y^2)-LinkOffset_1-cos(psi)*LinkLaenge_4)/(LinkLaenge_2+LinkLaenge_3));

    z_Koord=0.9*(147+LinkLaenge_4*sin(psi)+(LinkLaenge_2+LinkLaenge_3)*cos(Theta_2));

end