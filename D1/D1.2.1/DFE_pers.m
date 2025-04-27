function symbole_out = DFE_pers(z,H,mod,M)
    [Q, R] = qr(H);  % Décomposition QR
    z_eq = ctranspose(Q) * z;  % Signal reçu après égalisation

    N = length(R);
    symbole_out = zeros(1, N);  % Préallocation des décisions
    
    % Boucle de détection avec rétroaction
    for n = N:-1:1
        temp = z_eq(n);
        for m = 1:N-n
            temp = temp - R(n, n+m) * symbole_out(n+m);
        end
        symbole_out(n) = threshold_detector(temp / R(n, n), mod, M);
    end
end