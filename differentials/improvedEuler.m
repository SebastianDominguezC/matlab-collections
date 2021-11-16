clear all; clc; close all;

f = @(x, y) (x + y - 1)^2;
disp(f);
[x, y] = EulerImproved(f, 0, 0.5, 2, 0.05);

function [x, y] = EulerImproved(f, xi, xf, yi, h)
    x = [xi:h:xf];
    y = zeros(1, length(x));
    y_n = zeros(1, length(x));
    y(1) = yi;
    y_n(1) = yi;
    y_n(2) = y(1) + h * f(x(1), y(1));
    y(2) = y(1) + (h / 2) * (f(x(1), y(1)) + f(x(2), y_n(2)));

    for i = 2:length(x) - 1
        f_normal = f(x(i), y(i));
        y_n(i + 1) = y(i) + h * f_normal;

        f_diferente = f(x(i + 1), y_n(i + 1));
        y(i + 1) = y(i) + h * (f_normal + f_diferente) / 2;
    end

end
