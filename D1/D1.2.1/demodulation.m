function bits = demodulation(z,Nc)
% Nc nombre des canaux
% z mots recus
bits = zeros(Nc,length(z));
for i = 1:Nc 
    s = z(i, :);  % On récupère la ième ligne et on la transpose

    % Normalisation correcte pour éviter les erreurs dans symbols2bits
    s = cos(mod(angle(s), 2*pi)) + i*sin(mod(angle(s), 2*pi));

    % Conversion en bits
    bits(i, :) = symbols2bits(s, 'PSK', 2);

end
end