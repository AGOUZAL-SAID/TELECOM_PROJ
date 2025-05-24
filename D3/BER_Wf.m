clear; close all;

% Définition des paramètres principaux
Rb_values        = [2.5e9, 5e9, 10e9];    % débits binaires (bps)
P_opt_dBm_range  = -30:0.5:-15;           % puissance optique (dBm)
N_bits           = 1e3;                   % nombre de bits simulés
over_samp        = 10;                    % facteur d’oversampling
max_iter         = 2000;                  % nombre d’itérations pour moyennage

% Préallocation de la matrice de BER
BER = zeros(length(Rb_values), length(P_opt_dBm_range));

for rb_idx = 1:length(Rb_values)
    Rb   = Rb_values(rb_idx);       % débit actuel
    Ts   = 1 / Rb;                  % durée symbole (s)
    bits = randi([0, 1], 1, N_bits);% trame binaire aléatoire
    
    % Génération du signal NRZ suréchantillonné
    over_bits = [];
    for i = 1:N_bits
        for j = 1:over_samp
            over_bits = [over_bits, bits(i)];  % répète chaque bit over_samp fois
        end
    end
    
    % Initialisation du modulateur externe et du photodétecteur
    params_eml     = make_emlaser('modulation', 'I', 'P_opt_dBm', 0);
    params_detector = make_photodetector('B_e', Rb);
    
    for p_idx = 1:length(P_opt_dBm_range)
        errors = 0;  % compteur d’erreurs pour cette puissance
        
        for iter = 1:max_iter
            % Mise à jour de la puissance du laser
            P_opt_dBm = P_opt_dBm_range(p_idx);
            params_eml.P_opt_dBm = P_opt_dBm;
            
            % Modulation optique (émission)
            [S_opt, Ts_out, ~] = TX_optical_eml(over_bits, Ts, params_eml);
            % Détection directe (sans fibre)
            [S_elec, ~, ~, ~] = RX_photodetector(S_opt, Ts_out, 0, params_detector);
            
            % Calcul du seuil de décision (moitié du niveau ‘1’)
            laser_power = 10^((P_opt_dBm - 30)/10);  % convert dBm → W
            I1 = params_detector.sensitivity * laser_power;
            threshold = I1 / 2;
            
            % Reshape pour extraire l’échantillon central de chaque bit
            S_matrix     = reshape(S_elec, over_samp, N_bits);
            mid_idx      = floor(over_samp/2);       % index central
            S_mid        = S_matrix(mid_idx, :);     % valeur centrale de chaque symbole
            received_bits = S_mid > threshold;       % décision binaire
            
            % Comptage des erreurs bit à bit
            errors = errors + sum(bits ~= received_bits);
        end
        
        % Calcul de la BER moyenne pour ce débit et cette puissance
        BER(rb_idx, p_idx) = errors / (N_bits * max_iter);
    end
end

% Affichage des courbes de BER
figure; 
semilogy(P_opt_dBm_range, BER(1,:), 'bo-', 'LineWidth', 2, 'MarkerSize', 8); hold on;
semilogy(P_opt_dBm_range, BER(2,:), 'r*-', 'LineWidth', 2, 'MarkerSize', 8);
semilogy(P_opt_dBm_range, BER(3,:), 'gs-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Optical Power (dBm)');
ylabel('BER');
title('BER vs. Optical Power for OOK Back-to-Back System');
legend('2.5 Gb/s', '5 Gb/s', '10 Gb/s', 'Location','best');
grid on;
hold off;
