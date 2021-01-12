
try 
    KlotzPositionAnfahren();
    master = 1
    disp("master")
    
catch exception
    master = 0
    disp("slave")
    GreiferPos(runROS(),20); % Greifer offen
    
end

erkannte_uebergabe = ubergabe_erkennung();

uebergabeX    = erkannte_uebergabe(1);
uebergabeY    = erkannte_uebergabe(2);
uebergabeZ    = erkannte_uebergabe(3);
voruebergabeX = erkannte_uebergabe(4);
voruebergabeY = erkannte_uebergabe(5);
voruebergabeZ = erkannte_uebergabe(3);

if master == 1
    theta5 = pi/2;
else 
    theta5 = 0;
end

voruebergabe = inverse_youbot_real([voruebergabeX voruebergabeY voruebergabeZ 0 theta5]); 
uebergabe = inverse_youbot_real([uebergabeX uebergabeY uebergabeZ 0 theta5]); 

GelenkPos(runROS,voruebergabe); %voruebergabe position
GelenkPos(runROS,uebergabe); %uebergabe position

if master == 1
    GreiferPos(runROS(),20); % Greifer offen
else 
    GreiferPos(runROS(),0); % Greifer schließen
end


safe_rot = [pi/4 0 0 0 0]
GelenkPos(runROS,uebergabe+safe_rot); %voruebergabe position

GelenkPos(runROS,[0, 0, 0, 0, 0]);

