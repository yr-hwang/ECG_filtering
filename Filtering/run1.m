clc
close all
clear all

% 1. Data acquisition

% a
ecg_lead = load('ecg_lead.txt');
fs = 500;
ecg_lead2 = ecg_lead(:,2)';

% b
time_length = length(ecg_lead2) ./ fs;
tt = linspace(0,time_length,length(ecg_lead2));

figure;
plot(tt, ecg_lead2)
title('Lead II')
xlabel('Time (sec)')
ylabel('mV')

% 2. Zero-padding

% a
k1 = tt>=1 & tt<=2;
ecg_test = ecg_lead2(k1);

% b
N = length(ecg_test);
h_no_zp = [ones(1,16)/16, zeros(1,N-16)]; % zeros added to ensure same length N
Hk_no_zp = fft(h_no_zp);
Xk_no_zp = fft(ecg_test);
Yk_no_zp = Xk_no_zp .* Hk_no_zp;
filtered_data_no_zp = ifft(Yk_no_zp);

% c
h_zp = ones(1,16)/16;
M = length(h_zp);
padded_length = 2^nextpow2(N + M - 1); % next power of 2 > N+M-1
Hk_zp = fft(h_zp, padded_length);
Xk_zp = fft(ecg_test, padded_length);
Yk_zp = Xk_zp .* Hk_zp;
filtered_data_zp_full = ifft(Yk_zp);
filtered_data_zp = filtered_data_zp_full(1:N+M-1);

% d
tt_no_zp = tt(k1);
tt_zp = tt(1:length(filtered_data_zp));

figure;
plot(0:N-1, filtered_data_no_zp)
hold on;
plot(0:N + M - 2, filtered_data_zp, '--')
legend('not padded', 'padded')
xlabel('Samples')
ylabel('mV')

% 3. Filtering in Frequency Domain

% a
figure;
k2 = tt >= 1 & tt <= 10;
ecg_test_10 = ecg_lead2(k2);
N = length(ecg_test_10);
Xk = fft(ecg_test_10);
plot(0:N/2 - 1, abs(Xk(1:N/2))) 
title('Magnitude of Lead II for 1~10 sec')
xlabel('Samples')
ylabel('Magnitude')

% b
w_lc = 50; % < fs/2 = 250 
t = linspace(1,10,N); 
f = (0:N-1)*(fs/N);
H_LPF = zeros(1,N);
H_LPF(f <= w_lc | f >= fs - w_lc) = 1; % passband
X = fft(ecg_test_10);
Y_LPF = X .* H_LPF;
y_filtered_LPF = ifft(Y_LPF);

figure;
subplot(4,1,1)
plot(t, ecg_test_10)
title('Original')
xlabel('Time (sec)')
ylabel('mV')
subplot(4,1,2)
plot(t, y_filtered_LPF)
title('LPF')
xlabel('Time (sec)')
ylabel('mV')

% c
w_hc = 2; % < w_lc
H_HPF = zeros(1,N);
H_HPF((f > w_hc) & (f < (fs - w_hc))) = 1; %  passband
Y_HPF = X .* H_HPF;
y_filtered_HPF = ifft(Y_HPF);
subplot(4,1,3)
plot(t, y_filtered_HPF);
title('HPF')
xlabel('Time (sec)')
ylabel('mV')

% d
H_BPF = H_LPF .* H_HPF;
Y_BPF = X .* H_BPF;
y_filtered_BPF = ifft(Y_BPF);
subplot(4,1,4)
plot(t, y_filtered_BPF);
title('BPF')
xlabel('Time (sec)')
ylabel('mV')