clear all
close all
clc
%test per trasformate a tre stadi: non funziona
N = 30;
P_cas = [1,2,3];
N0_cas = [3,5,2];

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
x=x/(xmax);
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

for i=1:N0:N
    xFFT1(i:i+N0-1) = fft(x1(i:i+N0-1),N0);  %first stage FFT
end

figure()
plot(abs(xFFT1(1:N)),'LineWidth',2)
title('Intermidiate stage 1')

P = P_cas(2);
N0 = N0_cas(2);

for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
            k1 = k-1;
            n2 = (j-1);
            add = k + (i-1)*N0_cas(1)*N0_cas(2) + (j-1)*N/(N0*N0_cas(3));            % genera indirizzo per richiamare i dati nel corretto ordine
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
data_C1 = x2*2^13;
for i=1:N0:N
    xFFT2(i:i+N0-1) = fft(x2(i:i+N0-1),N0); %second stage FFT
end

figure()
plot(abs(xFFT2(1:N)),'LineWidth',2)
title('Intermidiate stage 2')

P = P_cas(3);
N0 = N0_cas(3);

for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
            k1 = (k-1)*P + i - 1 ;
            n2 = (j-1);
            add = (i-1)*N0*N0_cas(2) + (j-1)*N0_cas(2) + k;  
%             i + (j-1)*N/(N0) + (k-1)*P
%             j + (i-1)*N0 + (k-1)*N0*P
%             2*pi*k1*n2/N * 2^13
            K2(j + (i-1)*N0 + (k-1)*N0*P) = k1*n2;
            theta2(j + (i-1)*N0 + (k-1)*N0*P) = 2*pi*k1*n2/N * 2^13;
%             x2(j + (i-1)*N0 + (k-1)*N0*P) = xFFT1(i + (j-1)*N/(N0) + (k-1)*P)*exp(-1i*2*pi*k1*n2/N);
            [x3(j + (i-1)*N0 + (k-1)*N0*P)] = cordic(xFFT2(add)*2^13 , theta(j+(i-1)*N0+(k-1)*N0*P))*2^(-13);
        end
    end
end
data_C2 = x2*2^13;
for i=1:N0:N
    xFFT3(i:i+N0-1) = fft(x3(i:i+N0-1),N0);  %third stage FFT
end

P = P_cas(1);
N0 = N0_cas(1);

for k = 1:N/(N0*P)
    for i = 1:P 
        for j = 1:N0
            i + (j-1)*N/(N0) + (k-1)*P
            xFFT(j + (i-1)*N0 + (k-1)*N0*P) = xFFT3( i + (j-1)*N/(N0) + (k-1)*P);
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
