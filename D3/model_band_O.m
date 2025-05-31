clear; close all;

% Débits binaires à tester
Rb_values       = [10e9];    % en bps
% Plage de puissances optiques
P_opt_dBm_range = -25:0.5:30;            % en dBm
% Paramètres de la simulation
N_bits    = 1e3;      % nombre de bits simulés
over_samp = 10;       % facteur d’oversampling
distance  = 100;       % distance de propagation en fibre (km)
alpha     = -0.35;    % atténuation linéique (dB/km)
moyennage = 250;       % nombre de répétitions pour moyennage

% Préallocation du vecteur de BER
BER = zeros(length(Rb_values), length(P_opt_dBm_range));

%% Boucle sur chaque débit binaire
for rb_idx = 1:length(Rb_values)
    Rb   = Rb_values(rb_idx);      % débit actuel
    Ts   = 1 / Rb;                 % durée d’un symbole (s)
    bits = randi([0, 1], 1, N_bits); % génération aléatoire des bits
    
    % Construction du signal NRZ suréchantillonné
    over_bits = [];
    for i = 1:N_bits
        for j = 1:over_samp
            over_bits = [over_bits, bits(i)];  % répéter chaque bit
        end
    end
    
    % Initialisation du modulateur externe et du photodétecteur
    params_eml      = make_emlaser('modulation', 'I', 'P_opt_dBm', 0);
    params_detector = make_photodetector('B_e', Rb);
    
    %% Boucle sur chaque niveau de puissance optique
    for p_idx = 1:length(P_opt_dBm_range)
        errors = 0;  % compteur d’erreurs pour cette configuration
        
        for m = 1:moyennage
            % Mise à jour de la puissance optique du modulateur
            P_opt_dBm       = P_opt_dBm_range(p_idx);
            params_eml.P_opt_dBm = P_opt_dBm;
            
            % Modulation optique (émission du signal)
            [S_opt, Ts_out, ~] = TX_optical_eml(over_bits, Ts/over_samp, params_eml);
            
            % Propagation en fibre
            S_out = fiber_o(S_opt, distance, Ts_out);
            
            % Détection opto-électronique (photodiode)
            [S_elec, ~, ~, ~] = RX_photodetector(S_out, Ts_out, 0, params_detector);
            
            % Calcul du seuil de décision (moitié du courant ‘1’ atténué)
            laser_power = 10^((P_opt_dBm - 30)/10);                        % conversion dBm→W
            I1          = params_detector.sensitivity * laser_power * 10^(alpha*distance/10);
            threshold   = I1 / 2;
            
            % Reshape pour extraire l’échantillon central de chaque symbole
            S_mid        = reshape(S_elec, over_samp, N_bits);
            median       = S_mid(round(over_samp/2), :);
            received_bits = median > threshold;  % décision binaire
            
            % Accumulation du nombre d’erreurs
            errors = errors + sum(bits ~= received_bits);
        end
        
        % Calcul de la BER moyenne pour ce débit et cette puissance
        BER(rb_idx, p_idx) = errors / (N_bits * moyennage);
    end
end

%% Affichage des résultats
figure;
semilogy(P_opt_dBm_range , BER(1,:), 'bo-', 'LineWidth', 2, 'MarkerSize', 8);

xlabel('Optical Power (dBm)');        % étiquette de l’axe des abscisses
ylabel('BER');                        % étiquette de l’axe des ordonnées
title('BER vs. Optical Power for OOK fiber propagation'); % titre du graphique
legend( '10 Gb/s', 'Location','best'); % légende
grid on; 
hold off;
