%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Westfaelische Hochschule Fachbereich Maschinenbau
% Modul Robotersysteme im WS20/21
% G. Hebinck, N. Heier, E. Moellmann
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Funktion active_state
%
% Stellt sicher, dass der Kommunikationskanal zum 
% Kommunikationspartner verfuegbar ist.


function active_state(pub, sub, in, ACK)
    pubmsg = rosmessage(pub);
    submsg = rosmessage(sub);
    pubmsg.Data = in;
    submsg.Data = 0;
    % Senden der Nachricht, bis Nachricht oder Nachricht + ACK empfangen wird
    while (submsg.Data == 0)
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.1);
            if not ((submsg == in) && (submsg == (in+ACK)))
                submsg = 0
            end
        catch
        end
    end
    % Senden der Nachricht + ACK, bis eine andere Nachricht empfangen wird
    while (submsg.Data == in)
        pubmsg.Data = in+ACK;
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.1);
        catch
        end
    end
    % Senden von ACK, bis andere Nachricht empfangen wird
    while (submsg.Data == ACK+in)
        pubmsg.Data = ACK;
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.5);
        catch
        end
    end
    % 10 mal Senden von ACK
    for index = 1:10
        pubmsg.Data = ACK;
        send(pub, pubmsg);
        pause(0.10);
    end
end

    
