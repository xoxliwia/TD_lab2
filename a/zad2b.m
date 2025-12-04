function [ser] = zad2b(data, snr_range)
    % Zadanie 2b - QAM 2 (BPSK)
    % Kodowanie: 1 znak ASCII (3 bity) na 3 symbole modulacji
    
    M = 2; % Rząd modulacji (2-QAM / BPSK)
    
    % Konwersja liczb 0-7 na bity (de2bi zwraca macierz, gdzie wiersz to liczba)
    % Używamy 3 bitów na liczbę.
    bits_matrix = de2bi(data, 3, 'left-msb');
    
    % Spłaszczenie do jednego wektora bitów
    tx_bits = reshape(bits_matrix.', [], 1);
    
    % Modulacja
    tx_sig = qammod(tx_bits, M);
    
    ser = zeros(size(snr_range));
    
    for i = 1:length(snr_range)
        snr = snr_range(i);
        
        % Kanał AWGN
        rx_sig = awgn(tx_sig, snr, 'measured');
        
        % Demodulacja
        rx_bits_stream = qamdemod(rx_sig, M);
        
        % Odtwarzanie struktury danych (grupowanie po 3 bity)
        % Należy upewnić się, że liczba bitów jest podzielna przez 3
        rx_bits_matrix = reshape(rx_bits_stream, 3, []).';
        
        % Konwersja bitów z powrotem na liczby 0-7
        rx_data = bi2de(rx_bits_matrix, 'left-msb');
        
        % Obliczenie błędu względem oryginalnych liczb 0-7
        [~, ratio] = biterr(data, rx_data);
        ser(i) = ratio;
    end
end
