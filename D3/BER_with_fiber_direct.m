clear; close all;
Rb = 1e9;  % debit 
N_bits = 1e2;
laser = make_laser_simple('v', 193e12); % 1550 nm 
I_th = laser.I_th; 
IDC_values = linspace(0, 1*I_th, 100);
over_samp = 4505 ;
distance = [0,50,100,300]; % km

BER = zeros(4,length(IDC_values));
Ts = 1 / Rb; 
bits = randi([0, 1], 1, N_bits);
over_bits = bits;
params_detector = make_photodetector('B_e', Rb);
for d_idx = 1:length(distance)
    for I_idx = 1:length(IDC_values)
        IDC = IDC_values(I_idx);
        X = (over_bits *( 1.2*I_th)) + IDC;
        [S_opt, Ts_out, ~] = TX_optical_dml(X, Ts, laser);
        S_out = fiber(S_opt,distance(d_idx),Ts_out);
        [S_elec, ~, ~, ~] = RX_photodetector(S_out, Ts_out, 0, params_detector);
        threshold = (min(S_elec)+max(S_elec))/2;
        S_matrix = reshape(S_elec, over_samp, N_bits);
        mid_idx      = floor(over_samp/2);
        S_mid        = S_matrix(mid_idx, :);
        received_bits = S_mid > threshold;
        errors = sum(over_bits ~= received_bits);
        BER(d_idx,I_idx) = errors / length(over_bits);
    end
end



figure; 
hold on;
semilogy(IDC_values, BER(1,:), 'r*-', 'LineWidth', 2, 'MarkerSize', 8); 
semilogy(IDC_values, BER(2,:), 'g*-', 'LineWidth', 2, 'MarkerSize', 8); 
semilogy(IDC_values, BER(3,:), 'b*-', 'LineWidth', 2, 'MarkerSize', 8); 
semilogy(IDC_values, BER(4,:), 'r-', 'LineWidth', 2, 'MarkerSize', 8); 
xlabel('bias current (A)');
ylabel('BER ');
title('BER vs. Optical Power for OOK Back-to-Back System');
legend('0 km','50 km','100 km','300km');
grid on;
hold off;