clc; clear; close all;

% Données
PS_600  = [4.45, -10.38, -12.45, -19.97, -17.97, -21.91, -37.54, -26.88, -41.09, -37.98, -73.34] - 19 ;
PS_2500 = [-55.19, -60.70, -65.38, -75.52, -72.51, -72, -66.21, -73.95, -73.27, -74.98, -75.93] - 19  ;
Distance = 10*log10(linspace(1.5, 51.5, 11));

%% Régression pour PS_2500 (méthode classique)
x = Distance;
y = PS_2500;

% Calcul des moyennes
x_mean = mean(x);
y_mean = mean(y);

% Calcul de beta1 et beta0
beta1 = sum((x - x_mean) .* (y - y_mean)) / sum((x - x_mean).^2);
beta0 = y_mean - beta1 * x_mean;

disp('Pour PS_2500 :');
disp(['  Pente (beta1) : ', num2str(beta1)]);
disp(['  Ordonnée à l’origine (beta0) : ', num2str(beta0)]);

% Génération des valeurs ajustées
x_reg = linspace(min(x), max(x), 100);
PS_2500_reg = beta0 + beta1 * x_reg;

% Affichage de la régression pour PS_2500
figure;
hold on;
plot(x, y, 'ro', 'MarkerSize', 8, 'LineWidth', 2);  % Données PS_2500
plot(x_reg, PS_2500_reg, 'b-', 'LineWidth', 2);        % Droite de régression
xlabel('Distance 10log10(m)');
ylabel('Puissance (dBm)');
title('Régression linéaire pour PS\_2500');
legend('Données', 'Régression');
grid on;
hold off;

%% Régression pour PS_600 (méthode classique)
x = Distance;
y = PS_600;

% Calcul des moyennes
x_mean = mean(x);
y_mean = mean(y);

% Calcul de beta1 et beta0
beta1 = sum((x - x_mean) .* (y - y_mean)) / sum((x - x_mean).^2);
beta0 = y_mean - beta1 * x_mean;

disp(' ');
disp('Pour PS_600 :');
disp(['  Pente (beta1) : ', num2str(beta1)]);
disp(['  Ordonnée à l’origine (beta0) : ', num2str(beta0)]);

% Génération des valeurs ajustées
PS_600_reg = beta0 + beta1 * x_reg;

% Affichage de la régression pour PS_600
figure;
hold on;
plot(x, y, 'ro', 'MarkerSize', 8, 'LineWidth', 2);  % Données PS_600
plot(x_reg, PS_600_reg, 'b-', 'LineWidth', 2);        % Droite de régression
xlabel('Distance 10log10(m)');
ylabel('Puissance (dBm)');
title('Régression linéaire pour PS\_600');
legend('Données', 'Régression');
grid on;
hold off;
