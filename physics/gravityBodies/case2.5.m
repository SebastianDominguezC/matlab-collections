clear all; clc;
% Constantes
G = 1;

% Leapfrog
dt = 0.1;
t = [0:dt:200];
N = length(t);

% Definir cuerpos
v = 0.1;
p = 5;
body1 = Body(1, 0.3, Vec(-p, -p, 0), Vec(v, -v, 0), 'r');
body2 = Body(2, 0.6, Vec(p, p, 0), Vec(-v, v, 0), 'g');

bodies = [body1, body2];

world = World(G, bodies, t, dt);

world.simulate();
world.plotTrayectories();
world.plotTotalEnergies();
world.calcLinMomentum();
