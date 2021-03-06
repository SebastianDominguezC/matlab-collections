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

bodies = [body1, body2];

world = World(G, bodies, t, dt);

world.plot();

% world.test();

world.simulate();

world.plotTrayectories();
