clear all; clc; close all;

% GM
gm = 39.478;

% Ecuaciones diferenciales
f = @(t, z) [
        z(2);
        (-gm / ((z(1)^2 + z(3)^2)^(3/2))) * z(1);
        z(4);
        (-gm / ((z(1)^2 + z(3)^2)^(3/2))) * z(3);
        ];

% Solucion ODE45
[t, z] = ode45(f, [0, 1.266], [-1, 0, 0, 7.6103]);

% Graficar orbitas
hold on;
fimplicit(@(x, y) x^2 + y^2 - 1, 'b', 'Linewidth', 0.5);
fimplicit(@(x, y) x^2 + y^2 - (2.772^2), 'r', 'Linewidth', 0.5);
plot(z(:, 1), z(:, 3), 'k', 'Linewidth', 1);
title('Orbitas y trayectoria del satelite')
xlabel('x [UA]')
ylabel('y [UA]')
legend({'Orbita tierra', 'Orbita Ceres', 'Trayectoria satelite'}, 'Location', 'southwest')
hold off;
