clear; close all;
Rb = 1e9;  % debit 
N_bits = 1e1;
laser = make_laser_simple('v', 193e12); % 1550 nm 
I_th = laser.I_th; 
IDC_values = linspace(0, 2*I_th, 50);
over_samp = 10 ;
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
    X = (over_bits *( 3*I_th)) + IDC;
    [S_opt, Ts_out, ~] = TX_optical_dml(X, Ts, laser);
    S_out = fiber(S_opt,distance,Ts_out);
    [S_elec, ~, ~, ~] = RX_photodetector(S_out, Ts_out, 0, params_detector);
    threshold = (3*I_th) / 2 + IDC;
    received_bits = (S_elec*params_detector.sensitivity) > threshold;
     received_bits = [];
    for i= 0:((N_bits-1)*over_samp)
        a = S_elec(2252+4505*i);
        b = a*params_detector.sensitivity > threshold;
        received_bits = [received_bits,b];
    end
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