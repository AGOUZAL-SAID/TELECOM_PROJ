function z = canal(s,Nc)
% s le symbole transmit dans un canal
% Nc nombre des canaux 
z = zeros(Nc,length(s));
s = s.';
disp(length(s))
k=1 ; 
    for N0 = linspace(0.1, 1, Nc)
    w = 1/sqrt(2)*(randn(1,length(s))+1i*randn(1,length(s)))*sqrt(N0); %bruit gaussien
    z(k,:) = w+s ; 
    k = k+1 ;
    end
end
