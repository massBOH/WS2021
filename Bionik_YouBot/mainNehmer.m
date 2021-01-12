% Nehmer

GreiferPos(runROS(),20); % Greifer offen
erkannte_uebergabe = ubergabe_erkennung();

uebergabeX    = erkannte_uebergabe(1);
uebergabeY    = erkannte_uebergabe(2);
uebergabeZ    = erkannte_uebergabe(3);
voruebergabeX = erkannte_uebergabe(4);
voruebergabeY = erkannte_uebergabe(5);
voruebergabeZ = erkannte_uebergabe(3);


voruebergabe = inverse_youbot_real([voruebergabeX voruebergabeY voruebergabeZ 0 0]); 
uebergabe = inverse_youbot_real([uebergabeX uebergabeY uebergabeZ 0 0]); 

GelenkPos(runROS,voruebergabe); %voruebergabe position
GelenkPos(runROS,uebergabe); %uebergabe position

GreiferPos(runROS(),0); % Greifer zu

safe_rot = [pi/4 0 0 0 0]
GelenkPos(runROS,uebergabe+safe_rot); %voruebergabe position



GelenkPos(runROS,[0, 0, 0, 0, 0]);
