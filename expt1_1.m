% decimation

clc;
clear all;
close all;

D=input("Enter the Downsapmling Factor");
L=input("Enter the Length of the input signal");

f1=input("Enter the frequency of first sinusoidal signal");
f2=input("Enter the frequency of second sinusoidal signal");

n=0:L-1;

x=sin(2*pi*f1*n)+sin(2*pi*f2*n);
y=decimate(x,D,'fir');

subplot(2,1,1);
stem(n,x(1:L));
title('input sequence');
xlabel('time(n)');
ylabel('amplitude');

subplot(2,1,2);
m=0:(L/D)-1;
stem(m,y(1:L/D));
title('Decimated sequence');
xlabel('time(n)');
ylabel('amplitude');
