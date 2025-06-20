clear all; close
rejection01 = d4_perfs_students('400k','zf');
K0=[1:1:200];
rejection02 = d4_perfs_students('400k','dfe');

rejection11 = d4_perfs_students('4M','zf');
K1=[1:1:20];
rejection12 = d4_perfs_students('4M','dfe');

figure;
stairs(K0, rejection01, 'g*', 'LineWidth', 4);
hold on;
stairs(K0, rejection02, 'r*', 'LineWidth', 4);
xlabel('Nombre d utilisateurs (K)');
ylabel('Taux de rejet');
title('Taux de rejet en fonction du nombre d utilisateurs (400k)');
legend('ZFE','DFE');
grid on;
hold off;

figure;
stairs(K1, rejection11, 'g*', 'LineWidth', 8);
hold on;
stairs(K1, rejection12, 'r*', 'LineWidth', 8);
xlabel('Nombre d utilisateurs (K)');
ylabel('Taux de rejet');
title('Taux de rejet en fonction du nombre d utilisateurs (4M)');
legend('ZFE','DFE');
grid on;
hold off;