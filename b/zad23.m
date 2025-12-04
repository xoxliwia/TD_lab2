function ber = zad23(data, snr_vec)
% Zadanie 23: QAM-4096
% Kodowanie: 2 znaki ASCII (12 bitów łącznie) -> 1 symbol modulacji
% M = 4096 (12 bitów na symbol)

    M = 4096;
    ber = zeros(size(snr_vec));
    
    % Sprawdzenie parzystości danych (wymagane do parowania)
    if mod(length(data), 2) ~= 0
        % Jeśli nieparzysta liczba znaków, dodajemy padding (0)
        data = [data; 0];
    end
    
    % --- KODOWANIE ---
    % Zmiana wektora Nx1 na macierz 2x(N/2), a potem transpozycja na (N/2)x2
    % Kolumna 1 to starsze bity (pierwszy znak), Kolumna 2 to młodsze (drugi znak)
    pairs = reshape(data, 2, [])';
    
    % Łączenie: (Znak1 * 64) + Znak2 = Wartość 12-bitowa (0-4095)
    tx_symbols_idx = pairs(:,1) * 64 + pairs(:,2);
    
    % Modulacja
    tx_sig = qammod(tx_symbols_idx, M, 'UnitAveragePower', true);
    
    for i = 1:length(snr_vec)
        % Kanał AWGN
        rx_sig = awgn(tx_sig, snr_vec(i), 'measured');
        
        % Demodulacja
        rx_demod_idx = qamdemod(rx_sig, M, 'UnitAveragePower', true);
        
        % --- DEKODOWANIE ---
        % Rozdzielenie wartości 12-bitowej z powrotem na dwa znaki 6-bitowe
        char1 = floor(rx_demod_idx / 64);
        char2 = mod(rx_demod_idx, 64);
        
        % Złożenie z powrotem w jeden wektor kolumnowy
        rx_data = reshape([char1, char2]', [], 1);
        
        % Obliczenie błędów
        % Uwaga: Porównujemy oryginalne dane (z ewentualnym paddingiem)
        [~, ratio] = symerr(data, rx_data);
        ber(i) = ratio;
    end
end
