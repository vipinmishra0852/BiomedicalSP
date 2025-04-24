clc
clear all;
close all;
[signal, fs] = rdsamp('datasets/s0010_re',1,500); %Read 500 samples from the signal
 
%Extract the first channel (assuming a multi-lead ECG)
ecg_signal = signal(:,1);
 
%Time vector based on signal length and sampling frequency
t = (0:length(ecg_signal)-1) / fs;
 
 
 
%% Plot Original Signal 
figure;
subplot(3,1,1);
plot(t, ecg_signal, 'b');
xlabel('Time(s)');
ylabel('Amplitude');
title('Original Noisy ECG Signal')
% xlim([0 2]);
 
%% FIR Low Pass Filtered Signal
fc = 55;        % Cutoff frequency (Hz)
order = 50;     % Filter order
fir_coeffs = fir1(order, fc/(fs/2), 'low'); % FIR filter design
ecg_fir_filtered = filter(fir_coeffs, 1, ecg_signal);
 
% Plot FIR Filtered Signal
subplot(3,1,2);
plot(t, ecg_fir_filtered, 'g')
xlabel('Time(s)');
ylabel('Amplitude');
title('FIR Low Pass Filtered ECG Signal (Remove HF Noise)')
% xlim([0 2]);
 
%% IIR Notch Filter (Renove Powerline Interference)
f_notch = 50;           %Notch frequency (Hz)
bw = 5;                 % Bandwidth (Hz)
wo = f_notch/(fs/2);    %Normalized frequency
[b, a] = iirnotch(wo, bw/(fs/2));  %IIR Notch filter design
ecg_iir_filtered = filter(b, a, ecg_fir_filtered);
 
% Plot IIR Filtered Signal 
subplot(3,1,3);
plot(t, ecg_iir_filtered, 'r');
xlabel('Time(s)');
ylabel('Amplitude');
title('IIR Notch Filtered ECG Signal (Remove HF Noise)')
% xlim([0 2]);
 
%% Frequency Analysis
 
figure;
frequencies = linspace(0, fs/2, length(t)/2);
 
% Compute FFT
fft_orig = abs(fft(ecg_signal));
fft_fir = abs(fft(ecg_fir_filtered));
fft_iir = abs(fft(ecg_iir_filtered));
 
% Plot FFT before and after filering
plot(frequencies, fft_orig(1: length(frequencies)), 'b', 'LineWidth', 1);
hold on
plot(frequencies, fft_fir(1: length(frequencies)), 'g', 'LineWidth', 1);
plot(frequencies, fft_iir(1: length(frequencies)), 'r', 'LineWidth', 1);
 
xlabel('frequency (Hz)');
ylabel('Magnitude');