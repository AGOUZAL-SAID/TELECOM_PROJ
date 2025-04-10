% Données fournies
NF = [0,0.31,1,1.5,2,2.5,3,3.5,4,4.5,5.14,5.8,6.01,6.02,7,7.5,8.09];
SNR_out_2 = [6.45,6.56,6.22,6.62,10.95,14.30,13.41,14.6];
SNR_out_4 = [6.2,6.66,6.27,6.22,10.67,12.52,12.86,12.83];
SNR_out_5 = [6.55,6.17,6.09,6.09,9.79,12.36,12.02,11.86];
SNR_out_6 = [5.92,6.4,6.33,5.94,9.85,11.21,11.92,11.32];
SNR_out_7 = [6.04,5.79,6.34,6.1,9.09,10.61,10.53,11.46];
SNR_out_8 = [5.91,6.1,6.19,6.14,8.35,9.95,9.88,9.81];
Nbits = [2,4,6,8,10,12,16,32];

% Calcul de la consommation électrique
P = 1e-2 ./ (10.^(NF ./ 10) - 1);

% Graphique 1: Consommation vs NF
figure;
semilogy(NF, P, 'LineWidth', 2); % Échelle logarithmique pour P
xlabel('Noise Figure (NF) [dB]');
ylabel('Consommation électrique (P) [W]');
title('Relation NF - Consommation électrique');
grid on;

% Graphique 2: SNR vs Nbits par NF
figure;
hold on;
plot(Nbits, SNR_out_2, 'd-', 'LineWidth', 1.5, 'DisplayName', 'NF = 2 dB');
plot(Nbits, SNR_out_4, '^-', 'LineWidth', 1.5, 'DisplayName', 'NF = 4 dB');
plot(Nbits, SNR_out_5, 'x-', 'LineWidth', 1.5, 'DisplayName', 'NF = 5 dB');
plot(Nbits, SNR_out_6, 'v-', 'LineWidth', 1.5, 'DisplayName', 'NF = 6 dB');
plot(Nbits, SNR_out_7, 'r-*', 'LineWidth', 1.5, 'DisplayName', 'NF = 7 dB');
plot(Nbits, SNR_out_8, 'o-', 'LineWidth', 1.5, 'DisplayName', 'NF = 8.09 dB');

xlabel('Nombre de bits (Nbits)');
ylabel('SNR_{out} [dB]');
title('Performance SNR pour différents NF');
legend('Location', 'northwest');
grid on;
set(gca, 'XTick', Nbits); % Graduations explicites pour Nbits