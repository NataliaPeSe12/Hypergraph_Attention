function [coherences, tauMatrix_lag, coh_vs_lag_matrix, pMatrix] = calculate_directed_coherence(F, Fs, f_range, numPermutations, alpha)

% Optimized version of the directed coherence calculation with permutation testing.
num_channels = size(F,1);
coherences = zeros(num_channels);
tauMatrix_lag = NaN(num_channels);
coh_vs_lag_matrix = cell(num_channels);
pMatrix = ones(num_channels);

% Parameters
maxLagMs = 500;
lag_step = 10; % ms
lag_range = -maxLagMs:lag_step:maxLagMs;
lag_samples = round(lag_range / 1000 * Fs);
lags_sec = lag_samples / Fs;

window_length = 1024;
overlap = window_length / 2;
nfft = 2048;
window_hann = hann(window_length); % Reuse window

% Bandpass filter
d = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', f_range(1), 'HalfPowerFrequency2', f_range(2), ...
    'SampleRate', Fs);

% Filter signals
dataFilt = zeros(size(F));
parfor c = 1:num_channels
    dataFilt(c,:) = filtfilt(d, F(c,:));
end

for i = 1:num_channels
    disp(['i = ', num2str(i)]);
    for j = i+1:num_channels
        disp(['j = ', num2str(j)]);
        X = dataFilt(i,:);
        Y = dataFilt(j,:);

        % Actual coherence vs. lag
        coh_vs_lag = zeros(1, length(lag_samples));
        for k = 1:length(lag_samples)
            lag = lag_samples(k);
            Y_lag = circshift(Y, lag);
            validIdx = true(size(Y));
            [Cxy, f] = mscohere(X(validIdx), Y_lag(validIdx), window_hann, overlap, nfft, Fs);
            idxFreq = f >= f_range(1) & f <= f_range(2);
            coh_vs_lag(k) = mean(Cxy(idxFreq));
        end

        coh_vs_lag_matrix{i,j} = coh_vs_lag;

        [real_peaks, locs] = findpeaks(coh_vs_lag);

        % Global permutation test for this pair
        null_peaks = zeros(1, numPermutations);
        parfor p = 1:numPermutations
            Y_perm = Y(randperm(length(Y)));
            max_val = 0;
            for k = 1:length(lag_samples)
                lag = lag_samples(k);
                Yp_lag = circshift(Y_perm, lag);
                validIdx = true(size(Y));
                [Cxy, f] = mscohere(X(validIdx), Yp_lag(validIdx), window_hann, overlap, nfft, Fs);
                idxFreq = f >= f_range(1) & f <= f_range(2);
                max_val = max(max_val, mean(Cxy(idxFreq)));
            end
            null_peaks(p) = max_val;
        end

        % Significance check
        found = false;
        for pk = 1:length(real_peaks)
            real_peak = real_peaks(pk);
            p_val = (sum(null_peaks >= real_peak) + 1) / (numPermutations + 1);
            if p_val < alpha
                idx = locs(pk);
                tau = lags_sec(idx);
                coherences(i,j) = real_peak;
                coherences(j,i) = real_peak;
                tauMatrix_lag(i,j) = tau;
                tauMatrix_lag(j,i) = -tau;
                pMatrix(i,j) = p_val;
                pMatrix(j,i) = p_val;
                found = true;
                break;
            end
        end

        if ~found
            tauMatrix_lag(i,j) = NaN;
            tauMatrix_lag(j,i) = NaN;
            coherences(i,j) = 0;
            coherences(j,i) = 0;
            pMatrix(i,j) = 1;
            pMatrix(j,i) = 1;
        end
    end
end
end
