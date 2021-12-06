% Algoritmo para IDENTIFICAR canciones
clear all;

% Parametros para grabar audio
F1 = 44100;
bits = 16;
channels = 1;
audio = audiorecorder();

% Duracion de grabacion = audiolength * fragments
audiolength = 3;
fragments = 3;

song = [];

% Grabar por fragmentos especificados
for k = 1:fragments
    recordblocking(audio, audiolength);
    aud = getaudiodata(audio);

    % FFT y valor absoluto para tener espectro
    auf = abs(fft(aud));

    % Convertir en vector
    t = transpose(auf);

    % Guardar cacho de la cancion
    song(k, :) = t;
end

% Obtener huellas
fs = obtener_huella(song);
fs = fs(:, 1);

% Cargar "bases de datos"
opts = detectImportOptions('db_data.txt');
opts = setvartype(opts, {'string'});
ids = readmatrix('db.txt');
information = readmatrix('db_data.txt', opts);

% Loopear las huellas
for i = 1:length(fs)
    % Buscar si en los IDS hay una de las huellas con rango de error +- 10,0000
    % Si hay, da un indice de la huella
    matches_index = find(fs(i) < string(ids + 10000) & fs(i) > string(ids - 10000));

    % Buscar indice y extraer informacion de la base de datos
    matches_info = information(matches_index(1), :);

    % Si existe huella similar, se imprime la informacion
    disp('-----');
    disp(matches_info);
end

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
