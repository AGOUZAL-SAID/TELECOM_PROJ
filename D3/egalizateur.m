function S_out = egalizateur(S_in, distance, Ts)
    % Propagation dans la fibre : atténuation + dispersion (ordre 2 et 3)

    N    = length(S_in);
    beta2 = -23.91e-24;     % s^2/km
    beta3 =  0.1e-36;       % s^3/km
    alpha = -0.24 * 0.23 * 0.5;  % atténuation linéaire (amplitude)

    Fs     = 1/Ts;
    % zéro-padding pour éviter le repliement spectral
    sig_pad = [zeros(1,N), S_in, zeros(1,N)];
    M       = length(sig_pad);

    % TF du signal
    S     = fft(sig_pad);
    f     = (-M/2:M/2-1)*(Fs/M);
    w     = 2*pi*f;

    % Fonction de transfert : perte + dispersion
    H = exp(-alpha*distance/2) .* exp(1i*((beta2/2)*w.^2 + (beta3/6)*w.^3)*distance);

    % Application du filtre et retour en temps
    Sf   = ifft(ifftshift(fftshift(S).*H));
    S_out = Sf(N+1:2*N);
end
