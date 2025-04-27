function symbole_out = ZFE_perso(z,H,mod,M)
    z_ZFE = pinv(H)*z;
    symbole_out = threshold_detector(z_ZFE,mod,M);
end