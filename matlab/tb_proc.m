%%
clear all
close all
clc

N = 4096;
P = 1;
N0 = 16;
% number of samples to filter
n=0:1:2*N-1;

% normalized pulsations of the two sinusoids
% that make up the input signal
wpb=2*pi/(N-1);  % 1/N of the sampling rate Fs
  
% input signal
x=sin(wpb*n);

figure()

plot(x(1:N))
% normalize x so that I can represent it in
% format s0.14
xmax=max(abs(x)); 
x=x/(2*xmax);  
for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
%             i + (j-1)*N/(N0) + (k-1)*P
            x1(j + (i-1)*N0 + (k-1)*N0*P) = x(i + (j-1)*N/(N0) + (k-1)*P);
        end
    end
end

% x1 = zeros(N);
% saves the input data
dlmwrite('x_data.txt', x1, '\n');
figure()
plot(x1)

%% Results plot
clear yvi
clear yvr
clear yv_load
clear yv_mag1
clear yv_mag
clear xFFT
clear X
clear Y
% % close all
clc

xFFT = fft(x(1:N));
xFFT_mag =abs(xFFT)';

yv_load = importdata("yv_data.txt");
yvr = yv_load(:,1);
yvi = yv_load(:,2);
yv_mag = abs(yvr + yvi.*1i);

figure()
plot(xFFT_mag,'LineWidth',4)
title('FFT')
hold on
plot(yv_mag(1:N),'LineWidth',2)

legend('Matlab','VHDL')
hold off

% figure()
% plot(xFFT_mag/max(xFFT_mag),'LineWidth',3)
% title('FFT (normalized)')
% hold on
% plot(yv_mag(1:N)/max(yv_mag),'LineWidth',2)

legend('Matlab','VHDL')
hold off
%% error evaluation
clear err
clear rel
close all
err = yv_mag - xFFT_mag;
rel = abs(err)/max(yv_mag);

B = ceil(log2(N))+1;
F = 16-B;
bit_err=2^-F;
expected_err = sqrt(2)*bit_err;
msr = sum(err.^2)/N;

figure()
plot(err)
title('Absolute error')
yline(expected_err,'--r')
yline(-expected_err,'--r')

mape = sum(rel)/N;
expected_rel = expected_err/max(xFFT_mag);
err(abs(err)<expected_err) = 0;
figure()
plot(rel)
title('Relative error')
yline(expected_rel,'--r')


%% first stage results plot
% clear yvi
% clear yvr
% clear yv_load
% clear yv_mag1
% clear yv_mag
% clear xFFT
% clear X
% clear Y
% clc
% 
% for i=1:N0:N
%     xFFT(i:i+N0-1) = fft(x1(i:i+N0-1),16);
% end
% 
% yv_load = importdata("yv_data.txt");
% yvr = yv_load(:,1);
% yvi = yv_load(:,2);
% yv_mag = abs(yvr + yvi.*1i);
% 
% 
% figure()
% plot(abs(xFFT(1:N)),'LineWidth',2)
% title('Signal Spectrum')
% hold on
% plot(yv_mag(1+16:N+16),'LineWidth',2)
% 
% legend('Matlab','VHDL')
% hold off

%% prove
% X= abs(xFFT)/(2*N);
% X = X(1:N);
% X(2:end-1) = 2*X(2:end-1);
% 
% fs = Fs*(1:N)/N;
% 
% figure()
% plot(fs,X,'LineWidth',2)
% title('Signal Spectrum')
% hold on
% Y = yv_mag;
% Y(2:end-1) = 2*Y(2:end-1);
% plot(fs,Y,'LineWidth',2)
