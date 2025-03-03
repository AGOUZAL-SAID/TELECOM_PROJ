function z = canal(s)
z = zeros(100,length(s));
k=1 ; 
    for N0 = 0.1:0.01:1
    w = 1/sqrt(2)*(randn(1,length(s))+1i*randn(1,length(s)))*sqrt(N0); %bruit gaussien
    z(k) = w+s ; 
    k = k+1 ;
    end
end
