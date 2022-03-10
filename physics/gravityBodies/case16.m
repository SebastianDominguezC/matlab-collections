clear all; clc;
% Constantes
G = 1;

% Leapfrog
dt = 0.5;
t = [0:dt:100];
N = length(t);

% Definir cuerpos
v = 0.2;
p = 5;
body1 = Body(1, 0.3, Vec(-p, -p, -p), Vec(v, -v, v), 'r');
body2 = Body(1, 0.3, Vec(-p, p, -p), Vec(-v, -v, v), 'g');
body3 = Body(1, 0.3, Vec(p, -p, -p), Vec(v, v, v), 'b');
body4 = Body(1, 0.3, Vec(p, p, -p), Vec(-v, v, v), 'y');
body5 = Body(1, 0.3, Vec(-p, -p, p), Vec(v, -v, v), 'm');
body6 = Body(1, 0.3, Vec(-p, p, p), Vec(-v, -v, v), 'c');
body7 = Body(1, 0.3, Vec(p, -p, p), Vec(v, v, v), 'bl');
body8 = Body(1, 0.3, Vec(p, p, p), Vec(-v, v, v), 'p');

v2 = 0.2;
p2 = 10;
body9 = Body(1, 0.3, Vec(-p2, -p2, -p2), Vec(v2, -v2, v2), 'r');
body10 = Body(1, 0.3, Vec(-p2, p2, -p2), Vec(-v2, -v2, v2), 'g');
body11 = Body(1, 0.3, Vec(p2, -p2, -p2), Vec(v2, v2, v2), 'b');
body12 = Body(1, 0.3, Vec(p2, p2, -p2), Vec(-v2, v2, v2), 'y');
body13 = Body(1, 0.3, Vec(-p2, -p2, p2), Vec(v2, -v2, v2), 'm');
body14 = Body(1, 0.3, Vec(-p2, p2, p2), Vec(-v2, -v2, v2), 'c');
body15 = Body(1, 0.3, Vec(p2, -p2, p2), Vec(v2, v2, v2), 'bl');
body16 = Body(1, 0.3, Vec(p2, p2, p2), Vec(-v2, v2, v2), 'p');

bodies = [body1, body2, body3, body4, body5, body6, body7, body8, body9, body10, body11, body12, body13, body14, body15, body16];

world = World(G, bodies, t, dt);

world.plot();

world.simulate();

world.plotTrayectories();
