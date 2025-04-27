   clear; close all; 
% temps d'excution est 1 minute et 36 seconds

%%

% generation des signaux aleatoir + modulation(BPSK) des ces signaux dans fonction modulaion

    N = 100; % nombre de sequneces envoyer 
    Nc = 100; % nombre des canaux des les quelles les signaux sont passer par
    min_N0 = 0.1; % le point de commencement de N0
    mod = 'QAM'; % type de modulation
    M   = 16; % taille de constellation
    m   = log2(M); % nombre de bits dans 1 symbole
    canal = 2;
    Equalizer = 1;
    
    [S_0,S_1,S_2,M_0,M_1,M_2]=modulation(N,mod,M);
    
    % la fonction qui simule le canale 
    [Z_0,H0] = selective_canal(S_0,Nc,N,canal,min_N0);
    [Z_1,H1] = selective_canal(S_1,Nc,N,canal,min_N0);
    [Z_2,H2] = selective_canal(S_2,Nc,N,canal,min_N0);
    
    % la fonction qui fais la demodulation (il est lié au canal donc il doivent avoir le meme Nc)
    bits_0 = demodulation(Z_0,Nc,mod,M,H0,Equalizer);
    bits_1 = demodulation(Z_1,Nc,mod,M,H1,Equalizer);
    bits_2 = demodulation(Z_2,Nc,mod,M,H2,Equalizer);

    
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
        BCH_1 = reshape(entre, 31, fix(N/m)*m)';% construction des sequences
        for j = 1:size(BCH_1,1)
            decode = ML(BCH_1(j,:),1); % decode de code recus d'apres le canal
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
        BCH_2 = reshape(entre, 31, fix(N/m)*m)';% construction des sequences
        for j = 1:size(BCH_2,1)
            decode = ML(BCH_2(j,:),2); % decode de code recus d'apres le canal
            temp = BER(decode,M_2(j,:)); % calacule de BER pour chaque canal
            sum_2 = sum_2 + temp ;
        end
        BER_2 = [BER_2,sum_2/N];
        sum_2 = 0;
    end
    
    % liste de SNR pour chaque canal
    SNR_0 = [];
    SNR_1 = [];
    SNR_2 = [];

    % remplissage de liste de SNR
    Eb = 1 ; % on a modulation BPSK 
    for N0 = linspace(min_N0, 1, Nc)
    SNR_0  = [SNR_0,Eb/N0] ;
    end
    
    %remplissage de SNR pour BCH 2 en prendre ne compte ratio
    for N0 = linspace(min_N0, 31/26, Nc)
    SNR_1  = [SNR_1,(Eb/N0)*(31/26)] ;
    end
    %remplissage de SNR pour BCH 1 en prendre ne compte ratio
    for N0 = linspace(min_N0, 31/21, Nc)
    SNR_2  = [SNR_2,(Eb/N0)*(31/21)] ;
    end

    % conversion en dB du SNR
    SNR_dB_0 = 10 * log10(SNR_0(1:end));
    SNR_dB_1 = 10 * log10(SNR_1(1:end));
    SNR_dB_2 = 10 * log10(SNR_2(1:end));

    % listes de gain empirique calculer
    GAIN_1 = []; 
    GAIN_2 = [];


    % listes de BER pour ce gain 
    BER_GAIN_1 = [];
    BER_GAIN_2 = [];

    % calcul de gain empirique pour BCH 1 
    for i = 1:Nc
        for j = 1:Nc
            if (BER_1(i) <= BER_0(j)+0.005 && BER_1(i) >= BER_0(j)-0.005 && BER_0(j) < 20)
                GAIN_1 = [GAIN_1,SNR_dB_0(i)-SNR_dB_1(j)];
                BER_GAIN_1 = [BER_GAIN_1,BER_0(j)];
            end
        end
    end
    
    % calcul de gain empirique pour BCH 1 
    for i = 1:Nc
        for j = 1:Nc
            if (BER_2(i) <= BER_0(j)+0.005 && BER_2(i) >= BER_0(j)-0.005 && BER_0(j) < 20 )
                GAIN_2 = [GAIN_2,SNR_dB_0(i)-SNR_dB_2(j)];
                BER_GAIN_2 = [BER_GAIN_2,BER_0(j)];
            end
        end
    end
        
    
    % le gain empirique theorique
    GAIN_1_Theo = 10*log10((26/31)*2);
    GAIN_2_Theo = 10*log10((21/31)*3);

    % Ajout du tracé des courbes BER en fonction du SNR 
    figure; 
    semilogy(SNR_dB_0, BER_0, 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
    hold on;
    semilogy(SNR_dB_1, BER_1, 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
    semilogy(SNR_dB_2, BER_2, 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2
    xlabel('SNR (dB)');
    ylabel('BER %');
    title('Comparaison des performances BER en fonction du SNR');
    legend('Non codé', 'BCH_1', 'BCH_2');
    grid on;
    hold off;
    
    % Tracage des gains empiriques en fonction du BER_gain dans la deuxieme sous-figure
    figure;
    plot(BER_GAIN_1, smooth(GAIN_1(end:-1:1)), 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Gain empirique pour BCH_1
    hold on;
    plot(BER_GAIN_2, smooth(GAIN_2(end:-1:1)), 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Gain empirique pour BCH_2
    yline(GAIN_1_Theo, 'r--', 'LineWidth', 2); % Ligne horizontale pour GAIN_1_Theo
    yline(GAIN_2_Theo, 'g--', 'LineWidth', 2); % Ligne horizontale pour GAIN_2_Theo
    xlabel('BER %');
    ylabel('Gain Empirique (dB)');
    title('Gain Empirique en fonction du BER');
    legend('BCH_1 (Empirique)', 'BCH_2 (Empirique)','BCH_1 (theorique)', 'BCH_2 (theorique)');
    grid on;
    hold off;
    
    
    % Ajout du tracé des courbes BER en fonction du SNR lisser
    figure;
    semilogy(SNR_dB_0, smooth(BER_0), 'bo-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le non codé
    hold on;
    semilogy(SNR_dB_1, smooth(BER_1), 'r*-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_1
    semilogy(SNR_dB_2,  smooth(BER_2), 'gs-', 'LineWidth', 2, 'MarkerSize', 8); % Courbe pour le code BCH_2
    
    % Ajout des légendes et titres
    xlabel('SNR (dB)');
    ylabel('BER %');
    title('Comparaison des performances BER en fonction du SNR');
    legend('Non codé', 'BCH_1', 'BCH_2');
    grid on;
    hold off;

