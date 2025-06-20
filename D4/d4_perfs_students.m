%% [rej] = d4_perfs(mode,rx)


%% Rejection rate for deliverable D4
%%
%% mode = selected data rate for all the users ('40k','400k','4M','40M')
%% rx = selected receiver for all the users ('zf','dfe')
  
%% rej = rejection rate versus K (number of users) 

%% Location : Telecom Paris
%% Author : Philippe Ciblat <ciblat@telecom-paris.fr>
%% Date   : 09/06/2023



function [rej] = d4_perfs_students(mode,rx)

Ts=1/(20e6);
MC=1000; %%number of Monte-Carlo simulations
Dmax = 1e3;

if(strcmp(mode,'40k')==1) 
R=40*10^(3); 
Kmax=2000;
K=[1:(floor(Kmax/10)+1):Kmax];
end;

if(strcmp(mode,'400k')==1) 
R=400*10^(3); 
Kmax=200; 

K=[1:1:Kmax];
end;

if(strcmp(mode,'4M')==1) 
R=4*10^(6); 
Kmax=20;
K=[1:1:Kmax];
end;

if(strcmp(mode,'40M')==1) 
R=40*10^(6);
Kmax=2; 
K=[1:1:Kmax];
end;


if(strcmp(rx,'zf')==1)
SNR_min_bpsk= [9.25,13.5,21] ; %minimum Es/N0 for each channel (3-length vector);
SNR_min_8qam= [15.5,20.5,28.5]     ;%minimum Es/N0 for each channel (3-length vector);
SNR_min_16qam= [19,24,32]; %minimum Es/N0 for each channel (3-length vector);
end;

if(strcmp(rx,'dfe')==1)
SNR_min_bpsk= [9,11,13.5] ;%minimum Es/N0 for each channel (3-length vector);
SNR_min_8qam= [15.5,17.5,20.5]  ;%minimum Es/N0 for each channel (3-length vector);
SNR_min_16qam= [19,22,24] ;%minimum Es/N0 for each channel (3-length vector);
end;
  


rej=zeros(1,length(K));

for kk=1:length(K)
aux=0;

for mm=1:MC
xx= Dmax*(2*rand(1,K(kk))-1); % uniformly-distributed x-axis in a square of semi-length 1 (K(kk) length vector);
yy= Dmax*(2*rand(1,K(kk))-1); % uniformly-distributed y-axis in a square of semi-length 1 (K(kk) length vector);
d2=xx.^2+yy.^2;%% square-distance from the origin 
inter = 1e-4; %% (c/4*pi*f0)^2
a2=min(1, inter./d2);% square magnitude attenuation in Friis equation (calculate ??) 
a2_dB=10*log10(a2);
SNR_rx_max= a2_dB + 121; %calculate 10log(Pmax*Ts)+174 : SNRmax at TX in dB
SNR_min=SNR_min_16qam; %%ZF or DFE/16QAM: channel 1, channel 2, channel 3
if(R*Ts*K(kk)<3)  SNR_min=SNR_min_8qam; end%%ZF or DFE/8QAM: channel 1, channel 2, channel 3  (
if(R*Ts*K(kk)<1) SNR_min=SNR_min_bpsk; end %%ZF or DFE/BPSK: channel 1, channel 2, channel 3
  
SNR_rx_min=SNR_min(randi(3,K(kk),1));

aux=aux+length((find(sign(SNR_rx_min-SNR_rx_max)+1)/2));

end


rej(kk)= aux/(K(kk)*MC);


end;


%% Channel display
%stairs(K,rej,'r*');
%xlabel('Nombre d utilisateurs (K)');
%ylabel('Taux de rejet');
%title('Taux de rejet en fonction du nombre d utilisateurs');
%grid
%hold on;
