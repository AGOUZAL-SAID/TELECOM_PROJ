function S_out = fiber(S_in,distance,Ts)
    N = length(S_in);
    sur_sig =S_in ;
    N = length(sur_sig);
    beta2 = -23.91e-24 ;
    beta3 = 0.1e-36 ;
    alpha = -0.24*0.23*0.5; % Amplitude
    Fs = 1/Ts;
    signal  = [zeros(1,N),sur_sig,zeros(1,N)];
    M = length(signal);
    DFT     = fft(signal);
    f = (-M/2:M/2-1)*(Fs/M);
    omega = 2*pi*f;
    H = exp(alpha * distance / 2).*exp(-1i * (beta2/2 * omega.^2 + beta3/6 * omega.^3) * distance);
    DFT = fftshift(DFT);
    SORTIE = ifft(ifftshift(DFT .* H));
    S_out = SORTIE(N+1 : 2*N);
end