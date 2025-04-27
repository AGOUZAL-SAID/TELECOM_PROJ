function [synd_1,synd_2_1,synd_2_2] = initialisation_synd()
    synd_1   = zeros(31,5)  ;
    synd_2_1 = zeros(31,10) ;
    synd_2_2 = cell(31,31)  ;
    % remplissage de liste de syndromme BCH 1
    for i = 1:31
        L = zeros(1,31);
        L(i) =1 ;
        synd_1 (i,:) = moduloG(L,1);
    end
    % remplissage de liste de syndromme BCH 2 pour l'ensemble 1 erreur
    for i = 1:31
        L = zeros(1,31);
        L(i) =1 ;
        synd_2_1 (i,:) = moduloG(L,2);
    end
    % remplissage de liste de syndromme BCH 2 pour l'ensemble de 2 erreurs
    for i = 1:31
        for j= i+1 : 31
            L=zeros(1,31);
            L([i, j]) = 1;
            synd_2_2{i,j} = moduloG(L,2);

        end
    end


end