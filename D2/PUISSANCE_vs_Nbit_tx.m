clear; close all;
P = [20.9,20.27,];
Nbits      = [2,3,4];

figure;
hold on;
plot(Nbits, P, 'r-*', 'LineWidth', 2);  % Données PS_2500
xlabel('Nbits CNA');
ylabel('P (dBm)');
title('Puissance Vs Nbits');
grid on;
hold off;