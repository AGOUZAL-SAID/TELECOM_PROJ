function bits = demodulation(z,Nc,mod,M)
% Nc : nombre des canaux
% z  : mots recus
% mod : type de modulation 
% M  : taille constellation
m = log2(M);
bits = zeros(Nc,size(z,2)*m);
for j = 1:Nc 
    s = threshold_detector(z(j, :),mod,M);  % detection de symbole le plus proche
    % Conversion en bits
    bits(j, :) = symbols2bits(s, mod, M);

end
end