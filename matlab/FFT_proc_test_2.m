clear all
close all
clc
%test per trasformate a due stadi

N = 20;
P_cas = [1,2];
N0_cas = [4,5];

P = P_cas(1);
N0 = N0_cas(1);

% number of samples to filter
n=0:1:2*N-1;
wpb=2*pi/(N-1);  % 1/N of the sampling rate Fs
  
% input signal
x=sin(wpb*n);
plot(x)
% normalize x so that I can represent it in
% format s0.15
xmax=max(abs(x)); 
x=x/(2*xmax);
X = fft(x,N);

for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
%             i + (j-1)*N/(N0) + (k-1)*P
            x1(j + (i-1)*N0 + (k-1)*N0*P) = x(i + (j-1)*N/(N0) + (k-1)*P); %riorganizza dati , prendendone uno ogni 10
        end
    end
end

figure()
plot(x1)
X1 = x1'*2^15;
for i=1:N0:N
    xFFT1(i:i+N0-1) = fft(x1(i:i+N0-1),N0);  %first stage FFT
end
XFFT1 = xFFT1' * 2^11;
figure()
plot(abs(xFFT1(1:N)),'LineWidth',2)
title('Intermidiate stage 1')
%%
P = P_cas(2);
N0 = N0_cas(2);

for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
            k1 = i - 1 + (k-1)*P;
            n2 = (j-1);
            % add = i + (j-1)*N/(N0) + (k-1)*P            % genera indirizzo per richiamare i dati nel corretto ordine
%             i + (j-1)*N/(N0) + (k-1)*P
%             j + (i-1)*N0 + (k-1)*N0*P
%             2*pi*k1*n2/N * 2^13
            K1(j + (i-1)*N0 + (k-1)*N0*P) = k1*n2;   %calcolo di K per ottenera theta da usare nel cordic
            theta(j + (i-1)*N0 + (k-1)*N0*P) = 2*pi*k1*n2/(N0_cas(1)*N0_cas(2)) * 2^13;
%             x2(j + (i-1)*N0 + (k-1)*N0*P) = xFFT1(i + (j-1)*N/(N0) + (k-1)*P)*exp(-1i*2*pi*k1*n2/N);
            [x2(j + (i-1)*N0 + (k-1)*N0*P)] = cordic(xFFT1(add)*2^13 , theta(j+(i-1)*N0+(k-1)*N0*P))*2^(-13);
        end
    end
end
data_C1 = x2'*2^12;
for i=1:N0:N
    xFFT2(i:i+N0-1) = fft(x2(i:i+N0-1),N0); %second stage FFT
end

XFFT2 = xFFT2'*2^10;
figure()
plot(abs(xFFT2(1:N)),'LineWidth',2)
title('Intermidiate stage 2')

%%

P = P_cas(1);
N0 = N0_cas(1);

for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
            i + (j-1)*N/(N0) + (k-1)*P
            xFFT(j + (i-1)*N0 + (k-1)*N0*P) = xFFT2( i + (j-1)*N/(N0) + (k-1)*P);
        end
    end
end

figure()
plot(abs(xFFT(1:N)),'LineWidth',3)
title('Signal Spectrum')
hold on
plot(abs(X(1:N)),'LineWidth',2)

legend('Algorithm','Matlab')
hold off
