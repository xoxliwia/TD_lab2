% run.m
clear; clc; close all;

% 1. Wczytanie danych z pliku
filename = 'plik.txt';

% Sprawdzenie czy plik istnieje (dla bezpieczeństwa)
if ~isfile(filename)
    error('Brak pliku plik.txt w katalogu roboczym!');
end

% Wczytanie 1000 słów jako cell array
raw_data = textread(filename, '%s', 1000); 

% Konwersja z cell array do jednej długiej tablicy znaków
char_data = cell2mat(raw_data); 
% Konwersja do double i rzutowanie na wektor kolumnowy
data_vector = double(char_data(:));

% 2. Optymalne mapowanie na zakres <0; 63>
% Operacja modulo 64 pozwala na unikalne zmapowanie liter A-Z i a-z 
% na liczby 6-bitowe bez kolizji.
mapped_data = mod(data_vector, 64);

% Sprawdzenie poprawności zakresu
if any(mapped_data > 63) || any(mapped_data < 0)
    error('Błąd mapowania danych. Wartości poza zakresem <0; 63>.');
end

% 3. Parametry symulacji
% Zakres SNR (dB) - dobrany tak, aby pokazać "wodospad" błędów dla każdej modulacji
snr_range = 0:2:60; 

fprintf('Rozpoczynanie symulacji...\n');

% 4. Uruchomienie poszczególnych zadań
fprintf('Obliczanie Zadanie 21 (QAM-64)...\n');
ber21 = zad21(mapped_data, snr_range);

fprintf('Obliczanie Zadanie 22 (QAM-4)...\n');
ber22 = zad22(mapped_data, snr_range);

fprintf('Obliczanie Zadanie 23 (QAM-4096)...\n');
ber23 = zad23(mapped_data, snr_range);

% 5. Prezentacja wyników
figure;
semilogy(snr_range, ber21, '-o', 'LineWidth', 1.5, 'DisplayName', 'Zad 21: QAM-64 (1 znak/sym)');
hold on;
semilogy(snr_range, ber22, '-s', 'LineWidth', 1.5, 'DisplayName', 'Zad 22: QAM-4 (1 znak/3 sym)');
semilogy(snr_range, ber23, '-^', 'LineWidth', 1.5, 'DisplayName', 'Zad 23: QAM-4096 (2 znaki/sym)');
grid on;
xlabel('SNR [dB]');
ylabel('Stopa błędu znaku (Character Error Rate)');
title('Porównanie stopy błędów dla różnych konstelacji QAM');
legend('Location', 'southwest');
ylim([1e-5 1]); % Ograniczenie osi Y dla czytelności
