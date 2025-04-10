NF_db = [50.24,38.2,32.19,26.17,14.29,0.50];
Nbits = [10,12,13,14,16,20];
% Données d'entrée
NF_Filtre = 0; % Filtre N
NF_BB = 10; % BB NF
NF_ADC =NF_db; % ADC NF
% Gains en dB
G_LNA_db = 15; % Gain du LNA en dB
G_Filtre_db = -0.5; % Gain du Filtre en dB
G_BB_db = 19.03; % Gain du BB en dB

% Conversion des NF en Linéaire (non dB)
F_Filtre = 10^(NF_Filtre/10);
F_BB = 10^(NF_BB/10);
F_ADC = 10.^(NF_ADC / 10);

% Conversion des gains en Linéaire
G_LNA = 10^(G_LNA_db/10);
G_Filtre = 10^(G_Filtre_db/10);
G_BB = 10^(G_BB_db/10);

% Calcul de NF_tot (total NF)
F_tot = 10^(6.36/10);

% Calcul du NF du LNA à partir de la formule de Friis
NF_LNA = F_tot - (F_Filtre - 1) / G_LNA - (F_BB - 1) / (G_LNA * G_Filtre) - (F_ADC - 1) / (G_LNA * G_Filtre * G_BB);
NF_LNA_db = zeros(size(NF_LNA));
for i = 1:length(NF_LNA)
    if NF_LNA(i) > 0
        NF_LNA_db(i) = 10 * log10(NF_LNA(i)); % Appliquer log10 pour les valeurs positives
    else
        NF_LNA_db(i) = -100; % Valeur très négative pour les valeurs négatives
    end
end

% Affichage du résultat
plot(Nbits, NF_LNA_db, 'r-', 'MarkerSize', 8, 'LineWidth', 2);  
xlabel('Nbits ADC ');
ylabel('NF (dB)');
title('Facteur de bruit de LNA');
