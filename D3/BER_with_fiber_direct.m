clear; close all;

%%  Paramètres de la simulation 
Rb           = 1e9;                   % débit binaire (bps)
N_bits       = 1e2;                   % nombre de bits à simuler
alpha        = -0.24;                 % atténuation fibre (dB/km)
laser        = make_laser_simple('v',193e12); % laser DML @1550 nm
I_th         = laser.I_th;            % courant de seuil du laser
IDC_values   = linspace(0,10*I_th,3); % courants de bias à tester
over_samp    = 4505;                  % facteur d’oversampling
distance     = [0,20];                % distances considérées (km)

Ts           = 1/Rb;                  % durée symbole (s)
bits         = randi([0,1],1,N_bits); % trame binaire aléatoire

% Préallocation des matrices de stockage
matrice_optique_0  = zeros(length(IDC_values), N_bits*over_samp);
matrice_optique_20 = zeros(length(IDC_values), N_bits*over_samp);
matrice_elec_0     = zeros(length(IDC_values), N_bits*over_samp);
matrice_elec_20    = zeros(length(IDC_values), N_bits*over_samp);

% Création du photodétecteur (bande passante = Rb)
params_detector = make_photodetector('B_e', Rb);

%% Boucles de simulation 
for d_idx = 1:length(distance)
    D = distance(d_idx);
    
    for I_idx = 1:length(IDC_values)
        IDC = IDC_values(I_idx);
        
        % Signal de commande du laser DML (0->IDC, 1->IDC+3·I_th)
        X = bits * (3*I_th) + IDC;  
        
        % Modulation directe (DML)
        [S_opt, Ts_out, ~] = TX_optical_dml(X, Ts, laser);
        
        % Propagation en fibre
        S_fib = fiber(S_opt, D, Ts_out);
        
        % Stockage du signal optique (module)
        if d_idx == 1
            matrice_optique_0(I_idx,:) = abs(S_fib);
        else
            matrice_optique_20(I_idx,:)= abs(S_fib);
        end
        
        % Détection opto-électronique
        [S_elec, ~, ~, ~] = RX_photodetector(S_fib, Ts_out, 0, params_detector);
        
        % Stockage du signal électrique de sortie
        if d_idx == 1
            matrice_elec_0(I_idx,:) = S_elec;
        else
            matrice_elec_20(I_idx,:) = S_elec;
        end
    end
end

%%  Préparation de l’axe temporel 
Ns = N_bits * over_samp;             % nombre total d’échantillons
t  = (0:Ns-1) * Ts_out * 1e9;        % temps en nanosecondes

%% Affichage par courant de bias 
for k = 1:length(IDC_values)
    IDC = IDC_values(k);
    

    figure('Name', sprintf('I_{DC}=%.2f I_{th}', IDC/I_th), 'NumberTitle','off', 'Position',[200 200 800 400]);
    
    
    subplot(2,1,1);
    plot(t, matrice_optique_0(k,:),  'b-','LineWidth',1.5); hold on;
    plot(t, matrice_optique_20(k,:),'r-','LineWidth',1.5); hold off;
    xlabel('Temps (ns)');
    ylabel('|S_{opt}| (√W)');
    title(sprintf('Signal optique — I_{DC}=%.2f I_{th}', IDC/I_th));
    legend('0 km','20 km','Location','best');
    grid on;
    
    
    subplot(2,1,2);
    plot(t, matrice_elec_0(k,:),  'b-','LineWidth',1.5); hold on;
    plot(t, matrice_elec_20(k,:),'r-','LineWidth',1.5); hold off;
    xlabel('Temps (ns)');
    ylabel('I_{det} (A)');
    title(sprintf('Signal électrique — I_{DC}=%.2f I_{th}', IDC/I_th));
    legend('0 km','20 km','Location','best');
    grid on;
end
