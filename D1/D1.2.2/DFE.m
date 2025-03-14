function [BER] = DFE(bits_emis, z, H, mod, M)
    [Q, R] = qr(H);  % Décomposition QR
    z_eq = ctranspose(Q) * z;  % Signal reçu après égalisation

    N = length(R);
    s_est = zeros(1, N);  % Préallocation des décisions
    
    % Boucle de détection avec rétroaction
    for n = N:-1:1
        temp = z_eq(n);
        for m = 1:N-n
            temp = temp - R(n, n+m) * s_est(n+m);
        end
        s_est(n) = threshold_detector(temp / R(n, n), mod, M);
    end
    
    % Décodage des bits
    bits_recu = symbols2bits(s_est, mod, M);
    
    % Calcul du BER
    BER = sum(bits_emis ~= bits_recu) / length(bits_emis);
end
