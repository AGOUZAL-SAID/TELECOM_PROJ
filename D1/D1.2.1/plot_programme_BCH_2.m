
% temps d'excution est  27 seconds x)

%%

% generation et stockage des syndromes
[synd_1,synd_2_1,synd_2_2] = initialisation_synd() ;

% generation des signaux aleatoir + modulation(BPSK) des ces signaux dans fonction modulaion
N = 100; % nombre de sequneces envoyer 
Nc = 100; % nombre des canaux des les quelles les signaux sont passer par 
[S_0,S_1,S_2,M_0,M_1,M_2]=modulation(N);

% la fonction qui simule le canale 
Z_0 = canal(S_0,Nc);
Z_1 = canal(S_1,Nc);
Z_2 = canal(S_2,Nc);

% la fonction qui fais la demodulation (il est lié au canal donc il doivent avoir le meme Nc)
bits_0 = demodulation(Z_0,Nc);
bits_1 = demodulation(Z_1,Nc);
bits_2 = demodulation(Z_2,Nc);

% construction des sequences 
%BCH_1 = reshape(bits_1, 31, N)';
%BCH_2 = reshape(bits_2, 31, N)';

% les liste de teaux d'erreurs binaire 
BER_0 = [];
BER_1 = [];
BER_2 = [];

% remplissage de BER_0 
for i = 1:size(bits_0,1)
    temp = BER(bits_0(i,:),M_0); % calacule de BER pour chaque canal
    BER_0 = [BER_0,temp];
end
sum_1 = 0;
% remplissage de BER_1 
for i = 1:size(bits_1,1)
    entre = bits_1(i,:);
    BCH_1 = reshape(entre, 31, N)';
    for j = 1:N
        decode = ML2 (BCH_1(j,:),1,synd_1,synd_2_1,synd_2_2); % decode de code recus d'apres le canal
        temp = BER(decode,M_1(j,:)); % calacule de BER pour chaque canal
        sum_1 = sum_1 + temp ;
    end
    BER_1 = [BER_1,sum_1/N];
    sum_1 = 0;
end

sum_2 =0 ;
% remplissage de BER_2 
for i = 1:size(bits_2,1)
    entre = bits_2(i,:)
    BCH_2 = reshape(entre, 31, N)';
    for j = 1:N
        decode = ML2 (BCH_2(j,:),2,synd_1,synd_2_1,synd_2_2); % decode de code recus d'apres le canal
        temp = BER(decode,M_2(j,:)); % calacule de BER pour chaque canal
        sum_2 = sum_2 + temp ;
    end
    BER_2 = [BER_2,sum_2/N];
    sum_2 = 0;
end

% liste de SNR pour chaque canal
SNR =  [];

% remplissage de liste de SNR
Eb = 1 ; % on a modulation BPSK 
for N0 = linspace(0.1, 1, Nc)
SNR  = [SNR,Eb/N0] ;
end

% conversion en dB du SNR
SNR_dB = 10 * log10(SNR(1:end));


% Ajout du tracé des courbes BER en fonction du SNR
figure;
plot(SNR_dB, BER_0, 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
hold on;
plot(SNR_dB, BER_1, 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
plot(SNR_dB, BER_2, 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2

% Ajout des légendes et titres
xlabel('SNR (dB)');
ylabel('BER');
title('Comparaison des performances BER en fonction du SNR');
legend('Non codé', 'BCH_1', 'BCH_2');
grid on;
hold off;
