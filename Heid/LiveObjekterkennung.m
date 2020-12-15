% Erkennung der objekte mit Hilfe von Kamera
window=figure;
run=true;
while run
    try
        %PaketPos = KreisErkennung(ROS,'s','1',21,'Bild');
        PaketPos_YB2 = KreisErkennung(runROS,'w','1',20,52,'Dtol',5,'Atol',10,'Sens',0.7,'Bild');
        disp(PaketPos_YB2);
        
        PaketPos_YB2_r1 = PaketPos_YB2(:,1);
        PaketPos_YB2_r2 = PaketPos_YB2(:,2);

        if isempty(PaketPos_YB2_r2(1).X) == 0     %Wenn PaketPos.X einen Wert > 0 annimmt, wird while-Schleife verlassen
            run = false;
        end
    catch
    end
    pause(0.1);
end
tic;
if tic >= 10000
    close figure 1;
end
