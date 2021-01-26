function KlotzPositionAnfahren(klotz_arr)

a = klotz_arr(1);
b = klotz_arr(2);
c = klotz_arr(3);
d = klotz_arr(4);
e = klotz_arr(5);

f = klotz_arr(6);
g = klotz_arr(7);
h = klotz_arr(8);
k = klotz_arr(9);
l = klotz_arr(10);


GelenkPos(runROS,[a, b, c, d, e]); %vorgreif position
GelenkPos(runROS,[f, g, h, k, l]); %runter zum greifen

GreiferPos(runROS(),0); % greifer zu

GelenkPos(runROS,[a, b, c, d, e]); 

GelenkPos(runROS,[0, 0, 0, 0, 0]);
