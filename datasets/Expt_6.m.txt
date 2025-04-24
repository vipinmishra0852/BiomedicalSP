% This is ECG signal compression using DWT
clc; clear all; close all;

% Load ECG signal from MIT-BIH Arrhythmia Database
[ecg_signal, fs] = rdsamp('s0010_re'); % Load signal (1st channel by default)
x = ecg_signal(:,1); % Extract first channel
t = (0:length(x)-1) / fs; % Time vector

% Plot Original ECG Signal
figure;
subplot(3,1,1);
plot(t, x, 'b'); grid on;
title('Original ECG Signal (MIT-BIH Data)');
xlabel('Time (s)'); ylabel('Amplitude');

%% Step 1: Perform Wavelet Decomposition
waveletType = 'db6'; % Daubechies wavelet (db6)
level = 6; % Decomposition Level

[C, L] = wavedec(x, level, waveletType); % Wavelet decomposition

%% Step 2: Apply Thresholding for Compression
% Compute threshold for coefficient compression
thr = 0.05 * max(abs(C)); % Adjust threshold level as needed

% Zero out small coefficients (retain only important details)
C_thr = C .* (abs(C) > thr);

%% Step 3: Signal Reconstruction
ecgCompressed = waverec(C_thr, L, waveletType); % Reconstruct signal

% Plot Compressed ECG Signal
subplot(3,1,2);
plot(t, ecgCompressed, 'r'); grid on;
title('Compressed & Reconstructed ECG Signal');
xlabel('Time (s)'); ylabel('Amplitude');

% Plot Difference (Removed Coefficients)
subplot(3,1,3);
plot(t, x - ecgCompressed, 'k'); grid on;
title('Lost Information (Difference Signal)');
xlabel('Time (s)'); ylabel('Amplitude');

%% Step 4: Performance Metrics
compression_ratio = nnz(C_thr) / nnz(C); % Ratio of retained coefficients
PRD = 100 * norm(x - ecgCompressed) / norm(x); % Percentage Root Mean Square Difference (PRD)

% Display Results
fprintf('Compression Ratio: %.2f%%\n', compression_ratio * 100);
fprintf('Percentage Root Mean Square Difference (PRD): %.2f%%\n', PRD);
