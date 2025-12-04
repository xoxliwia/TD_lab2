function [ser] = zad2c(data, snr_range)
    % Zadanie 2c - QAM 64
    % Kodowanie: 2 znaki ASCII na 1 symbol modulacji
    
    M = 64;
    
    % Sprawdzenie parzystości długości danych
    if mod(length(data), 2) ~= 0
        data_to_mod = data(1:end-1); % Odrzucamy ostatni znak jeśli nieparzysta
    else
        data_to_mod = data;
    end
    
    % Grupowanie po 2 znaki
    % reshape tworzy macierz 2 wierszową
    pairs = reshape(data_to_mod, 2, []);
    
    % Konwersja dwóch liczb 0-7 na jedną liczbę 0-63
    % Wzór: High * 8 + Low
    symbols_in = pairs(1,:) * 8 + pairs(2,:);
    
    % Modulacja
    tx_sig = qammod(symbols_in, M);
    
    ser = zeros(size(snr_range));
    
    for i = 1:length(snr_range)
        snr = snr_range(i);
        
        % Kanał AWGN
        rx_sig = awgn(tx_sig, snr, 'measured');
        
        % Demodulacja
        rx_symbols = qamdemod(rx_sig, M);
        
        % Dekodowanie z powrotem na pary liczb 0-7
        rx_row1 = floor(rx_symbols / 8);
        rx_row2 = mod(rx_symbols, 8);
        
        % Złożenie w wektor
        rx_data = [rx_row1; rx_row2];
        rx_data = reshape(rx_data, [], 1);
        
        % Obliczenie błędu
        [~, ratio] = biterr(data_to_mod, rx_data);
        ser(i) = ratio;
    end
end
