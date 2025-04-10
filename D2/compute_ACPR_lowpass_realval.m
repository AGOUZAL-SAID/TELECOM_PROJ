function [ACPR_db] = compute_ACPR_lowpass_realval(x,f_lim_main_chan,f_lim_adj_chan,fs)
% compute_ACPR_lowpass_realval - compute a simple version of ACPR for a lowpass
% real-valued signal
%
% It is assumed that the signal is symetric around the 0 frequency ; therefore,
% the power of the main channel is just computed as the twice of its right
% positive part.
%
% Syntax: [ACPR_db] = compute_ACPR_lowpass_realval(x,f_lim_main_chan,f_lim_adj_chan,fs)
%
% Inputs: 
%   x               [1D array]        : signal
%   f_lim_main_chan [2-elements array]: limits of the main channel in Hz
%   f_lim_adj_chan  [2-elements array]: limits of the adjacent channel in Hz
%   fs              [scalar]          : sampling frequency in Hz
%
% Outputs: 
%   ACPR_db         [scalar]          : ACPR in dB
%
% Example:
%   
%
% See also:
%   
%
% Germain PHAM, C2S Telecom Paris, 2023

% Compute spectrum
win           = blackman(length(x),'periodic');
x_windowed    = x(:).*win(:); % windowing
x_psd         = abs(fft(x_windowed)).^2;

% Compute bin limits
bin_lim_main_chan = round(f_lim_main_chan*length(x)/fs)+1;
bin_lim_adj_chan  = round(f_lim_adj_chan*length(x)/fs)+1;

% Sum power in the main and adjacent channels
pow_main_chan = sum(x_psd(bin_lim_main_chan(1):bin_lim_main_chan(2)));
pow_adj_chan  = sum(x_psd(bin_lim_adj_chan(1):bin_lim_adj_chan(2)));

% Compute ACPR
ACPR_db = 10*log10(2*pow_main_chan/pow_adj_chan);

end