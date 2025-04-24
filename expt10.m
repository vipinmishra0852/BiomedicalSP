clc; 
clear all; 
close all;

%% Read signals using rdsamp
[emg1, fs1, t1] = rdsamp('datasets/session3_participant1_gesture10_trial1');  % first gesture
[emg2, fs2, t2] = rdsamp('datasets/session3_participant1_gesture11_trial1');  % second gesture

% Use only 1 channel (e.g., channel 1)
emg1 = emg1(:, 1);
emg2 = emg2(:, 1);
fs = fs1; % assume both have same sampling rate

%% Bandpass Filter (20–450 Hz)
[b, a] = butter(4, [20 450]/(fs/2), 'bandpass');
emg1_filt = filtfilt(b, a, emg1);
emg2_filt = filtfilt(b, a, emg2);

%% Feature Extraction (sliding window)
window_size = 200;
step_size = 100;

features = [];
labels = [];

% Gesture 1 → Label 0
for i = 1:step_size:(length(emg1_filt) - window_size)
    segment = emg1_filt(i:i+window_size-1);
    mav = mean(abs(segment)); % It is average of absolute values. It gives measure of muscle contraction level.
    rms_val = rms(segment); % It indicates power of the EMG signal
    zc = sum(diff(sign(segment)) ~= 0);% Zero crossings. Number of times the EMG signal crosses zero amplitude (from positive to negative or vice versa).
    features = [features; mav, rms_val, zc];
    labels = [labels; 0];
end

% Gesture 2 → Label 1
for i = 1:step_size:(length(emg2_filt) - window_size)
    segment = emg2_filt(i:i+window_size-1);
    mav = mean(abs(segment));
    rms_val = rms(segment);
    zc = sum(diff(sign(segment)) ~= 0);
    features = [features; mav, rms_val, zc];
    labels = [labels; 1];
end

%% Normalize features
features = normalize(features);

%% Train-test split
cv = cvpartition(length(labels), 'HoldOut', 0.2);
trainIdx = training(cv);
testIdx = test(cv);

XTrain = features(trainIdx, :);
YTrain = labels(trainIdx);
XTest = features(testIdx, :);
YTest = labels(testIdx);

%% Train classifier (kNN)
Mdl = fitcsvm(XTrain, YTrain);

%% Predict and evaluate
YPred = predict(Mdl, XTest);
acc = sum(YPred == YTest) / length(YTest) * 100;
fprintf('Accuracy = %.2f %%\n', acc);

figure;
confusionchart(YTest, YPred);
title('Gesture Classification Confusion Matrix');
