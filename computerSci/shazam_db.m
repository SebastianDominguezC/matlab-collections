% Algoritmo para GUARDAR canciones
clear all; clc;

% Poner los archivos de lasz canciones en un vector columna
data = [
    ["song1.wav"];
    ["song2.wav"];
    ["song3.wav"];
    ["song4.wav"];
    ["song5.wav"];
    ];

% Poner la informacion de ada cancion en una matriz
song_data = [
        ["Stayin' Alive", "Bee Gees", "4:10"];
        ["SEE  YOU AGAIN", "Tyler the Creator", "3:23"];
        ["Guitarras blancas", "Los Enanitos Verdes", "4:26"];
        ["You can never tell", "Chuck Berry", "2:43"];
        ["Hound Dog", "Elvis Presley", "2:13"];
        ];

[n_rows, n_cols] = size(data);

% Matrices para guardar la info
db = [];
db_data = [];

% Loop de todas las canciones
for i = 1:n_rows
    % Leer archivo de audio
    file = data(i, 1);
    [sig, Fs] = audioread(file);

    % Convertir a mono senal
    monoSig = (sig(:, 1) + sig(:, 2)) / 2;
    intervalo = Fs;

    % Matriz para guardar las transformadas
    song = [];
    pos = 1;

    % Loop del audio por fragmentos
    for k = 1:(length(monoSig) / intervalo) - 1
        % De la matriz mono, obtener un intervalo
        aud = monoSig(pos:pos + intervalo);

        % TRF al audio, valor absoluto para tener magnitudes
        auf = abs(fft(aud));

        % Guardar la mitad de los datos, que los datos son duplicados
        auf = auf(1:intervalo / 2);

        % Transponer a un vector
        t = transpose(auf);

        % Guardar el cacho de la cancion
        song(k, :) = t;

        % Cambiar posicion para la siguiente iteracion
        pos = pos + intervalo;
    end

    % Obtener huellas y sacar solo el vector de huella
    fs = obtener_huella(song);
    fs = fs(:, 1);

    % Prealocar matrices de strings
    save = strings([length(fs), 1]);
    save_data = strings([length(fs), 3]);

    % Info de la cancion
    title = song_data(i, 1);
    author = song_data(i, 2);
    duration = song_data(i, 3);

    % A cada huella de la cancion, guardarla en las matrices
    for j = 1:length(fs)
        save(j, :) = [fs(j)];
        save_data(j, :) = [title, author, duration];
    end

    % Adjuntar a las "bases de datos" los datos
    db = vertcat(db, save);
    db_data = vertcat(db_data, save_data);
end

% db guarda las huellas
writematrix(db, "db.txt");

% db_data guarda la informacion de cada huella (autor, titulo, duracion)
writematrix(db_data, "db_data.txt");

% Funcion para obtener las huellas de una cancion
% X debe ser el ESPECTRO de la cancion
function fingerprint = obtener_huella(X)
    % Rangos de audio a considerar
    ranges = [40, 80, 120, 180, 300];
    [n_rows, ] = size(X);

    % Prealocar espacio para huella
    fingerprint = strings([n_rows, 1]);

    % Iterar filas del audio
    for i = 1:n_rows
        % Dividir las magnitudes del espectro por rangos
        r1 = X(i, ranges(1):ranges(2));
        r2 = X(i, ranges(2):ranges(3));
        r3 = X(i, ranges(3):ranges(4));
        r4 = X(i, ranges(4):ranges(5));

        % Maximo valor en cada rango
        a1 = max(r1);
        a2 = max(r2);
        a3 = max(r3);
        a4 = max(r4);

        % Agregar maximos a la huella
        f = ceil([a1, a2, a3, a4]);
        fingerprint(i) = strjoin(string(f), '');
    end

end
