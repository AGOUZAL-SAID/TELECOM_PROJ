clear; close all;
Rb = 1e9; % Bit rates in bps
N_bits = 1e1;% Number of bits to simulate
laser = make_laser_simple('v', 193e12); % 1550 nm 
I_th = laser.I_th; % Threshold current
IDC_values = linspace(0, 2*I_th, 50);
over_samp = 4505 ;
distance = 0; % km

BER = zeros(1,length(IDC_values));
Ts = 1 / Rb; 
bits = randi([0, 1], 1, N_bits);
over_bits = [];
for i = 1:1:N_bits
    for j = 1:1:over_samp
        over_bits = [over_bits,bits(i)];
    end
end
params_detector = make_photodetector('B_e', Rb);
for I_idx = 1:length(IDC_values)
    IDC = IDC_values(I_idx);
    X = bits *(IDC + I_th);
    [S_opt, Ts_out, ~] = TX_optical_dml(X, Ts, laser);
    [S_out,sur_sig] = fiber(S_opt,distance,Ts_out,1);
    [S_elec, ~, ~, ~] = RX_photodetector(S_out, Ts_out, 0, params_detector);
    threshold = (IDC + I_th) / 2;
    received_bits = (S_elec*params_detector.sensitivity) > threshold;
    errors = sum(over_bits ~= received_bits);
    BER(I_idx) = errors / length(over_bits);
end



figure; 
hold on;
semilogy(IDC_values, BER, 'r*-', 'LineWidth', 2, 'MarkerSize', 8); 
xlabel('bias current (A)');
ylabel('BER ');
title('BER vs. Optical Power for OOK Back-to-Back System');
legend('1 Gb/s');
grid on;
hold off;