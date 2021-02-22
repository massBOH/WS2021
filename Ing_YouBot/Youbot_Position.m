function Y_Pos = Youbot_Position(ROS)

    % Abstand Marker_YB2 zu Base_YB2
    d = 110;

    % Erkennen der Marker auf YB2
    posYB2 = KreisErkennung(ROS, 'w','1',19,'Bild','Sens',0.8);

    % Zerlegen und Umwandeln der Rueckgabe
    posYB21 = posYB2(1);
    posYB21_vektor = [posYB21.Y+280; posYB21.X; posYB21.Z+175];
    posYB22 = posYB2(2);
    posYB22_vektor = [posYB22.Y+280; posYB22.X; posYB22.Z+175];

    % Winkel zwischen Base_YB1 und Marker_YB2
    alpha_1 = -atan2(((posYB21_vektor(2)+posYB22_vektor(2))/2),((posYB21_vektor(1)+posYB22_vektor(1))/2));

    % halber Abstand zwischen den Markern
    a = (1/2*norm(posYB21_vektor-posYB22_vektor));
    % Abstand zwischen Base_YB1 und Marker_1
    b = (norm(posYB21_vektor));
    % Abstand zwischen Base_YB1 und Mitte Marker_YB2
    c = (1/2*norm(posYB21_vektor+posYB22_vektor));

    % Winkel zwischen Vektor c und Base_YB2  
    alpha_2 = -(acos((a^2+c^2-b^2)/(2*a*c)) - pi/2);

    % Distanz YB1 zu YB2
    r = sqrt(c^2+d^2-2*x*c*cos(pi-abs(alpha_2)));
    delta = asin(d/r*(sin(pi-abs(alpha_2))));

    % Winkel YB1 zu YB2
    phi = alpha_1 + delta;

    % Rueckgabe r und phi
    Y_Pos=[r phi];
end