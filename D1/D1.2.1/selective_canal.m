function [z_1,H_out] = selective_canal(s,Nc,N,ch,min_N0)
% Nc : nombre des canaux 
% S  : symbole d'entrer
% N  : nombre de sequence 
% ch : type de canal ,
% 0-> AWGN, 
% 1-> canala selective en frequence 1
% 2-> canala selective en frequence 2
% 3-> canala selective en frequence 3
% min_N0 : valeur min de N0 en scalaire


tau = [0,0.5,1,1.5,2];
A_1 = [1,0.1,0.1,0.1,0.1];
A_2 = [1,0.8,0.6,0.4,0.2];
A_3 = [1,0.8,0.8,0.8,0.8];
Ts = 0.05e-6;
L = 15;
m = -L:1:L;

h1 = filtre_canal(m,A_1,tau,Ts,L);
h1_norm = h1/norm(h1);

h2 = filtre_canal(m,A_2,tau,Ts,L);
h2_norm = h2/norm(h2);

h3 = filtre_canal(m,A_3,tau,Ts,L);
h3_norm = h3/norm(h3);


H0 = 1; % canal gaussienne
H1 = toeplitz_perso(h1_norm,L); % canal selective 1 
H2 = toeplitz_perso(h2_norm,L); % canal selective 2 
H3 = toeplitz_perso(h3_norm,L); % canal selective 3
z_1 = zeros(Nc,length(s));

if (ch == 0)
    s = s.';
    k=1 ; 
    for N0 = linspace(min_N0, 1, Nc)
    w = 1/sqrt(2)*(randn(1,length(s))+1i*randn(1,length(s)))*sqrt(N0); %bruit gaussien
    z_1(k,:) = w + s*H0 ; 
    k = k+1 ;
    H_out = diag(ones(1,31));
    end
end
if(ch == 1)
    s =s.';
    s_sequences = reshape(s, 31, [])';
    z = [];
    k=1;
    for N0 = linspace(min_N0, 1, Nc)
        for i =1:size(s_sequences,1)
            w = 1/sqrt(2)*(randn(1,31)+1i*randn(1,31))*sqrt(N0); %bruit gaussien
            temp = H1 * s_sequences(i,:).' + w.';
            z = [z,reshape(temp,1,31)];
        end
        z_1(k,:)= z ;
        z = [];
        k=k+1;
        H_out = H1;
    end
end

if(ch == 2)
    s = s.';
   s_sequences = reshape(s, 31, [])';
    z = [];
    k=1;
    for N0 = linspace(min_N0, 1, Nc)
        for i =1:size(s_sequences,1)
            w = 1/sqrt(2)*(randn(1,31)+1i*randn(1,31))*sqrt(N0); %bruit gaussien
            temp = H2 * s_sequences(i,:).' + w.';
            z = [z,reshape(temp,1,31)];
        end
        z_1(k,:)= z ;
        z = [];
        k=k+1;
        H_out = H2;
    end
end
if (ch == 3)
    s=s.';
    s_sequences = reshape(s, 31, [])';
    z = [];
    k=1;
    for N0 = linspace(min_N0, 1, Nc)
        for i =1:size(s_sequences,1)
            w = 1/sqrt(2)*(randn(1,31)+1i*randn(1,31))*sqrt(N0); %bruit gaussien
            temp = H3 * s_sequences(i,:).' + w.';
            z = [z,reshape(temp,1,31)];
        end
        z_1(k,:)= z ;
        z = [];
        k=k+1;
        H_out = H3;
    end
end
end