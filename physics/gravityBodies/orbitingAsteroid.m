clear all; clc; close all;
% Constantes
G = 1;
MS = 1;
RS = 1;
VZ = 0.1;

MJ = MS * 0.001;
RJ = RS * 0.1;
aph = 17;
VJ = 0.195;

MA = MJ * 0.01;
VA = 0.0417;
dA = 0.5;
RA = RJ * 0.001;

% Leapfrog
dt = 0.5;
t = [0:dt:1200];
N = length(t);

% Definir cuerpos
sun = Body(MS, RS, Vec(0, 0, 0), Vec(0, 0, 0), 'r');
jupyter = Body(MJ, RJ, Vec(aph, 0, 0), Vec(0, VJ, 0), 'b');
asteroid = Body(MA, RA, Vec(aph, dA, 0), Vec(VA, VJ, 0), 'g');

bodies = [sun, jupyter, asteroid];

world = World(G, bodies, t, dt);

world.plot();
world.simulate();
world.plotTrayectories();
world.plotTotalEnergies();
world.calcLinMomentum();
