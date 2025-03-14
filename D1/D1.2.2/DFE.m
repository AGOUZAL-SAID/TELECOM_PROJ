function [BER] = DFE(bits_emis, z, H, mod, M)
    [Q, R] = qr(H); 
    
    z_eq = ctranspose(Q) * z; 
    s_recu = zeros(size(z_eq)); 
    
    % Boucle de détection avec rétroaction
    for j = 1:length(z_eq)
        % Détection du symbole actuel
        s_recu(j) = threshold_detector(z_eq(j), mod, M);
        
        % Correction des symboles suivants avec rétroaction
        if j < length(z_eq)
            z_eq(j+1:end) = z_eq(j+1:end) - R(j+1:length(z_eq), j) * s_recu(j);
        end
    end

    % Décodage des bits
    bits_recu = symbols2bits(s_recu, mod, M);
    
    % Calcul du BER
    BER = sum(bits_emis ~= bits_recu) / length(bits_emis);
end
