% run.m - Główny skrypt uruchomieniowy
clear; clc; close all;

%% 1. Wczytanie i przygotowanie danych
filename = 'plik.txt';

% Użycie textread zgodnie z instrukcją do wczytania jako stringi
raw_cell = textread(filename, '%s');

% Konwersja cell array do jednej długiej macierzy znaków
raw_char = cell2mat(raw_cell'); % Transpozycja, aby połączyć wiersze w jeden ciąg

% Konwersja ASCII na liczby z zakresu <0; 7>
% Znak '0' ma kod 48. Odejmujemy 48 od kodów ASCII.
data = double(raw_char) - '0';

% Upewnienie się, że dane są wektorem kolumnowym
data = data(:);

fprintf('Wczytano %d znaków z pliku %s.\n', length(data), filename);

%% 2. Konfiguracja symulacji
% Zakres SNR (Signal-to-Noise Ratio) w dB
snr_range = 0:2:30; 

%% 3. Uruchomienie zadań
disp('Obliczanie dla Zadania 2a (8-QAM)...');
ser_2a = zad2a(data, snr_range);

disp('Obliczanie dla Zadania 2b (2-QAM)...');
ser_2b = zad2b(data, snr_range);

disp('Obliczanie dla Zadania 2c (64-QAM)...');
ser_2c = zad2c(data, snr_range);

%% 4. Wizualizacja wyników
figure;
semilogy(snr_range, ser_2a, 'b-o', 'LineWidth', 2, 'DisplayName', '2a: 8-QAM (1 znak/sym)');
hold on;
semilogy(snr_range, ser_2b, 'r-s', 'LineWidth', 2, 'DisplayName', '2b: 2-QAM (3 sym/znak)');
semilogy(snr_range, ser_2c, 'g-^', 'LineWidth', 2, 'DisplayName', '2c: 64-QAM (0.5 sym/znak)');
hold off;

grid on;
title('Porównanie stopy błędów (SER) dla różnych modulacji');
xlabel('SNR [dB]');
ylabel('Stopa błędów odtworzenia danych wejściowych');
legend('show');
ylim([1e-5 1]); % Ograniczenie osi Y dla czytelności

disp('Zakończono.');
