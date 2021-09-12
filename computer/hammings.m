% Hammings bit corrections

clear all; clc;
num = input("Enter a number between 8 and 31, both inclusive");
word = convert_binary(num);
k = length(word);

% Matrices A para 4 y 5 bits
A4 = [0 1 1; 1 0 1; 1 1 0; 1 1 1];
A5 = [1 0 1 0; 1 1 1 0; 0 0 1 1; 1 1 0 0; 1 1 1 1];
A = A4;

if k == 4
    A = A4;
elseif k == 5
    A = A5;
end

% Obtener matriz generadora y verificadora
[g, h] = get_hammings_parity(A);

% Crea el mensaje - codificarlo desde un num decimal
mes = transpose(word);

% Codificar el mensaje
message = parity(transpose(g) * mes);
disp("Original:");
disp(message');

% Introducir error aleatorio
rand_index = randi(k);

if message(rand_index, 1) == 0
    message(rand_index, 1) = 1;
else
    message(rand_index, 1) = 0;
end

disp("With random error:");
disp(message');

% Corregir el mensaje
corrected = correct(h, message);

% Convertir num binario a uno decimal
converted = convert_to_decimal(transpose(corrected));

% Se debe imprimir el num original
disp("Corrected message:");
disp(converted);

% Verificar que la conversion sea igual al input original
if converted == num
    disp("Error corrected successfully");
else
    disp("Could not correct the message :(");
end

function binary_vector = convert_binary(num)
    binary_vector = [];

    while num > 1
        remainder = rem(num, 2);

        if remainder == 0
            num = num / 2;
        else
            num = (num - 1) / 2;
        end

        binary_vector = [remainder binary_vector];
    end

    binary_vector = [1 binary_vector];
end

function num = convert_to_decimal(binary_vector)
    num = 0;
    vector_length = length(binary_vector);

    for i = 1:vector_length
        exponent = i - 1;
        index = vector_length - exponent;
        num = num + 2^exponent * binary_vector(index);
    end

end

function [generator, verifier] = get_hammings_parity(A)
    % Tamaño k - viene del tamaño de las filas
    k = size(A, 1);

    % Tamaño n - viene del tamaño de columnas
    n = size(A, 2) + k;

    % G - Juntar matriz identidad con A
    generator = [eye(k) A];

    % H - Juntar AT con identidad
    verifier = [transpose(A) eye(n - k)];
end

function correction = correct(verifier, message)
    % Obtener la verificación
    verified = verify(verifier, message);

    % Para sólo los códigos de paridad
    iterations = size(verifier, 2) - size(verifier, 1);

    for i = 1:iterations
        % Si la matriz verificada es igual a un código de paridad, hay un
        % error -  corregirlo
        if verified == verifier(:, i)

            if message(i, 1) == 0
                message(i, 1) = 1;
            else
                message(i, 1) = 0;
            end

        end

    end

    % Regresar la corrección
    correction = message(1:iterations, 1);
end

function verified = verify(verifier, message)
    % H x mensaje
    m = verifier * message;

    % Obtener una paridad, pues el resultado de arriba no está en binario
    % ni con paridad
    verified = parity(m);
end

function m = parity(m)
    % Iterar las filas
    for i = 1:size(m, 1)
        % Lo que sobra de la división es la paridad
        remainder = rem(m(i, 1), 2);
        m(i, 1) = remainder;
    end

end
