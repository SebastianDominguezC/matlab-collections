clear all; clc; close all;

% Constants
beta = 1;
gamma = 0.1;
N = 1000000;
phi = beta / N;
delta = 0.5;

% Start and ending
t0 = 0;
tf = 60;

% Vectors
t = [t0:delta:tf];
S = zeros(1, length(t));
I = zeros(1, length(t));
R = zeros(1, length(t));

% Initial conditions
S(1) = 999999;
I(1) = 1;
R(1) = 0;

for i = 1:length(t) - 1
    % Euler's method per function
    S(i + 1) = S(i) + (-phi * I(i) * S(i)) * delta;
    I(i + 1) = I(i) + (phi * S(i) * I(i) - gamma * I(i)) * delta;
    R(i + 1) = R(i) + gamma * I(i) * delta;
end

% Plot
figure();
p1 = plot(t, S);
title('SIR COVID-19');
xlabel('Time (días)');
ylabel('# of people');
hold on;
p2 = plot(t, I);
p3 = plot(t, R);
hold off;
L = [p1; p2; p3];
legend(L, 'S', 'I', 'R');
