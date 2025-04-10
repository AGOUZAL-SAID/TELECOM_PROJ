clear; close all; clc;

% Paramètres du canal
tau = [0, 0.5, 1, 1.5, 2]; % Délais des trajets multiples
A_1 = [1, 0.1, 0.1, 0.1, 0.1]; % Atténuations du canal 1
A_2 = [1, 0.8, 0.6, 0.4, 0.2]; % Atténuations du canal 2
A_3 = [1, 0.8, 0.8, 0.8, 0.8]; % Atténuations du canal 3
Ts = 0.05e-6; % Période d'échantillonnage
L = 4; % Longueur du canal
m = -L:1:L; 
N = 1000; % 10 trames de Longueur 100

% Création des réponses impulsionnelles du canal
h1 = filtre_canal(m, A_1, tau, Ts, L);
h1_norm = h1 / norm(h1);
h2 = filtre_canal(m, A_2, tau, Ts, L);
h2_norm = h2 / norm(h2);
h3 = filtre_canal(m, A_3, tau, Ts, L);
h3_norm = h3 / norm(h3);

figure;
plot(m, h1_norm, 'r', 'LineWidth', 1); hold on;
plot(m, h2_norm, 'g', 'LineWidth', 1);
plot(m, h3_norm, 'b', 'LineWidth', 1);
xlabel('m'); ylabel('h(m)');
legend('Canal 1', 'Canal 2', 'Canal 3');
title('Réponse impulsionnelle des canaux normalisés');
grid on;

% Création des matrices de canal
H1 = zeros(N, N);
H2 = zeros(N, N);
H3 = zeros(N, N);

% Boucle de remplissage des matrices Toeplitz
for i = 1:N
    for j = 1:N
        if (j - i) >= -L && (j - i) <= L  
            H1(i, j) = h1_norm(j - i + L + 1);
            H2(i, j) = h2_norm(j - i + L + 1);
            H3(i, j) = h3_norm(j - i + L + 1);
        end
    end
end

H_tab = {H1, H2, H3}; % Tableau des matrices de canal

% Paramètres de modulation
modulations = {'PSK', 2; 'QAM', 8; 'QAM', 16}; % Différentes modulations
M_values = [2, 8, 16]; % Tailles des constellations

for mod_idx = 1:length(modulations)
    mod = modulations{mod_idx, 1};
    M = modulations{mod_idx, 2};
    
    k = log2(M); % Nombre de bits par symbole
    
    Es_avg = mean(abs(symbols_lut(mod, M)).^2); % Énergie moyenne par symbole
    Eb = Es_avg / k; 

    N_bits = N * k; % On s'assure que N_bits est un multiple de k 
    
    if M == 2
        SNR_dB = 0:2:20; % BPSK
    else
        SNR_dB = 0:2:30; % QAM
    end
    SNR = 10.^(SNR_dB/10); % SNR en linéaire

    % Initialisation des tableaux de BER
    BER_Threshold = zeros(3, length(SNR_dB));
    BER_ZFE = zeros(3, length(SNR_dB));
    BER_DFE = zeros(3, length(SNR_dB));

    % Boucle sur les canaux
    for i = 1:length(H_tab)
        H = H_tab{i}; % Sélection du canal

        for j = 1:length(SNR_dB)
            N0 = Eb / SNR(j); 

            % 🛠 Génération des bits et symboles à émettre
            bits_emis = randi([0, 1], 1, N_bits);
            s_emis = bits2symbols(bits_emis, mod, M);

            % Génération du bruit AWGN
            w = sqrt(N0 / 2) * (randn(length(s_emis), 1) + 1i * randn(length(s_emis), 1));

            % Transmission à travers le canal
            z = H * s_emis + w;

            % Détecteur à seuil
            s_recu_threshold = threshold_detector(z, mod, M);
            bits_recu_threshold = symbols2bits(s_recu_threshold, mod, M);
            BER_Threshold(i, j) = sum(bits_emis ~= bits_recu_threshold) / length(bits_emis);

            % Égaliseur ZFE
            BER_ZFE(i, j) = ZFE(bits_emis, z, H, mod, M);

            % Égaliseur DFE
            BER_DFE(i, j) = DFE(bits_emis, z, H, mod, M);
        end
    end

    % Affichage des courbes BER en echelle logarithmique
    figure;
    colors = {'r', 'g', 'b'}; 
    markers = {'o', 's', '^'};

    for c = 1:3
        semilogy(SNR_dB, BER_Threshold(c, :), [colors{c}, '--', markers{1}], 'LineWidth', 1); hold on;
        semilogy(SNR_dB, BER_ZFE(c, :), [colors{c}, '-', markers{2}], 'LineWidth', 1);
        semilogy(SNR_dB, BER_DFE(c, :), [colors{c}, '-.', markers{3}], 'LineWidth', 1);
    end

    xlabel('E_b/N_0 (dB)'); ylabel('BER');
    title(sprintf('BER vs E_b/N_0 pour %d-%s avec 3 égaliseurs', M, mod));
    legend({'Threshold - Canal 1', 'ZF - Canal 1', 'DFE - Canal 1', ...
            'Threshold - Canal 2', 'ZF - Canal 2', 'DFE - Canal 2', ...
            'Threshold - Canal 3', 'ZF - Canal 3', 'DFE - Canal 3'});
    grid on;
end
