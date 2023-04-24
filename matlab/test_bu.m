%%
clear all
close all
clc

N = 16;
N0 = 8;
% number of samples to filter
n=0:1:2*N-1;

% normalized pulsations of the two sinusoids
% that make up the input signal
wpb=2*pi*2/(N-1);  % 1/N of the sampling rate Fs
  
% input signal
x=sin(wpb*n);
xmax=max(abs(x)); 
x=2*x/(N*xmax);
figure()

plot(x(1:N))
% normalize x so that I can represent it in
% format s0.14

% x1 = zeros(N);
% saves the input data
dlmwrite('x_data.txt', x, '\n');

%%

% x0=fi(x,true,14);
% ft = dsp.FFT('FFTLengthSource','Auto');
%%
clear yvi
clear yvr
clear yv_load
clear xFFT


for i = 1:N0:length(x)
    xFFT(i:(i+N0-1)) = fft(x(i:(i+N0-1)),N0);
end 

figure()
plot(abs(xFFT),'LineWidth',2)
title('Signal Spectrum')
hold on

yv_load=importdata("yv_data_bu.txt");
yvr = yv_load(:,1);
yvi = yv_load(:,2);
yv_mag = abs(yvr + yvi.*1i);

plot(yv_mag,'LineWidth',2)
legend('Matlab','VHDL')
