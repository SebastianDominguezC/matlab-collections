clear all; clc; close all;

C = 20;
d = 1;
N = 10000;
M = 55000;
delta = 0.1;
bins = 0:d:C;

people = delta_dist(N, M, C);
figure();
plot = histogram(people, bins);

loops = 10000000;
plot_step = 100000;

% Semilla de aleatoridad
rng(0, 'twister');

entropies = [];

for i = 1:loops
    k = randi(N);
    l = randi(N);

    s = randi([0, 1]);

    if (s == 0)
        s = -1;
    end

    t1 = people(k) + delta * s;
    t2 = people(l) - delta * s;

    if (t1 >= 0 && t2 >= 0)
        people(k) = t1;
        people(l) = t2;
    end

    if (mod(i, plot_step) == 0)
        plot = make_distr(people, bins);
        S = entropy(N, C, plot);
        entropies = [entropies, S];
    end

end

disp(entropies);

% Distribucion delta
function people = delta_dist(N, M, C)
    intial_money = M / N;
    people = intial_money * ones(1, N);
end

% Distribucion uniforme
function people = uniform_dist(N, M, C)
    people = zeros(1, N);
    quantity = N / C;

    for i = 1:C
        x = (i - 1) * quantity + 1;
        y = x + quantity - 1;
        people(1, x:y) = i - 1;
    end

end

function plot = make_distr(people, bins)
    plot = histogram(people, bins);
end

function S = entropy(N, C, plot)
    S = N * log(N) - suma(C, plot);
end

function s = suma(C, plot)
    s = 0;

    for k = 1:C
        nk = plot.Values(k);
        s = s + nk * log(nk);
    end

end
