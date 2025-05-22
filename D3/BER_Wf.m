clear; close all;
Rb_values = [2.5e9, 5e9, 10e9]; % Bit rates in bps
P_opt_dBm_range = -30:0.25:-15;      % Optical power range in dBm
N_bits = 1e3;                   % Number of bits to simulate
over_samp = 10;
BER_rego_1 = [];
BER_rego_2 = [];
BER_rego_3 = [];
P_rego_1 = [];
P_rego_2 = [];
P_rego_3 = [];
max_iter = 100;
tol = 3e-3;


BER = zeros(length(Rb_values), length(P_opt_dBm_range));

for rb_idx = 1:length(Rb_values)
    Rb = Rb_values(rb_idx);
    Ts = 1 / Rb; 
    bits = randi([0, 1], 1, N_bits);
    over_bits = [];
    for i = 1:1:N_bits
        for j = 1:1:over_samp
            over_bits = [over_bits,bits(i)];
        end
    end
    params_eml = make_emlaser('modulation', 'I', 'P_opt_dBm', 0);
    params_detector = make_photodetector('B_e', Rb);
    
    for p_idx = 1:length(P_opt_dBm_range)
            P_opt_dBm = P_opt_dBm_range(p_idx);
            params_eml.P_opt_dBm = P_opt_dBm; 
            [S_opt, Ts_out, ~] = TX_optical_eml(over_bits, Ts, params_eml);
            [S_elec, ~, ~, ~] = RX_photodetector(S_opt, Ts_out, 0, params_detector);
            laser_power = 10^((P_opt_dBm - 30)/10);
            I1 = params_detector.sensitivity * laser_power;
            threshold = I1 / 2 ;
            S_matrix = reshape(S_elec, over_samp, N_bits);
            mid_idx      = floor(over_samp/2);
            S_mid        = S_matrix(mid_idx, :);
            received_bits = S_mid > threshold;
            errors = sum(bits ~= received_bits);
            BER(rb_idx, p_idx) = errors / N_bits;
    end
    comptage = 0;
    P = P_opt_dBm_range;
    BER_i = BER(rb_idx,:);
    while comptage<max_iter
        comptage = comptage+1;
        rafiner = false;
        L = length(P);
        for k = round(L/2):L-1
            if BER_i(k+1)-BER_i(k)>tol
                P_opt_dBm = p_moy;
                params_eml.P_opt_dBm = P_opt_dBm; 
                [S_opt, Ts_out, ~] = TX_optical_eml(over_bits, Ts, params_eml);
                [S_elec, ~, ~, ~] = RX_photodetector(S_opt, Ts_out, 0, params_detector);
                laser_power = 10^((P_opt_dBm - 30)/10);
                I1 = params_detector.sensitivity * laser_power;
                threshold = I1 / 2 ;
                S_matrix = reshape(S_elec, over_samp, N_bits);
                mid_idx      = floor(over_samp/2);
                S_mid        = S_matrix(mid_idx, :);
                received_bits = S_mid > threshold;
                errors = sum(bits ~= received_bits);
                temp = errors / N_bits;
                P = [P,p_moy];
                BER_i = [BER_i,temp];
                [P, idx] = sort(P);
                BER_i = BER_i(idx);
                rafiner = true;

            end
        end
        if ~rafiner
            break
        end
    end
    if rb_idx == 1 
        P_rego_1 = P;
        BER_rego_1 = BER_i;  
    elseif rb_idx == 2
        P_rego_2 = P;
        BER_rego_2 = BER_i;
    else
        P_rego_3 = P;
        BER_rego_3 = BER_i;
    end
        
end


figure; 
    semilogy(P_rego_1, BER_rego_1, 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
    hold on;
    semilogy(P_rego_2, BER_rego_2, 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
    semilogy(P_rego_3, BER_rego_3, 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2
    xlabel('Optical Power (dBm)');
    ylabel('BER ');
    title('BER vs. Optical Power for OOK Back-to-Back System');
    legend('2.5 Gb/s', '5 Gb/s', '10 Gb/s');
    grid on;
    hold off;