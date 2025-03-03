tau = [0,0.5,1,1.5,2];
A_1 = [1,0.1,0.1,0.1,0.1];
A_2 = [1,0.8,0.6,0.4,0.2];
A_3 = [1,0.8,0.8,0.8,0.8];
Ts = 0.05e-6;
L = 6;
m = -L:1:L;

h1 = filtre_canal(m,A_1,tau,Ts,L);
h1_norm = h1/norm(h1);

h2 = filtre_canal(m,A_2,tau,Ts,L);
h2_norm = h2/norm(h2);

h3 = filtre_canal(m,A_3,tau,Ts,L);
h3_norm = h3/norm(h3);

%Example of an ugly plot

plot(m,h1_norm);

%c1 = zeros(4);

H1 = toeplitz(h1_norm); %à corriger
H2 = toeplitz(h2_norm);
H3 = toeplitz(h3_norm);

BPSK_symb = symbols_lut("PSK",2);
QAM8_symb = symbols_lut("QAM",8);
QAM16_symb = symbols_lut("QAM",16);

%BPSK


%ZFE
Eb = 1;
bits_emis = randi([0,1],1,13);
disp(bits_emis);
s_emis = bits2symbols(bits_emis,"PSK",2);
for N0 = 0.1:0.1:1
    w = 1/sqrt(2) * (randn(13,1) + 1i * randn(13,1)) * sqrt(N0);% *sqrt(N0);         %bruit gaussien circulaire
    z = H1*s_emis + w;
    
    z1 = pinv(H1)*z ;
    s_recu = threshold_detector(z1,"PSK",2);
    bits_recu = symbols2bits(s_recu,"PSK",2);
    BER = sum(bits_emis ~= bits_recu) / length(bits_emis) *100;
    disp(BER);
    disp(bits_recu);
    SNR = 10*log10(Eb/N0);
end

% DFE
