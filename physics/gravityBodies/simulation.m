clear all; clc;
% Constantes
G = 1;

% Leapfrog
dt = 0.5;
t = [0:dt:100];
N = length(t);

% Definir cuerpos
body1 = Body(1, 0.3, Vec(-5, -5, 1), Vec(0.2, 0, 0), 'r');
body2 = Body(1, 0.3, Vec(-5, 5, -1), Vec(0, -0.2, 0), 'g');
body3 = Body(1, 0.3, Vec(5, 5, 1), Vec(-0.2, 0, 0), 'b');
body4 = Body(1, 0.3, Vec(5, -5, -1), Vec(0, 0.2, 0), 'y');

bodies = [body1, body2];

world = World(G, bodies, t, dt);

world.plot();

% world.test();

world.simulate();

world.plotTrayectories();
