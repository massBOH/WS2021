function active_state(pub, sub, out, in)
    pubmsg = rosmessage(pub);
    submsg = rosmessage(sub);
    pubmsg.Data = out;
    submsg.Data = 0;
    % Senden eigene Nachricht, bis passende Nachricht empfangen wird
    while not (submsg.Data == in)
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.1);
        catch
        end
    end
    % Weitersenden von eigener Nachricht, bis andere Nachricht nicht mehr empfangen
    while (submsg.Data == in)
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.5);
        catch
            submsg.Data = 0;
        end
    end
end

    
