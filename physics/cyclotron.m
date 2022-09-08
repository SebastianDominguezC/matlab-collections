clear all; clc; close all;

d = 0.005;
r = 0.05;
V = 5000;
q = 1.6e-19;
m = 1.672e-27;
dt = 1e-10;

B = [0, 0, 1];

w = 0.6 * abs(q * norm(B) / (2 * pi * m));
T = 1 / w;

fprintf('frecuencia %d', w);

pos = [0, 0, 0];
v = [0, 0, 0];

radius = 0;

x = [];
y = [];
t = 0;
i = 0;

EK = [];
time = [];

while radius < r && i < 1000000
    i = i + 1;
    t = t + dt;
    E = get_e(d, T, t, V, pos);
    F = get_force(q, v, E, B);
    a = F / m;

    v = v + a * dt;
    pos = pos + v * dt;

    radius = norm(pos);

    x(i) = pos(1);
    y(i) = pos(2);
    EK(i) = get_ke(m, v) / (1.6 * 10^ - 13);
    time(i) = t;
end

disp('ended');
fprintf('tiempo %d \n', t);
fprintf('velocidad max %d \n', norm(v));
fprintf('ek final %d \n', get_ke(m, v) / (1.6 * 10^ - 13));
fprintf('# de vueltas %d \n', t / T);

figure;
hold on;
title('Grafico posicion');
xlabel('x');
ylabel('y');
plot(x, y);

figure;
hold on;
title('Grafico Energias');
xlabel('t (t)');
ylabel('EK (eV)');
plot(time, EK);

function ke = get_ke(m, v)
    ke = 0.5 * m * norm(v)^2;
end

function F = get_force(q, v, E, B)
    F = q * (E + cross(v, B));
end

function E = get_e(d, T, t, V, pos)
    E = [0, 0, 0];

    if abs(pos(1)) < d / 2
        dir = get_sign(T, t);
        E = dir * V * d * [1, 0, 0];
    end

end

function sign = get_sign(T, t)
    laps = floor(t / T);

    if rem(laps, 2) == 0
        sign = 1;
    else
        sign = -1;
    end

end
