clear; close all;
Rb_values = [2.5e9, 5e9, 10e9]; % Bit rates in bps
P_opt_dBm_range = -30:0.1:-15;      % Optical power range in dBm
N_bits = 1e3;                   % Number of bits to simulate

BER = zeros(length(Rb_values), length(P_opt_dBm_range));

for rb_idx = 1:length(Rb_values)
    Rb = Rb_values(rb_idx);
    Ts = 1 / Rb; 
    bits = randi([0, 1], 1, N_bits);
    params_eml = make_emlaser('modulation', 'I', 'P_opt_dBm', 0);
    params_detector = make_photodetector('B_e', Rb);
    
    for p_idx = 1:length(P_opt_dBm_range)
        P_opt_dBm = P_opt_dBm_range(p_idx);
        params_eml.P_opt_dBm = P_opt_dBm; 

        [S_opt, Ts_out, ~] = TX_optical_eml(bits, Ts, params_eml);
        [S_elec, ~, ~, ~] = RX_photodetector(S_opt, Ts_out, 0, params_detector);
        laser_power = 10^((P_opt_dBm - 30)/10);
        I1 = params_detector.sensitivity * laser_power;
        threshold = I1 / 2;
        received_bits = S_elec > threshold;
        errors = sum(bits ~= received_bits);
        BER(rb_idx, p_idx) = errors / N_bits;
    end
end


figure; 
    semilogy(P_opt_dBm_range, BER(1,:), 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
    hold on;
    semilogy(P_opt_dBm_range, BER(2,:), 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
    semilogy(P_opt_dBm_range, BER(3,:), 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2
    xlabel('Optical Power (dBm)');
    ylabel('BER ');
    title('BER vs. Optical Power for OOK Back-to-Back System');
    legend('2.5 Gb/s', '5 Gb/s', '10 Gb/s');
    grid on;
    hold off;