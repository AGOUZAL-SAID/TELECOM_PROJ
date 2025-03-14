function [BER] = ZFE(bits_emis,z,H,mod,M)
    z_ZFE = pinv(H)*z;
    s_recu = threshold_detector(z_ZFE,mod,M);
    bits_recu = symbols2bits(s_recu,mod,M);
    BER = sum(bits_emis ~= bits_recu) / length(bits_emis) ;
end