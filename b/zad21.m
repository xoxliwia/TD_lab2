function ber = zad21(data, snr_vec)
% Zadanie 21: QAM-64
% Kodowanie: 1 znak ASCII (0-63) -> 1 symbol modulacji
% Wejście: data (wektor liczb 0-63), snr_vec (zakres SNR)
% Wyjście: ber (wektor błędów dla każdego SNR)

    M = 64; % Rząd modulacji
    ber = zeros(size(snr_vec));
    
    % Modulacja
    % UnitAveragePower=true jest kluczowe dla poprawnego działania funkcji awgn
    tx_sig = qammod(data, M, 'UnitAveragePower', true);
    
    for i = 1:length(snr_vec)
        % Kanał AWGN
        rx_sig = awgn(tx_sig, snr_vec(i), 'measured');
        
        % Demodulacja
        rx_data = qamdemod(rx_sig, M, 'UnitAveragePower', true);
        
        % Obliczenie stopy błędów (Symbol Error Rate dla danych wejściowych)
        [~, ratio] = symerr(data, rx_data);
        ber(i) = ratio;
    end
end
