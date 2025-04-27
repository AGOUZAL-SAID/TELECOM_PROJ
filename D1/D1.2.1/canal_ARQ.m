function z_1 = canal_ARQ(s,N0)
% S  : symbole d'entrer
% min_N0 : valeur de N0 en scalaire

    s = s.';
    w = 1/sqrt(2)*(randn(1,length(s))+1i*randn(1,length(s)))*sqrt(N0); %bruit gaussien
    z_1 = w + s ; 

end