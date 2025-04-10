Nbits = linspace(1,18,18);
OSR = 1.5;
ENOB = Nbits + 10*log10(OSR)/6.02;
fs = 2.99e7;
P = 1e-13*fs*2.^ENOB;
figure;
hold on;
plot(Nbits, P, 'r-', 'MarkerSize', 8, 'LineWidth', 2);  
xlabel('Nbits ');
ylabel('Puissance (w)');
title('consomation éléctrique');
grid on;
hold off;

