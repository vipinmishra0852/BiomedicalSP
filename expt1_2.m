% interpolation

D = input('Enter the Downsampling Factor: ');
L = input('Enter the Length of the input signal: ');

f1 = input('Enter the frequency of the first sinusoidal signal: ');
f2 = input('Enter the frequency of the second sinusoidal signal: ');

n = 0:L-1;

% Create the input signal as the sum of two sinusoidal signals
x = sin(2*pi*f1*n) + sin(2*pi*f2*n);

% Decimate (downsample) the signal
y = decimate(x, D, 'fir');

% Upsample (interpolate) the decimated signal by a factor of I
I = input('Enter the Interpolation Factor: ');  % Interpolation factor
y_interpolated = upsample(y, I);

% Plot the original signal
subplot(3, 1, 1);
stem(n, x(1:L));  % Display original signal
title('Input Sequence');
xlabel('Time (n)');
ylabel('Amplitude');

% Plot the decimated signal
subplot(3, 1, 2);
m = 0:(L/D)-1;
stem(m, y(1:L/D));  % Display decimated signal
title('Decimated Sequence');
xlabel('Time (n)');
ylabel('Amplitude');

% Plot the interpolated signal
subplot(3, 1, 3);
m_interpolated = 0:(L/D)*I-1;  % Adjust the time vector for interpolated signal
stem(m_interpolated, y_interpolated(1:(L/D)*I));  % Display interpolated signal
title('Interpolated Sequence');
xlabel('Time (n)');
ylabel('Amplitude');


