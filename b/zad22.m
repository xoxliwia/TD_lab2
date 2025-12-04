function ber = zad22(data, snr_vec)
% Zadanie 22: QAM-4
% Kodowanie: 1 znak ASCII (6 bitów) -> 3 symbole modulacji (po 2 bity)
% M = 4 (2 bity na symbol)

    M = 4;
    ber = zeros(size(snr_vec));
    
    % --- KODOWANIE ---
    % 1. Zamiana liczb 0-63 na bity (6 bitów na liczbę)
    data_bin = de2bi(data, 6, 'left-msb'); 
    
    % 2. Zmiana formatu: chcemy grupować po 2 bity
    % Transpozycja i reshape tworzy jeden długi strumień bitów,
    % który następnie tniemy na kawałki po 2 bity.
    bits_stream = reshape(data_bin', 2, [])';
    
    % 3. Zamiana par bitów na liczby 0-3 (indeksy symboli QAM4)
    tx_symbols_idx = bi2de(bits_stream, 'left-msb');
    
    % 4. Modulacja
    tx_sig = qammod(tx_symbols_idx, M, 'UnitAveragePower', true);
    
    for i = 1:length(snr_vec)
        % Kanał AWGN
        rx_sig = awgn(tx_sig, snr_vec(i), 'measured');
        
        % Demodulacja do symboli 0-3
        rx_demod_idx = qamdemod(rx_sig, M, 'UnitAveragePower', true);
        
        % --- DEKODOWANIE ---
        % 1. Zamiana odebranych symboli (0-3) na pary bitów
        rx_bits_stream = de2bi(rx_demod_idx, 2, 'left-msb');
        
        % 2. Odtworzenie struktury 6-bitowej (grupowanie po 3 pary bitów)
        rx_bits_reshaped = reshape(rx_bits_stream', 6, [])';
        
        % 3. Zamiana na liczby 0-63 (znaki ASCII)
        rx_data = bi2de(rx_bits_reshaped, 'left-msb');
        
        % Obliczenie błędów (porównujemy odzyskane ZNAKI z oryginałem)
        [~, ratio] = symerr(data, rx_data);
        ber(i) = ratio;
    end
end
