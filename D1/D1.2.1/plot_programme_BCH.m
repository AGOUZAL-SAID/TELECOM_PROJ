
% temps d'excution est 1 minute et 36 seconds

%%

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
        decode = ML (BCH_1(j,:),1); % decode de code recus d'apres le canal
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
        decode = ML (BCH_2(j,:),2); % decode de code recus d'apres le canal
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

% listes de gain empirique calculer
    GAIN_1 =[]; 
    GAIN_2 = [];


    % listes de BER pour ce gain 
    BER_GAIN_1 = [];
    BER_GAIN_2 = [];
    
    % calcul de gain empirique pour BCH 1 
    for i = 1:Nc
        for j = 1:Nc
            if (BER_1(i) <= BER_0(j)+1 && BER_1(i) >= BER_0(j)-1 && BER_0(j) < 40)
                GAIN_1 = [GAIN_1,SNR_dB(i)-SNR_dB(j)];
                BER_GAIN_1 = [BER_GAIN_1,BER_0(j)];
            end
        end
    end
    
    % calcul de gain empirique pour BCH 1 
    for i = 1:Nc
        for j = 1:Nc
            if (BER_2(i) <= BER_0(j)+1 && BER_2(i) >= BER_0(j)-1 && BER_0(j) < 40 )
                GAIN_2 = [GAIN_2,SNR_dB(i)-SNR_dB(j)];
                BER_GAIN_2 = [BER_GAIN_2,BER_0(j)];
            end
        end
    end
        
    
    % le gain empirique theorique
    GAIN_1_Theo = (26/31)*3;
    GAIN_2_Theo = (21/31)*7;

    
    
figure;
subplot(2,1,1); 
plot(SNR_dB, BER_0, 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
hold on;
plot(SNR_dB, BER_1, 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
plot(SNR_dB, BER_2, 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2
xlabel('SNR (dB)');
ylabel('BER');
title('Comparaison des performances BER en fonction du SNR');
legend('Non codé', 'BCH_1', 'BCH_2');
grid on;
hold off;

% Trac des gains empiriques en fonction du BER_gain dans la deuxieme sous-figure
subplot(2,1,2);
plot(BER_GAIN_1, GAIN_1, 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Gain empirique pour BCH_1
hold on;
plot(BER_GAIN_2, GAIN_2, 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Gain empirique pour BCH_2
yline(GAIN_1_Theo, 'r--', 'LineWidth', 2); % Ligne horizontale pour GAIN_1_Theo
yline(GAIN_2_Theo, 'g--', 'LineWidth', 2); % Ligne horizontale pour GAIN_2_Theo
xlabel('BER');
ylabel('Gain Empirique (dB)');
title('Gain Empirique en fonction du BER');
legend('BCH_1 (Empirique)', 'BCH_2 (Empirique)','BCH_1 (theorique)', 'BCH_2 (theorique)');
grid on;
hold off;


% Ajout du tracé des courbes BER en fonction du SNR lisser
figure;
plot(SNR_dB, smooth(BER_0), 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
hold on;
plot(SNR_dB, smooth(BER_1), 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
plot(SNR_dB,  smooth(BER_2), 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2

% Ajout des légendes et titres
xlabel('SNR (dB)');
ylabel('BER');
title('Comparaison des performances BER en fonction du SNR');
legend('Non codé', 'BCH_1', 'BCH_2');
grid on;
hold off;
