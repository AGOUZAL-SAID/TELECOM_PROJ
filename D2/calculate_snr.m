function snr_db = calculate_snr(time_signal, bin_low, bin_high, num_signal_bins)
% CALCULATE_SNR Calcule le SNR d'un signal dans une plage de bins spécifiée.


if nargin < 4
    num_signal_bins = 3;
end

N = length(time_signal);

% Création de la fenêtre Blackman
window = blackman(N);
sum_window = sum(window);
sum_window_squared = sum(window.^2);

% Application de la fenêtre et calcul de la FFT
windowed_signal = time_signal(:) .* window;
fft_vals = fft(windowed_signal);
power = abs(fft_vals).^2;

% Définition de la plage de bins correspondant à la bande d'intérêt
band_indices = bin_low:bin_high;

% Recherche du pic dominant dans la bande
[~, peak_local_idx] = max(power(band_indices));
peak_bin = band_indices(peak_local_idx);

% Détermination des bins du signal autour du pic
half_width = floor(num_signal_bins / 2);
bin_start = max(peak_bin - half_width, bin_low);
bin_end   = min(peak_bin + half_width, bin_high);
signal_bins = bin_start:bin_end;

% Calcul des puissances
signal_power = sum(power(signal_bins));
total_power  = sum(power(band_indices));
noise_power  = total_power - signal_power;

% Correction des effets de la fenêtre
signal_power_corr = signal_power ;
noise_power_corr  = noise_power ;



if noise_power_corr <= 0
    snr_db = Inf;
else
    snr_db = 10 * log10(signal_power_corr / noise_power_corr);
end

end
