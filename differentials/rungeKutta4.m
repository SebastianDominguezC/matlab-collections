clear all; clc; close all;
format shortG;

global x1 y1 e_abs e_rel;

f = input('Ecuacion: ', 's');
f = inline(f, 'x', 'y');

h = input('Paso: ');

x0 = input('X inicial: ');

xf = input('X final: ');

y0 = input('Y inicial: ');

%Cuarto orden
[x1, y1, e_abs, e_rel] = RKCuartoOrden(f, x0, xf, y0, h);
plot(x1, y1, '-');
hold on
grid on
legend('Cuarto orden')

function [x, y, e_abs, e_rel] = RKCuartoOrden(f, xi, xf, yi, h)
    x = [xi:h:xf];
    y = zeros(1, length(x));
    y_comparacion = exp(x.^2);
    y(1) = yi;

    for i = 1:length(x) - 1
        k1 = f(x(i), y(i));
        k2 = f(x(i) + h / 2, y(i) + k1 * h / 2);
        k3 = f(x(i) + h, y(i) - k1 * h + 2 * k2 * h);
        k4 = f(x(i) + h, y(i) + k3 * h);
        y(i + 1) = y(i) + (h / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
    end

    e_abs = abs(y_comparacion - y);
    e_rel = (e_abs ./ y) * 100;
end
