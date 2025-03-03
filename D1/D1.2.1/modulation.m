function [S_0,S_1,S_2,M_0,BCH_1,BCH_2] = modulation(N)
% N nombre des séquences 

% sequence des bits non codé
M_0   = randi([1 0],1,N*31); 
M_1   = randi([1 0],N,26);   
M_2   = randi([1 0],N,21);   

BCH_1 = []; % sequence des bits code en BCH1
BCH_2 = []; % sequence des bits code en BCH2

S_0   = zeros(1,31*N,"uint8"); % matrice de symbols recus mot non codeé
S_1   = zeros(1,26*N,"uint8"); % matrice de symbols recus mot code en BCH1
S_2   = zeros(1,21*N,"uint8"); % matrice de symbols recus mot code en BCH2

% calcule de BCH_1 
for i = 1:N
    temp = BCH(M_1(i),1);
    BCH_1 = [BCH_1,temp];
end

% calcule de BCH_2 
for i = 1:N
    temp = BCH(M_2(i),2);
    BCH_2 = [BCH_2,temp];
end

% calcule de symboles non codé
S_0 = bits2symbols(M_0,"PSK",2);

% calcule de symboles BCH une erreur
S_1 = bits2symbols(BCH_1,"PSK",2);

% calcule de symboles BCH deux erreurs
S_2 = bits2symbols(BCH_2,"PSK",2);
