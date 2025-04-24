% The goal of this code is to classify ECG signals based on the presence of P-waves using a KNN classifier.
clc; 
clear all; 
close all;
 
% Step 1: Load ECG Signal 
[ecg_signal, fs] = rdsamp('datasets/100');  
ecg_signal = ecg_signal(:, 1);  % Ensure it's a 1D vector
 
% Step 2: Load Annotations (Real Labels)
[ann_times, ann_types] = rdann('datasets/100', 'pwave'); % Load annotation times & types
 
% Step 3: Extract Features (Mean & Standard Deviation)
window_size = fs * 1; % 1-second windows
num_samples = floor(length(ecg_signal) / window_size);
features = zeros(num_samples, 2);
labels = zeros(num_samples, 1); % Placeholder for real labels
 
% Step 4: Assign Real Labels Based on Annotations
for i = 1:num_samples
    % Get the segment of ECG signal
    segment_start = (i-1) * window_size + 1;
    segment_end = i * window_size;
    segment = ecg_signal(segment_start : segment_end);
    
    % Compute features (mean & std deviation)
    features(i, :) = [mean(segment), std(segment)];
    
    % Find if annotation falls within this segment
    if any(ann_times >= segment_start & ann_times <= segment_end)
        labels(i) = 1; % Mark as 'P-wave present'
    else
        labels(i) = 0; % Mark as 'No P-wave'
    end
end
 
% Step 5: Train KNN Classifier (K = 3)
knn_model = fitcknn(features, labels, 'NumNeighbors', 3);
 
% Step 6: Predict & Evaluate
predicted_labels = predict(knn_model, features);
accuracy = sum(predicted_labels == labels) / length(labels) * 100;
fprintf('Classification Accuracy (KNN): %.2f%%\n', accuracy);
 
% Step 7: Confusion Matrix
conf_matrix = confusionmat(labels, predicted_labels);
disp('Confusion Matrix:');
disp(conf_matrix);
 
% Visualize Confusion Matrix
figure;
confusionchart(conf_matrix, [0, 1]); % Ensure labels are 0 and 1
title('Confusion Matrix for ECG Classification (KNN)');
xlabel('Predicted Class');
ylabel('True Class');



