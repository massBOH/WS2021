function Trajektorien_Youbot(ROS, Punkte, Theta_5)
    %Einlesen Startpunkt - Endpunkt

    p1 = [Punkte(1,1) Punkte(1,2) Punkte(1,3)];
    p2 = [Punkte(2,1) Punkte(2,2) Punkte(2,3)];

    P=[p1; p2];

    %Berechnung der Stützpunkte
    a = 0 : 0.25 : 1;
    a = transpose(a);
    steps=size(a);
    n=size(P);
    for i=1:n-1
        X = a*[P(i+1, :)-P(i,:)]+P(i,:);
        Trajec_Array(:,:,i)=X;
    end

    for z=1:n-1
        for s =1:steps
            Arbeitsraum_fertig([Trajec_Array(s,1,z) Trajec_Array(s,2,z) Trajec_Array(s,3,z) 0 Theta_5]);
            Winkel=Inverskinematik_fertig([Trajec_Array(s,1,z) Trajec_Array(s,2,z) Trajec_Array(s,3,z) 0 Theta_5]);
            GelenkPos(ROS,Winkel);
            pause(0.1);
        end
    end
end