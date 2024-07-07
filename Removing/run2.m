clc
clear all
close all

% 1
fs = 500;
ecg_data = load('lead2.mat');
ecg_lead2 = ecg_data.lead2;
N = length(ecg_lead2);
time_length = N ./ fs;
tt = linspace(0,time_length,length(ecg_lead2));

figure
plot(tt, ecg_lead2)
xlabel('Time (s)')
ylabel('Voltage (mV)')
title('Original signal')

% 2
figure
X = fft(ecg_lead2);
plot(1:N/2 - 1,abs(X(2:N/2)))
title('Magnitude of Lead II')

% 4-1
theta = 2*pi*60/fs;
zeros = [exp(j*theta), exp(-j*theta)];
r = 0.97;
poles = [r*exp(j*theta), r*exp(-j*theta)];

% 4-2
bb = poly(zeros);
aa = poly(poles);

% 4-3
ww = linspace(0, 2*pi, N);
notch_filter = freqz(bb,aa,ww);
figure;
plot(ww./pi, abs(notch_filter)) % visualization of notch filter
title('Notch filter')

Y = notch_filter .* X;
y_filtered = ifft(Y);

% 4-4
figure
plot(tt, y_filtered)
xlabel('Time (s)')
ylabel('Voltage (mV)')
title('Filtered output')

figure
plot(1:N/2 - 1,abs(Y(2:N/2)))
title('Filtered Magnitude of Lead II')

% comparison btw original & different values of r for filtered
r = [0.99, 0.97, 0.95, 0.80];
m = tt >= 1 & tt <= 2;
legend_entries = cell(1, length(r));
figure;
plot(tt(m), ecg_lead2(m))
legend_entries{1} = 'Original signal';
hold on

for k = 1:length(r);
    r_index = r(k);
    poles = [r_index*exp(j*theta), r_index*exp(-j*theta)];
    aa = poly(poles);
    notch_filter = freqz(bb,aa,ww);
    Y = notch_filter .* X;
    y_filtered = ifft(Y);
    plot(tt(m), y_filtered(m))
    legend_entries{k+1} = ['r = ', num2str(r_index)];
end

legend(legend_entries)
xlabel('Time (s)')
ylabel('Voltage (mV)')
title('Comparison')

% r = 0.8 is too low of an r value, and alters the signal from the original
% best choice of r in this case is r = 0.97