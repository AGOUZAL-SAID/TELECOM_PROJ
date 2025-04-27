function bits = demodulation(z,Nc,mod,M,H,Equalizer)
% Nc : nombre des canaux
% z  : mots recus
% mod : type de modulation 
% M  : taille constellation
% ch : type de Egalisateur ,
% 0-> threshold, 
% 1-> ZFE equalize
% 2-> DFE equalize
% H  : Matrice toeplitz du canal

m = log2(M);
bits = zeros(Nc,size(z,2)*m);
switch Equalizer
    case 0
        for j = 1:Nc 
            s = threshold_detector(z(j, :),mod,M);  % detection de symbole le plus proche
            % Conversion en bits
            bits(j, :) = symbols2bits(s, mod, M);
        end
    case 1 
        for j = 1:Nc
            z_sequences = reshape(z(j, :), 31, [])';
            temp =  [];
            for i =1:size(z_sequences,1)
            sortie = ZFE_perso(z_sequences(i,:).',H,mod,M);
            temp = [temp,reshape(sortie,1,31)];
            end
            bits(j, :) = symbols2bits(temp, mod, M);
        end
    case 2 
        for j = 1:Nc
            z_sequences = reshape(z(j, :), 31, [])';
            temp =  [];
            for i =1:size(z_sequences,1)
            sortie = DFE_pers(z_sequences(i,:).',H,mod,M);
            temp = [temp,reshape(sortie,1,31)];
            end
            bits(j, :) = symbols2bits(temp, mod, M);
        end        
end
    
end