%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Funktion zum Verfahren der Gelenke
%
% Basiert auf GelenkPos_Flores.m
% Implementiert einen P-Regler zum Anfahren der uebergebenen Achswinkel
% Es sind min- und maxSpeed sowie eine Toleranz vorgegeben.
% Uebergeben werden die runROS-Struktur sowie der Zielwinkel in rad.

function Ing_GelenkPos(ROS,WinkelNeuR)

    % sollSpeed und endSpeed sowie endToleranz
    sollSpeed=[0 0 0 0 0];
    endSpeed=0.01;
    endToleranz=0.01;
    % Min Max
    minSpeed=0.1;
    maxSpeed=0.3;
    % Reglerverstaerkung
    KP=[.9 .9 .7 .9 .5];

    % Berechnung Zielwinkel
    WinkelNeuV = calcWinkelNeuV(ROS, WinkelNeuR)

    % Regler fuer Zielwinkel
    % Programm arbeitet solange run=true
    run=true;
    while (run)
        WinkelAltV(1:5)=ROS.Arm.Sub.LatestMessage.Position(1:5);
        % Soll/Ist Vergleich
        deltaPos = WinkelNeuV - WinkelAltV;
        
        for j = 1:5
            if abs(deltaPos(j))>endToleranz
                % P-Regler reicht weil die Regelstrecke I Anteil besitzt
                sollSpeed(j) = deltaPos(j)*KP(j);
                % Speed Min und Max
                sollSpeed(j) = checkSpeed(Sollspeed(j), minSpeed, maxSpeed)
                % schreiben der errechneten Geschwindigkeit in die Nachricht
                ROS.Arm.Nach.Velocities(j).Value = sollSpeed(j);
            else
                ROS.Arm.Nach.Velocities(j).Value = 0.0;
            end
        end
        % Kontrolle ob Geschwindigkeiten und Abstand zum Ziel klein ist
        if sum(abs(ROS.Arm.Sub.LatestMessage.Velocity)) < endSpeed && sum(abs(deltaPos)) < (endToleranz*5)
            for k = 1:5
                ROS.Arm.Nach.Velocities(k).Value=0.0;
            end
            run=false;
        end
        % senden der geschriebenen Nachricht
        send(ROS.Arm.Pub,ROS.Arm.Nach);
        pause(0.01);
    end
    % Nachkorrektur mittels Pos-Befehl
    for j=1:5
        ROS.Arm.Nach2.Positions(j).Value=WinkelNeuV(j);
    end
    % senden der geschriebenen Nachricht
    send(ROS.Arm.Pub2,ROS.Arm.Nach2);
    % Kontrolle ob Geschwindigkeiten kleiner endSpeed sind
    run=true;
    while run
        if sum(abs(ROS.Arm.Sub.LatestMessage.Velocity))<endSpeed/10
            run=false;
        end
        pause(0.01);
    end
end

% Funktion prueft, ob Variable in innerhalb der min und max Grenzen liegt
% out entspricht in, wenn innerhalb der Grenzen, sonst der entsprechenden Grenze
function out = checkMinMax(in, min, max)
    if in > max
        out = max
    elseif in < min
        out = min
    else
        out = in
    end
end

% Funktion prueft, ob die Variable in in den Intervallen von -min bis -max oder min bis max liegt.
% out entspricht in, wenn in in den Intervallen liegt, ansonsten der verletzen Grenze.
function out = checkSpeed(in, min, max)
    testval = abs(in)
    if tesval < min
        if in >= 0
            out = min;
        else
            out = -min;
        end
    elseif tesval > max
        if in >= 0
            out = max;
        else
            out = -max;
        end
    end
end

% Funktion errechnet aus dem Eingangswinkel in rad die realen Winkel der Hardware.
% Die dazu noetigen Werte werden aus der ROS Struktur bezogen, die von runROS bereit gestellt wird.
function WinkelNeuV = calcWinkelNeuV(ROS, WinkelNeuR)
    WinkelNeuD = rad2deg(WinkelNeuR);
    WinkelNeuV = zeros(1,5);
    % Umrechnen der ubergebenen Werte in anfahrbare Positionen
    for i = 1:5
        % wenn nan nimm den letzten Value, sonst berechne Value
        if ~isnan(WinkelNeuD(i))
            % Winkel pruefen
            WinkelNeuD(i) = checkMinMax(WinkelNeuD(i), ROS.Arm.Info.JointMin(i), ROS.Arm.Info.JointMax(i))
            % Winkel umrechnen auf Value
            if i==3
                WinkelNeuV(i) = deg2rad(WinkelNeuD(i) - (ROS.Arm.Info.JointMax(i)'));
            else
                WinkelNeuV(i) = deg2rad(WinkelNeuD(i) - (ROS.Arm.Info.JointMin(i)'));
            end
        else
            WinkelNeuV(i) = ROS.Arm.Sub.LatestMessage.Position(i);
        end
        % Max Min Abgleich und Korrektur der Values
        WinkelNeuV(i) = checkMinMax(WinkelNeuV(i), ROS.Arm.Info.JointValueMin(i), ROS.Arm.Info.JointValueMax(i))
    end
end