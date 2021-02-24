% RSY 2020/21
% T. Thuilot und A. Heid

% Fährt die Position des Klotzes auf der Ablagefläche des youbots an



function KlotzPositionAnfahren(klotz_arr)

% Vorgreifposition
a = klotz_arr(1); % X
b = klotz_arr(2); % Y
c = klotz_arr(3); % Z
d = klotz_arr(4); % psi
e = klotz_arr(5); % Greifer pos

% Greifposition
f = klotz_arr(6); % X
g = klotz_arr(7); % Y
h = klotz_arr(8); % Z
k = klotz_arr(9); % psi
l = klotz_arr(10); % Greifer pos


GelenkPos(runROS,[a, b, c, d, e]); % Vorgreifposition mit Sicherheit
GelenkPos(runROS,[f, g, h, k, l]); % runter zum greifen

GreiferPos(runROS(),0); % Greifer zu

GelenkPos(runROS,[a, b, c, d, e]); % Vorgreifposition mit Sicherheit

GelenkPos(runROS,[0, 0, 0, 0, 0]); % Kerzenposition
