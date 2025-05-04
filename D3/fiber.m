function S_out = fiber(S_in,distance,Ts,sur_echantionnage)
    N = length(S_in);
    sur_sig = [];
    for i = 1:1:N
        for j = 1:1:sur_echantionnage
            sur_sig = [sur_sig,S_in(i)];
        end
    end
    N = length(sur_sig);
    beta2 = -23.91e-24 ;
    beta3 = 0.1e-36 ;
    Fs = sur_echantionnage/Ts;
    signal  = sur_sig;
    DFT     = fft(signal);
    f = (-N/2:N/2-1)*(Fs/N);
    omega = 2*pi*f;
    H = exp(-1i * (beta2/2 * omega.^2 + beta3/6 * omega.^3) * distance);
    DFT = fftshift(DFT);
    S_out = real(ifft(ifftshift(DFT .* H)));
end