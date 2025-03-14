clear; close all; clc;

% Define parameters
tau = [0,0.5,1,1.5,2];
A_1 = [1,0.1,0.1,0.1,0.1];
A_2 = [1,0.8,0.6,0.4,0.2];
A_3 = [1,0.8,0.8,0.8,0.8];
Ts = 0.05e-6;
L = 4;
m = -L:1:L;
N = 1000;

% Generate and normalize channel impulse responses
h1 = filtre_canal(m, A_1, tau, Ts, L);
h1_norm = h1 / norm(h1);
h2 = filtre_canal(m, A_2, tau, Ts, L);
h2_norm = h2 / norm(h2);
h3 = filtre_canal(m, A_3, tau, Ts, L);
h3_norm = h3 / norm(h3);

% Plot impulse response
figure;
plot(m, h1_norm, 'r', 'LineWidth',1); hold on;
plot(m, h2_norm, 'g', 'LineWidth',1);
plot(m, h3_norm, 'b', 'LineWidth',1);
xlabel('m'); ylabel('h(m)');
legend('Canal 1', 'Canal 2', 'Canal 3');
title('Réponse impulsionnelle des canaux normalisés');
grid on;

% Define channel matrices (Toeplitz remains unchanged)
H1 = zeros(N, N);
H2 = zeros(N, N);
H3 = zeros(N, N);

%Mise en Forme Toeplitz
for i = 1:N
    for j = 1:N
        if (j - i) >= -L && (j - i) <= L  
            H1(i, j) = h1_norm(j - i + L + 1);
            H2(i, j) = h2_norm(j - i + L + 1);
            H3(i, j) = h3_norm(j - i + L + 1);
        end
    end
end

H_tab = {H1, H2, H3};

% Modulation parameters
modulations = {'PSK', 2; 'QAM', 8; 'QAM', 16};
M_values = [2, 8, 16];

% Loop over modulations (BPSK, 8-QAM, 16-QAM)
for mod_idx = 1:length(modulations)
    mod = modulations{mod_idx, 1};
    M = modulations{mod_idx, 2};
    
    k = log2(M); % Number of bits per symbol
    Eb = 1; % Normalized energy per bit
    N_bits = N * k; % Ensure N_bits is a multiple of k
    
    % Define SNR range
    if M == 2
        SNR_dB = 0:2:20; % BPSK
    else
        SNR_dB = 0:2:30; % QAM
    end
    SNR = 10.^(SNR_dB/10); % Convert to linear scale

    % Initialize BER matrices
    BER_Threshold = zeros(3, length(SNR_dB));
    BER_ZFE = zeros(3, length(SNR_dB));
    BER_DFE = zeros(3, length(SNR_dB));

    % Loop over channels
    for i = 1:length(H_tab)
        H = H_tab{i}; % Select channel

        % Loop over SNR values
        for j = 1:length(SNR_dB)
            N0 = (Eb / k) / SNR(j); % Adjust noise variance for QAM

            % Generate bits and map to symbols
            bits_emis = randi([0, 1], 1, N_bits);
            s_emis = bits2symbols(bits_emis, mod, M);

            % Generate AWGN noise
            noise_var = sqrt(N0/2);
            w = noise_var * (randn(length(s_emis),1) + 1i * randn(length(s_emis),1));

            % Transmit through channel
            z = H * s_emis + w;

            % Threshold Detector (No equalization)
            s_recu_threshold = threshold_detector(z, mod, M);
            bits_recu_threshold = symbols2bits(s_recu_threshold, mod, M);
            BER_Threshold(i, j) = sum(bits_emis ~= bits_recu_threshold) / length(bits_emis);

            % Zero-Forcing Equalizer (ZFE)
            BER_ZFE(i, j) = ZFE(bits_emis, z, H, mod, M);

            % Decision Feedback Equalizer (DFE)
            BER_DFE(i, j) = DFE(bits_emis, z, H, mod, M);
        end
    end

    % Plot BER curves
    figure;
    colors = {'r', 'g', 'b'};
    markers = {'o', 's', '^'};

    for c = 1:3
        semilogy(SNR_dB, BER_Threshold(c, :), [colors{c}, '--', markers{1}], 'LineWidth', 1.5); hold on;
        semilogy(SNR_dB, BER_ZFE(c, :), [colors{c}, '-', markers{2}], 'LineWidth', 1.5);
        semilogy(SNR_dB, BER_DFE(c, :), [colors{c}, '-.', markers{3}], 'LineWidth', 1.5);
    end

    xlabel('E_b/N_0 (dB)'); ylabel('BER');
    title(sprintf('BER vs E_b/N_0 for %d-%s with 3 Equalizers', M, mod));
    legend({'Threshold - Canal 1', 'ZF - Canal 1', 'DFE - Canal 1', ...
            'Threshold - Canal 2', 'ZF - Canal 2', 'DFE - Canal 2', ...
            'Threshold - Canal 3', 'ZF - Canal 3', 'DFE - Canal 3'});
    grid on;
end
