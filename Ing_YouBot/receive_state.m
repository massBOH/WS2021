function recieve_state(pub, sub, out, in)
    pubmsg = rosmessage(pub);
    submsg = rosmessage(sub);
    pubmsg.Data = out;
    submsg.Data = 0;
    % Warten auf Nachricht 'in'
    while not (submsg.Data == in)
        try
            submsg = receive(sub, 0.5);
        catch
        end
    end
    % Bestaetigen, solange Nachricht 'in' kommt 
    while (submsg.Data == in)
        send(pub, pubmsg);
        try
            submsg = receive(sub, 0.5);
        catch
            submsg.Data = 0;
        end
    end
end

    
