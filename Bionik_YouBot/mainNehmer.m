% Nehmer

GreiferPos(runROS(),20); % Greifer offen
erkannte_uebergabe = ubergabe_erkennung();

voruebergabeX = erkannte_uebergabe(1) -20;
voruebergabeY = erkannte_uebergabe(2) -20;% noch zu ändern
voruebergabeZ = erkannte_uebergabe(3);


voruebergabe = inverse_youbot_real([voruebergabeX voruebergabeY voruebergabeZ 0 pi/2]); 
uebergabe = inverse_youbot_real([erkannte_uebergabe(1) erkannte_uebergabe(2) erkannte_uebergabe(3) 0 0]); 

GelenkPos(runROS,voruebergabe); %voruebergabe position
GelenkPos(runROS,uebergabe); %uebergabe position

GreiferPos(runROS(),0); % Greifer zu


GelenkPos(runROS,voruebergabe); %voruebergabe position

GelenkPos(runROS,[0, 0, 0, 0, 0]);
