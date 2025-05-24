clear; close all;

% Débits binaires à tester (uniquement 10 Gb/s dans ce cas)
Rb_values = [10e9];                    % Débit binaire en bps
% Plage de puissances optiques à analyser
P_opt_dBm_range = -30:0.5:-2;          % Puissance optique en dBm (plage réduite)
% Paramètres de simulation
N_bits = 1e3;                          % Nombre de bits par itération
over_samp = 10;                        % Facteur de suréchantillonnage
troncons = 2;                          % Nombre de tronçons de fibre
distance = 100/troncons;               % Longueur par tronçon en km (50 km ici)
moyenne = 10;                          % Nombre de moyennages statistiques
alpha = -0.24;                         % Coefficient d'atténuation en dB/km

% Initialisation des paramètres de transmission
Rb = Rb_values(1);                     % Sélection du débit 10 Gb/s
Ts = 1 / Rb;                           % Période symbole
bits = randi([0, 1], 1, N_bits);       % Génération des bits aléatoires

% Construction du signal NRZ suréchantillonné
over_bits = [];
for i = 1:N_bits
    over_bits = [over_bits, repmat(bits(i), 1, over_samp)]; % Répétition des bits
end

% Configuration des composants optiques
params_eml = make_emlaser('modulation', 'I', 'P_opt_dBm', 0); % Modulateur EML
params_detector = make_photodetector('B_e', Rb);              % Photodétecteur

% Initialisation du vecteur de BER
BER = zeros(1, length(P_opt_dBm_range));

%% Boucle principale sur les niveaux de puissance optique
for p_idx = 1:length(P_opt_dBm_range)
    bits_inter = bits; % Réinitialisation des bits pour chaque puissance
    errors = 0;        % Compteur d'erreurs
    
    % Boucle de moyennage statistique
    for l = 1:moyenne
        % Propagation sur plusieurs tronçons de fibre
        for it = 1:troncons
            % Régénération du signal suréchantillonné pour le tronçon actuel
            bit_in = [];
            for i = 1:N_bits
                bit_in = [bit_in, repmat(bits_inter(i), 1, over_samp)];
            end
            
            % Configuration de la puissance optique
            P_opt_dBm = P_opt_dBm_range(p_idx);
            params_eml.P_opt_dBm = P_opt_dBm;
            
            % Chaîne de transmission optique
            [S_opt, Ts_out, ~] = TX_optical_eml(bit_in, Ts/over_samp, params_eml); % Modulation
            S_out = fiber(S_opt, distance, Ts_out);                                % Propagation fibre
            [S_elec, ~, ~, ~] = RX_photodetector(S_out, Ts_out, 0, params_detector); % Détection
            
            % Calcul du seuil de décision adaptatif
            laser_power = 10^((P_opt_dBm - 30)/10);             % Conversion dBm -> W
            I1 = params_detector.sensitivity * laser_power;     % Courant photo-détecté '1'
            facteur = sqrt(distance+1)*2;                       % Facteur d'ajustement empirique
            threshold = I1 / facteur;                           % Seuil dynamique
            
            % Décision et régénération pour le prochain tronçon
            S_matrix = reshape(S_elec, over_samp, N_bits);      % Réorganisation matricielle
            mid_idx = floor(over_samp/2);                       % Index milieu symbole
            S_mid = S_matrix(mid_idx, :);                       % Échantillonnage au centre
            received_bits = S_mid > threshold;                  % Décision binaire
            bits_inter = received_bits;                         % Mise à jour pour tronçon suivant
        end
        
        % Calcul des erreurs après tous les tronçons
        errors = errors + sum(bits ~= received_bits);
    end
    
    % Calcul du BER moyen pour cette puissance
    BER(p_idx) = errors / (N_bits * moyenne);
end

%% Visualisation des résultats
figure; 
semilogy(P_opt_dBm_range, BER, 'bo-', 'LineWidth', 2, 'MarkerSize', 8); 
xlabel('Puissance optique (dBm)');
ylabel('Taux d''erreur (BER)');
title('Performance système sur plusieur morceau avec égaliseur (10 Gb/s)');
legend('10 Gb/s');
grid on;