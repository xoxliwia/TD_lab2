function [ser] = zad2a(data, snr_range)
    % Zadanie 2a - QAM 8
    % Kodowanie: 1 znak (wartość 0-7) na 1 symbol modulacji
    
    M = 8; % Rząd modulacji
    
    % Modulacja
    % Dane wejściowe są już w zakresie 0-7, co idealnie pasuje do 8-QAM
    tx_sig = qammod(data, M);
    
    ser = zeros(size(snr_range));
    
    % Pętla po wartościach SNR
    for i = 1:length(snr_range)
        snr = snr_range(i);
        
        % Kanał transmisyjny (szum Gaussa)
        rx_sig = awgn(tx_sig, snr, 'measured');
        
        % Demodulacja
        rx_data = qamdemod(rx_sig, M);
        
        % Obliczenie stopy błędu (Symbol Error Rate dla danych wejściowych)
        [~, ratio] = biterr(data, rx_data);
        ser(i) = ratio;
    end
end
