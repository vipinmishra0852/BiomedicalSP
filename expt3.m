clc; clear all; close all;
%Load ECG Signal ( select only one channel )
[ ecg_signal, fs ] = rdsamp('datasets/s0016lre');
%check if ecg_signal has multiple columns
if size(ecg_signal,2) > 1
    ecg_signal = ecg_signal(:,1); %Select the first channel
end
%Display basic info
disp(['Sampling Frequency: ', num2str(fs), ' Hz']);
disp(['Signal Length: ', num2str(length(ecg_signal)), ' samples ']);
 
%Plot ECG Signal
t = (0:length(ecg_signal)-1) / fs; %Time axis
figure;
plot(t,ecg_signal);
xlabel('Time(s)');
ylabel('Amplitude');
title('Raw ECG Signal from PhysioNet');
grid on;
 
%Step 1: Bandpass Filtering (0.5 - 50 Hz)
low_freq = 0.5;
high_freq = 50;
[b, a] = butter(3, [low_freq high_freq] / (fs/2), 'bandpass'); %Bandpass Butterworth Filter
filtered_ecg = filtfilt(b, a, ecg_signal);
 
%Step 2: Differentiation
diff_ecg = diff(filtered_ecg);
 
%Step 3: Squaring
squared_ecg = diff_ecg.^2;
 
%Step 4: Moving Window Integration
window_size = round(0.150 * fs); % 150ms window
window = ones(1, window_size) / window_size;
mid_ecg = filter(window, 1, squared_ecg);
 
 
%Ensure mid_ecg is a vector
mwi_ecg = mid_ecg(:); %Convert to column vector if needed
 
%Step 5: Peak Detection with Adaptive Threshold 
threshold = 0.6*max(mwi_ecg); %Initial Threshold
[~, r_peaks] = findpeaks(mwi_ecg, 'MinPeakHeight', threshold, 'MinPeakDistance', round(0.6*fs));
 
%Plot Results
figure;
subplot(3,1,1); plot(ecg_signal); title('Original ECG Signal');
subplot(3,1,2); plot(mwi_ecg); title('Processed ECG - Pan-Tompkins');
hold on; plot(r_peaks, mwi_ecg(r_peaks), 'ro'); hold off;
subplot(3,1,3); stem(diff(r_peaks)/ fs*60); title('Heart Rate (BPM)');
 
disp(['Detected Heart Rate: ', num2str(mean(diff(r_peaks) / fs*60)), 'BPM']);



