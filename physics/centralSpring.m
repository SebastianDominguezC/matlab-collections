clc; clear all; close all;

% Constantes
l = 5;
k = 1;
m = 3;

% Campo Vectorial
space = 1;
[x, y] = meshgrid(-10:space:10);

r = (x.^2 + y.^2).^0.5;

X = -k * (r - l) .* x ./ r;
Y = -k * (r - l) .* y ./ r;

figure;
quiver(x, y, X, Y);
title('Campo Vectorial');
axis square;
xlabel('X');
ylabel('Y');

% Metodo Euler
dt = 0.001;
t = [0:dt:60];

% Prealocar vectores
r = zeros(1, length(t));
x = zeros(1, length(t));
y = zeros(1, length(t));
vx = zeros(1, length(t));
vy = zeros(1, length(t));

% Condiciones iniciales
x(1) = 7.5;
y(1) = 0;
vx(1) = 0;
vy(1) = 0.32;

for i = 1:length(t) - 1
    % Radio y acc
    r(i) = sqrt(x(i)^2 + y(i)^2);
    a = -k * (r(i) - l) / m;

    % Componentes x y
    cx = x(i) / r(i);
    cy = y(i) / r(i);

    % Velocidades
    vx(i + 1) = vx(i) + a * cx * dt;
    vy(i + 1) = vy(i) + a * cy * dt;

    % Posiciones
    x(i + 1) = x(i) + vx(i) * dt;
    y(i + 1) = y(i) + vy(i) * dt;
end

% Estrella
figure;
title('Movimiento particula');
xlabel('x');
ylabel('y');
axis square;
grid on;
plot(x, y);

% Conservaciones de energia
EP = (1/2) * k * (r - l).^2;
V_SQ = (vx.^2 + vy.^2);
EK = (1/2) * m * V_SQ;

E = EP + EK;

% Grafica de energias
figure;
hold on;
title('Grafico Energias');
xlabel('t (t)');
ylabel('E (J)');
plot(t, EK, 'r');
plot(t, EP, 'b');
plot(t, E, 'g');
legend('EK', 'EP', 'E');
