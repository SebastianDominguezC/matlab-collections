clc;
clear;
close all;
format shortG;

f = @(x, y) 2 * x - 3 * y +1
[x, y] = RKSegundoOrden(f, 1, 1.5, 5, .05, 1);

function [x, y] = RKSegundoOrden(f, xi, xf, yi, h, a2)
    x = [xi:h:xf];
    y = zeros(1, length(x));
    y(1) = yi;

    a1 = 1 - a2;
    p1 = 1 / (2 * a2);
    q11 = p1;

    for i = 1:length(x) - 1
        k1 = f(x(i), y(i));
        k2 = f(x(i) + p1 * h, y(i) + q11 * k1 * h);
        y(i + 1) = y(i) + (a1 * k1 + a2 * k2) * h;
    end

end
