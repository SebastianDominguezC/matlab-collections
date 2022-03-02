clc; close all; clear all;

% G -- UA^3 / kg mes^2
G = 1;
M = 5;
m = 1;

% Campo Vectorial
space = 1;
[x, y] = meshgrid(-10:space:10);

r = (x.^2 + y.^2).^0.5;

F = -G * M ./ r^2;
X = F .* x ./ r;
Y = F .* y ./ r;

figure;
quiver(x, y, X, Y);
title('Campo Vectorial');
axis equal;
axis square;
xlabel('X');
ylabel('Y');

% Leapfrog
dt = 0.001;
t = [0:dt:20];
N = length(t);

% Prealocar vectores
r = zeros(1, N);
x = zeros(1, N);
y = zeros(1, N);
PFA = zeros(1, N);
PFB = zeros(1, N);
A_recorrida = zeros(1, N);

vx = zeros(1, N);
vy = zeros(1, N);

vx_mid = zeros(1, N);
vy_mid = zeros(1, N);

% Condiciones iniciales
L = 2;
k = G * M * m;
ecc = 0.685;

alfa = L^2 / (k * m);
r_min = alfa / (1 + ecc);

x(1) = 3.2;
y(1) = 0;
r(1) = x(1)^2 + y(1)^2;

vx(1) = 0;
vy(1) = 0.6;

A = x(1);
B = A * sqrt(1 - ecc^2);

PA = 0;
PB = B;

a = (-G * M) / r(1);

% Componentes x y
cx = x(1) / sqrt(r(1));
cy = y(1) / sqrt(r(1));

% Velocidades con paso medio == n + 1/2
vx_mid(1) = vx(1) + 0.5 * a * cx * dt;
vy_mid(1) = vy(1) + 0.5 * a * cy * dt;

for i = 1:N - 1
    % Radio y acc
    a_1 = (-G * M) / r(i);

    % Componentes x y
    cx = x(i) / sqrt(r(i));
    cy = y(i) / sqrt(r(i));

    % Velocidades con paso medio == n + 1/2
    vx_mid(i + 1) = vx(i) + 0.5 * a_1 * cx * dt;
    vy_mid(i + 1) = vy(i) + 0.5 * a_1 * cy * dt;

    % Posiciones paso completo == n + 1
    x(i + 1) = x(i) + vx_mid(i + 1) * dt;
    y(i + 1) = y(i) + vy_mid(i + 1) * dt;

    r(i + 1) = (x(i + 1))^2 + (y(i + 1))^2;

    % 1era ley kepler
    PFA(i + 1) = sqrt((x(i + 1) - PA)^2 + y(i + 1)^2);
    PFB(i + 1) = sqrt((x(i + 1) - PB)^2 + y(i + 1)^2);

    % Velocidades paso completo == n + 1
    % Radio y acc
    a_2 = (-G * M) / r(i + 1);

    % Componentes x y
    cx = x(i + 1) / sqrt(r(i + 1));
    cy = y(i + 1) / sqrt(r(i + 1));
    vx(i + 1) = vx(i) + 0.5 * a_2 * cx * dt;
    vy(i + 1) = vy(i) + 0.5 * a_2 * cy * dt;

    % 2da ley kepler
    v_tan = sqrt(vx(i + 1)^2 + vy(i + 1)^2);
    A_recorrida(i + 1) = 0.5 * sqrt(r(i + 1)) * v_tan * dt;
end

% Movimiento
figure;
plot(x, y);
axis square;
axis equal;
grid on;
title('Orbita eccentricidad 1/2');
xlabel('x');
ylabel('y');

% 1era ley Kepler
figure;
hold on;
plot(t, PFA, 'r');
plot(t, PFB, 'g');
plot(t, PFA + PFB, 'b');
axis square;
axis equal;
grid on;
title('Primera ley de Kepler');
xlabel('t');
ylabel('e');
legend('a', 'b', 'sum');

% 2nda ley Kepler
figure;
plot(t, A_recorrida, 'r');
grid on;
title('Segunda ley de Kepler');
xlabel('t');
ylabel('e');
