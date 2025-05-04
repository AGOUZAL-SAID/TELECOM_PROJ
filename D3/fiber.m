function S_out = fiber(S_in,Nb_symbols,distance,Ts)
    sur_sig = [];
    for i = 1:1:N
        for j = 1:1:10
            sur_sig = [sur_sig,S_in(i)]
        end
    end
    N = length(sur_sig)
    beta_2 = 0 ;
    beta_3 = 0 ;
    Fs = 10/Ts  ;
    f_0     = 193e12   ;
    W0      = 2*pi*f_0 ;
    window  = blackman(N);
    signal  = sur_sig(:).*window;
    DFT     = fft(signal);
    pas_Fs  = round(Fs/(N));
    for i=1:1:N
        w2 = (2*pi*Fs*i)^2;
        w3 = (2*pi*Fs*i)^3;
        disp = exp(-distance*(1i*(beta_2*w2/2+beta_3*w3/6)));
        sur_sig(i)=sur_sig(i)*disp;
    end
    S_out = ifft(sur_sig);
end