%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Funktion send_state
%
% Sendet eine Nachricht und wartet auf Bestaetigung

function send_state(pub, sub, out, in)
    pubmsg = rosmessage(pub);
    submsg = rosmessage(sub);
    pubmsg.Data = out;
    submsg.Data = 0;
    % Senden bis passende Antwort kommt
    while not (submsg.Data == in)
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.1);
        catch
        end
    end
end

    
