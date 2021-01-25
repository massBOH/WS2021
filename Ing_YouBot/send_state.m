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

    
