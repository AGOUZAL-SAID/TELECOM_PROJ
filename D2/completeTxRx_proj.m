clear; close all
% completeTxRx_proj - Script that performs the simulation of the complete communication chain
%
%   This file has no equivalent for TELECOM201/ICS905
%
%   The purpose of this script is to demonstrate a complete wireless
%   communication chain.
%   As provided, the chain is not optimized ; ONE OF THE TARGET OF THE
%   PROJECT IS TO OPTIMIZE THE PARAMETERS OF THE SYSTEM SUBBLOCKS IN ORDER
%   TO MEET THE REQUIREMENTS.
%   Please pay attention to the fact that FIR filters in this script cause 
%   transient phenomena that have not been compensated. 
%   IT IS YOUR DUTY TO FIND THE EXPRESSION OF THE TOTAL DELAY IN "THE
%   ANALOG TO DIGITAL CONVERSION" SECTION TO MATCH THE TRANSMIT AND RECEIVE
%   DATA. (no hardcoding please...)
%   
%   Hopefully, the script has been written to be self-explanatory. 
%
%   In this project, we use the Quadriga Channel Model ("QuaDRiGa") for
%   generating realistic radio channel impulse responses.
%   It is an open source project whose license can be found in the
%   directories of the project. In order to reduce the footprint in terms
%   of disk space, we do not distribute the documentation (PDF) of the
%   QuaDRiGa toolbox included in the original archive distributed on the
%   official site. Please consult the download page and download the
%   archive to retrieve the documentation.
%   https://quadriga-channel-model.de/
%
% Other m-files required:   ./subblocks/*.m
% Subfunctions:             ./subblocks/*.m
% MAT-files required: none
%
% Author: Germain PHAM, Chadi JABBOUR
% C2S, COMELEC, Telecom Paris, Palaiseau, France
% email address: dpham@telecom-paris.fr
% Website: https://c2s.telecom-paristech.fr/TODO
% Feb. 2020, Apr. 2020, Mar. 2022, Dec. 2023
%------------- BEGIN CODE --------------

addpath(genpath('./subblocks/'))
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   Tranmitter                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K   = 1.38e-23; % Boltzmann Constant
T   = 290;      % room temperature
%%% Signal Generation %%%
continuousTimeSamplingRate    = 20e9;     % A sampling rate which is sufficiently high in order to be close to the continous time
basebandSamplingRate_or       = 30e6;     % The sampling rate of the complex baseband signal ; Units : Samples/second
                                          % in this project it MUST BE a multiple of symbolRate

basebandSamplingRate          = continuousTimeSamplingRate/round(continuousTimeSamplingRate/basebandSamplingRate_or);


%%% Signal Characteristics %%%
symbolRate              = 15e6;  % The raw symbol rate : the raw complex QAM symbols are sent at this rate ; Units : Symbols/second
basebandOverSampling    = round(basebandSamplingRate/symbolRate);
NSamples_BB             = 1e3;   % Signal length (after RRC filter)

% Signal frequencies
freqVin_or1   = 7.12e6;
freqVin_or2   = 6.12e6;
% Place the sine waves in an FFT bin
freqVin1      = round(freqVin_or1/basebandSamplingRate*NSamples_BB)...
                  *basebandSamplingRate/NSamples_BB; 
freqVin2      = round(freqVin_or2/basebandSamplingRate*NSamples_BB)...
                  *basebandSamplingRate/NSamples_BB; 

% Time vector of the simulation
t = 0:1/basebandSamplingRate:(NSamples_BB-1)/basebandSamplingRate;

%%% Baseband (digital) shaping filter %%%
rollOff     = 0.25; % (for RRC filter, single sided output BW is (1+beta)*Rsymb/2 )
symbolSpan  = 25;   % This parameter is related to both the filter length and the attenuation of the stop band
% Instanciate filter
basebandRRC = rcosdesign(rollOff,symbolSpan,basebandOverSampling,'sqrt'); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Possible values of test_type are:
%%%%%                               'onetone' for a one-tone sine 
%%%%%                               'twotone' for a two-tone sine 
%%%%%                               'mod'     for a modulated QAM 16 signal
%%%%%                               'image'   for a modulated QAM 16 image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              

test_type='image';
switch test_type
   case 'onetone'
      %%% one tone signal%%%
      basebandSig = exp(1j*2*pi*freqVin1*t);
   case 'twotone'
      %%% two tone signal%%%
      basebandSig = exp(1j*2*pi*freqVin1*t)+exp(1j*2*pi*freqVin2*t);
   case 'mod'
      %%% Modulated signal
      modSize       = 16; % Modulation order for 16QAM
      nQAMSymbols   = round(NSamples_BB/basebandOverSampling); % Number of QAM symbols to be generated
      inSig         = randi([0 modSize-1],nQAMSymbols,1);      % generate symbols as integer

      % Perform modulation : convert integer symbols to complex symbols
      if isOctave
         qamSig        = qammod(inSig,modSize);
         qamSig        = qamSig/sqrt(mean(abs(qamSig).^2));
      else % Matlab
         qamSig        = qammod(inSig,modSize,'UnitAveragePower',true);
      end

      % Apply filter with upsampling to basebandSamplingRate 
      basebandSig   = resample(qamSig,basebandOverSampling,1,basebandRRC);
      % Resample (compared to upfirdn) generates a signal that is exactly the 
      % length we can predict without having to compensate for the delay introduced by the filter
      % https://groups.google.com/d/msg/comp.soft-sys.matlab/UGLNR9vFqhM/c56ZlfUlhhcJ
   case 'image'
      % Load and prepare the image
      img = imread('image.jpg'); % Load image (adjust path as needed)
      img = imresize(img, [63 63]);   % Resize to reduce data size
      img_gray = rgb2gray(img);       % Convert to grayscale if necessary
      img_vector = img_gray(:);       % Flatten to a column vector

      % Convert pixel values to bits (8 bits per pixel)
      bits = de2bi(img_vector, 8, 'left-msb')';
      bits = bits(:);

      % Pad bits to make length a multiple of 4 (for 16-QAM)
      numBits = length(bits);
      remainder = mod(numBits, 4);
      if remainder ~= 0
          bits = [bits; zeros(4 - remainder, 1)];
      end

      % Convert bits to 16-QAM symbols
      symbols = reshape(bits, 4, [])';
      symbol_indices = bi2de(symbols, 'left-msb');
      modSize = 16;
      if isOctave
          qamSig = qammod(symbol_indices, modSize);
          qamSig = qamSig / sqrt(mean(abs(qamSig).^2));
      else
          qamSig = qammod(symbol_indices, modSize, 'UnitAveragePower', true);
      end

      % Adjust parameters based on image size
      nQAMSymbols = length(qamSig);
      basebandOverSampling = round(basebandSamplingRate / symbolRate);
      NSamples_BB = nQAMSymbols * basebandOverSampling;
      t = 0:1/basebandSamplingRate:(NSamples_BB-1)/basebandSamplingRate;

      % Apply RRC filter and resample
      basebandSig = resample(qamSig,basebandOverSampling,1,basebandRRC);
   otherwise
      %%% one tone signal%%%
      basebandSig = exp(1j*2*pi*freqVin1*t);
end
    


%%% IQ separation for real baseband signals %%%
[basebandDigital_I_unorm,basebandDigital_Q_unorm] = complx2cart(basebandSig(:));

%%% Digital to Analog Conversion %%%
nBitDAC = 9;           % Number of bits of the DAC
Vref    = 0.395;  %0.395          % Voltage reference of the DAC
dacType = 'zoh';        % DAC type ; can be 'zoh' or 'impulse'

% Normalize signal for conversion
% Must use same scale factor for both wave (Take max of both)
normalize_factor    = max( max(abs(basebandDigital_I_unorm)),...
                           max(abs(basebandDigital_Q_unorm)));
basebandDigital_I   = basebandDigital_I_unorm/normalize_factor*Vref;
basebandDigital_Q   = basebandDigital_Q_unorm/normalize_factor*Vref;

% Perform conversion
basebandAnalog_dac_I = DAC(basebandDigital_I,nBitDAC,Vref,dacType,basebandSamplingRate,continuousTimeSamplingRate);
basebandAnalog_dac_Q = DAC(basebandDigital_Q,nBitDAC,Vref,dacType,basebandSamplingRate,continuousTimeSamplingRate);

%%% Baseband FAKE Analog filter %%%
Rin             = 50;    % Input impedance of the filter
TXBB_Filt_NF    = 0;    %(in dB)

% https://fr.mathworks.com/help/signal/ref/firpmord.html
TXBB_Filt_rp    = 0.5;         % Passband ripple in dB
TXBB_Filt_rs    = 40;          % Stopband ripple in dB
TXBB_Filt_fs    = continuousTimeSamplingRate; % Sampling frequency (Hz)
TXBB_Filt_f     = [10 20]*1e6;  % Cutoff frequencies (Hz)
TXBB_Filt_a     = [1 0];        % Desired amplitudes
% Convert the deviations to linear units. 
TXBB_Filt_dev   = [(10^(TXBB_Filt_rp/20)-1)/(10^(TXBB_Filt_rp/20)+1) 10^(-TXBB_Filt_rs/20)];
% Design the filter
[TXBB_Filt_n,TXBB_Filt_fo,TXBB_Filt_ao,TXBB_Filt_w] ...
                = firpmord(TXBB_Filt_f,TXBB_Filt_a,TXBB_Filt_dev,TXBB_Filt_fs);
disp('Designing the TX filter - This takes a while...')
TXBB_Filt       = firpm(TXBB_Filt_n,TXBB_Filt_fo,TXBB_Filt_ao,TXBB_Filt_w);

% Perform filtering
disp('Filtering with the TX filter - This takes a while...')
basebandAnalog_filt_I = basebandAnalogFiltFake(basebandAnalog_dac_I,TXBB_Filt,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);
basebandAnalog_filt_Q = basebandAnalogFiltFake(basebandAnalog_dac_Q,TXBB_Filt,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);

%%% Mixing up to RF %%%
Flo      = 2.4e9; % Local Oscillator Frequency
rfSignal = upMixer(basebandAnalog_filt_I,basebandAnalog_filt_Q,Flo,continuousTimeSamplingRate);

%%% RF Amplification %%%
% Select a model between 1, 2, 3, 4 or 5
PA_model    = 5  ; 
switch (PA_model) 
  case 1  % V63+
   PA_IIP3  = 10.62;
   PA_Gain  = 19.88;
   PA_NF    = 3.7;
   P_con_PA = 0.500;
  case 2 % V62+
   PA_IIP3  = 17.12;
   PA_Gain  = 15.38;
   PA_NF    = 5;
   P_con_PA = 0.725;
  case 3  %ZHL42+
   PA_IIP3  = 5.39;
   PA_Gain  = 39.46;
   PA_NF    = 8.07;
   P_con_PA = 15;
  case 4  % RFLUPA05M06G
   PA_IIP3  = 43-36;
   PA_Gain  = 36;
   PA_NF    = 3;
   P_con_PA = 12 * 350 * 10^(-3);
  case 5 % ADL5606
   PA_IIP3       = 44.3-21.45;     
   PA_NF         = 4.9;      
   PA_Gain       = 21.45;     
   P_cons_PA = 380*10^(-3) * 5;
  otherwise
   PA_IIP3       = 0;     
   PA_NF         = 0;      
   PA_Gain       = 500;     
   P_cons_PA = 500;
end

rfPASignal    = rfPA(rfSignal,PA_Gain,PA_NF,PA_IIP3,Rin,continuousTimeSamplingRate/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Ps & SNR                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(rfPASignal);
Bin_In = round((Flo+freqVin_or1)/continuousTimeSamplingRate*N);
n = 2; %% prcq c'est un fenetrage de blackman
f2 = round((30e6/2+Flo)/continuousTimeSamplingRate*N);
f1 = round((-30e6/2+Flo)/continuousTimeSamplingRate*N);
Bin_Limits = [f1,f2];
[SNDR,PS]= perf_estim(rfPASignal,Bin_In,n,Bin_Limits,0);
snr_db = calculate_snr(rfPASignal,f1,f2,5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         ACPR                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_min = Flo - 30e6/2;
f_max = Flo + 30e6/2;
ACPR = compute_ACPR_lowpass_realval(rfPASignal,[f_min,f_max],[f_max,f_max+30e6],continuousTimeSamplingRate );


disp(['PS (w) : ' , num2str(PS)])
disp(['snr  : ', num2str(snr_db)])
disp(['SNDR  : ',num2str(SNDR)])
disp(['ACPR : ',num2str(ACPR)])
Vrms = sqrt(mean(rfPASignal.^2));       % Tension RMS
P_avg = (Vrms^2) / Rin;                % Puissance moyenne (W)
P_dBm = 10*log10(P_avg / 1e-3);   % Conversion en dBm
disp(['Puissance temporelle: ', num2str(P_dBm)]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Channel                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Channel %%%
carrierFreq        = Flo; % Center frequency of the transmission
c                  = 3e8; % speed of light in vacuum
distance           = 1.4; % Distance between Basestation and UE : [1.4,1.4e3] metres
% Amplitude Attenuation in free space
ChannelAttenuation = (c/carrierFreq./(4*pi*distance))^2; % Free space path loss in terms of power
rxSignal           = rfPASignal*sqrt(ChannelAttenuation);
AntennaNoise       = randn(length(rxSignal),1)*sqrt(K*T*continuousTimeSamplingRate/2*Rin);
rxSignal_WAT       = rxSignal+AntennaNoise;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Receiver                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%    SNR & PAPR (SNR not used for analysis)   %%%   
Vrms = sqrt(mean(rxSignal_WAT.^2));       % Tension RMS
Vmax = max(rxSignal_WAT);
disp(['tension vrms : ',num2str(Vrms),'tension max :',num2str(Vmax)])
f2 = round((20e6/2+Flo)/continuousTimeSamplingRate*N);
f1 = round((-20e6/2+Flo)/continuousTimeSamplingRate*N);
snr_db = calculate_snr(rxSignal_WAT,f1,f2,5);
disp(['snr (dbm) : ', num2str(snr_db)])

%%
%%% LNA %%%
LNA_Gain = 15;   % (dB)
LNA_IIP3 = 0;  % (dBm)
LNA_NF   = 1;    % (dB)
rfLNASignal = rfLNA(rxSignal_WAT,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2);

%%% Mixing down to BB %%%
[basebandAnalog_raw_I,basebandAnalog_raw_Q] = downMixer(rfLNASignal,Flo,continuousTimeSamplingRate);

%%% Baseband fake Analog filter %%%
RXBB_Filt_NF    = 0;     %(in dB)

RXBB_Filt_rp    = 0.5;         % Passband ripple in dB
RXBB_Filt_rs    = 40;          % Stopband ripple in dB
RXBB_Filt_fs    = continuousTimeSamplingRate; % Sampling frequency (Hz)
RXBB_Filt_f     = [10 20]*1e6;  % Cutoff frequencies (Hz)
RXBB_Filt_a     = [1 0];        % Desired amplitudes

% Convert the deviations to linear units. 
RXBB_Filt_dev   = [(10^(RXBB_Filt_rp/20)-1)/(10^(RXBB_Filt_rp/20)+1) 10^(-RXBB_Filt_rs/20)];
% Design the filter
[RXBB_Filt_n,RXBB_Filt_fo,RXBB_Filt_ao,RXBB_Filt_w] ...
                = firpmord(RXBB_Filt_f,RXBB_Filt_a,RXBB_Filt_dev,RXBB_Filt_fs);
disp('Designing the RX filter - This takes a while...')
RXBB_Filt       = firpm(RXBB_Filt_n,RXBB_Filt_fo,RXBB_Filt_ao,RXBB_Filt_w);

% Perform filtering
disp('Filtering with the RX filter - This takes a while...')
basebandAnalog_filtrx_I = basebandAnalogFiltFake(basebandAnalog_raw_I,RXBB_Filt,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);
basebandAnalog_filtrx_Q = basebandAnalogFiltFake(basebandAnalog_raw_Q,RXBB_Filt,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);


%%% Baseband Gain %%%
BBamp_Gain    = 19.03; % (dB)
BBamp_IIP3    = 40; % (dBm)
BBamp_NF      = 10; % (dB)
BBamp_band    = 10e6;% (MHz)
basebandAnalog_amp_I = BBamp(basebandAnalog_filtrx_I,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,BBamp_band,continuousTimeSamplingRate);
basebandAnalog_amp_Q = BBamp(basebandAnalog_filtrx_Q,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,BBamp_band,continuousTimeSamplingRate);

%%% Maximum voltage in I/Q voie %%%
Vmax_i = max(basebandAnalog_amp_I(200:end));
Vmax_q = max(basebandAnalog_amp_Q(200:end));
disp(['tension max_i : ',num2str(Vmax_i),'tension max_q :',num2str(Vmax_q)])

%%% Analog to Digital Conversion %%%
Vref_ADC = 1;
nBitADC = 13;
delay   = 0;%round(TXBB_Filt_n/2 + RXBB_Filt_n/2 + 1/(2*continuousTimeSamplingRate)); % WARNING : non trivial value !!! to be thoroughly analyzed
adcSamplingRate = basebandSamplingRate;
% Perform conversion
basebandAnalog_adc_I = ADC(basebandAnalog_amp_I,nBitADC,Vref_ADC,adcSamplingRate,delay,continuousTimeSamplingRate);
basebandAnalog_adc_Q = ADC(basebandAnalog_amp_Q,nBitADC,Vref_ADC,adcSamplingRate,delay,continuousTimeSamplingRate);
%%% IQ combination for complex baseband signals %%%
basebandComplexDigital                = complex(basebandAnalog_adc_I,basebandAnalog_adc_Q);

%%%  SNR (used for sinisoidale Signal) %%%
if (!(strcmp(test_type, 'image')))
   N = length(basebandAnalog_adc_I);
   f_adc = freqVin_or1*N/1.5;
   freqVin1      = round(f_adc/continuousTimeSamplingRate*N);
   BW = 5e6*N/1.5 ;
   f2 = round((BW+f_adc)/continuousTimeSamplingRate*N);
   f1 = round((-BW+f_adc)/continuousTimeSamplingRate*N);
   snr_db = calculate_snr(basebandAnalog_adc_I,f1,f2,5);
   disp(['snr  : ', num2str(snr_db)])

end
% RX RRC and downsampling (reverse effect of resample(qamSig...) )
% WARNING : this downsampling may create unexpected sampling effects due to butterworth filtering and phase distortion
%           please check signals integrity before and after this step
basebandComplexDigital_fir            = resample(basebandComplexDigital,1,basebandOverSampling,basebandRRC);

% Normalize received symbols to UnitAveragePower (see qammod(inSig)) 
% Trully effective when noise and distortions are not too large compared to the useful signal
basebandComplexDigital_fir            = basebandComplexDigital_fir / sqrt(var(basebandComplexDigital_fir));

% Coarse truncation of the transient parts. 
% This should be optimized with respect to the filters delays. 
basebandComplexDigital_fir_truncated  = basebandComplexDigital_fir(10:end-10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Plot section            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(test_type, 'image')
    % Demodulate received symbols
    received_symbols = basebandComplexDigital_fir;
    modSize = 16;
    if isOctave
        received_indices = qamdemod(received_symbols, modSize);
    else
        received_indices = qamdemod(received_symbols, modSize, 'UnitAveragePower', true);
    end
    
    % Convert symbols to bits
    received_bits = de2bi(received_indices, 4, 'left-msb')';
    received_bits = received_bits(:);
    
    % Remove padding (assuming original image size is known)
    expected_pixels = 63 * 63; % Adjust based on image size
    expected_bits = expected_pixels * 8;
    received_bits = received_bits(1:expected_bits);
    
    % Convert bits to pixel values
    received_bytes = reshape(received_bits, 8, [])';
    received_pixels = bi2de(received_bytes, 'left-msb');
    
    % Reshape to original image dimensions
    img_received = reshape(received_pixels, size(img_gray));
    
    % Display the received image
    figure;
    subplot(1, 2, 1); % 1 ligne, 2 colonnes, 1ère image
    imshow(uint8(img_received));
    title('Image reçue');

    subplot(1, 2, 2); % 1 ligne, 2 colonnes, 2ème image
    imshow(img_gray);
    title('Image en niveaux de gris');
   %% U should press to see other plots :)
    waitforbuttonpress;
end

window_number       = 1;
lineSpec_index      = 1;
fullband_spectrum   = true;

plot_spectrum(basebandSig,window_number,...
               adcSamplingRate,lineSpec_index,fullband_spectrum);
title('TX Digital Complex recombined signal')

window_number       = window_number+1;
plot_spectrum(basebandComplexDigital,window_number,...
               adcSamplingRate,lineSpec_index,fullband_spectrum);
title('Receiver complex recombined output')

window_number       = window_number+1;
fullband_spectrum   = false;
plot_spectrum(rfPASignal,window_number,...
               continuousTimeSamplingRate,lineSpec_index,fullband_spectrum);
title('PA spectrum')
plot(0:continuousTimeSamplingRate:continuousTimeSamplingRate*(length(basebandAnalog_amp_I)-1), basebandAnalog_amp_I, 'r-', 'MarkerSize', 8, 'LineWidth', 2); 
title('Tension in ADC entry');
xlabel('Time (s)');
ylabel('Tension (v)');
if strcmp(test_type, 'mod') | strcmp(test_type, 'image')
   figure()
   subplot(1,2,1)
   plot(qamSig,'d')
   title('constellation at TX')
   subplot(1,2,2)
   plot(basebandComplexDigital_fir_truncated,'d')
   title('constellation at RX')
   % WARNING : the received constellation has almost no sense until filters
   %           delays have been thoroughly analyzed and compensated
end


%------------- END OF CODE --------------
    