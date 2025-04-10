clear; close all;
ACPR_db_RF = [55.54,53.17,52.65,53.14,53.1842,50.99,51.72,48.24,42.004];
snr_db_RF  = [83.68,83.88,75.46,64.06,51.675,39.54,27.00,15.04,7.34] ;
ACPR_db_ADL= [56.07,56.75,56.58,56.63,56.793,57.78,54.87,46.09,41.26];
snr_db_ADL  = [94.79,94.662,75.95,64.00,51.63,39.49,26.95,15.00,7.34] ;
Nbits      = [32,22,12,10,8,6,4,2,1];

figure;
hold on;
plot(Nbits, ACPR_db_RF, 'r-*', 'LineWidth', 2);  % Données PS_2500
plot(Nbits, ACPR_db_ADL, 'b-*', 'LineWidth', 2);        % Droite de régression
xlabel('Nbits CNA');
ylabel('ACPR (dB)');
title('ACPR Vs Nbits');
legend('RFLUPA05M06G', 'ADL5606');
grid on;
hold off;

figure;
hold on;
plot(Nbits, snr_db_RF, 'r-*', 'LineWidth', 2);  % Données PS_2500
plot(Nbits, snr_db_ADL, 'b-*', 'LineWidth', 2);        % Droite de régression
xlabel('Nbits CNA');
ylabel('SNR (dB)');
title('SNR Vs Nbits');
legend('RFLUPA05M06G', 'ADL5606');
grid on;
hold off;