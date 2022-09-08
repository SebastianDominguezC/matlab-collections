clear all; clc; close all;

% Constantes
L = 50;
N = 2^10;
dt = L / N;
dk = 2 * pi / L;
x_end = 3 * pi;

dx = dt.^2/4;

x_space = 0:dx:x_end;

[energy, time] = ssfm(N, dt, dk, x_end, dx);

% Hacer plot
figure(1);
colormap('hot');
imagesc(x_space, time, abs(energy));
xlabel("espacio (x)");
ylabel("tiempo (t)");

function [pulse_energy, t] = ssfm(N, dt, dk, x_end, dx)
    % Definir intervalos
    t = [-N / 2:1:N / 2 - 1] * dt;
    k = [-N / 2:1:N / 2 - 1] * dk;

    % Primera FFT
    kshift = fftshift(k);
    kshift2 = kshift.^2;

    pasos = ceil(x_end / dx);
    utotal = zeros(N, pasos + 1);

    % Aqui se define has inicial
    u0 = exp(-t.^2);
    un = u0;
    utotal(:, 1) = u0;

    % Segunda FFT interior con inversa en cada paso
    for cuenta = 1:1:pasos
        F_NL = fft(exp(1i * dx * abs(un).^2) .* un);
        F_D = exp(-1i * kshift2 * dx / 2) .* F_NL;
        un = ifft(F_D);
        utotal(:, cuenta) = un;
    end

    pulse_energy = utotal;
end
