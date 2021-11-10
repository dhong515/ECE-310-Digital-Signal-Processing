%% Danny Hong, Arthur Skok, and Kenny Huang
%DSP Project 5: Spectral Estimation
clc
clear
close all

%% 
load pj2data

figure('name', 'y[n]');
plot(y);
axis([0 512 -5 5])
xlabel('n')
title('y[n]')
grid on

figure('name', 'Magnitude Squared Response');
plot(Hejw2);
axis([0 512 0 8])
xlabel('k')
ylabel('Magnitude')
title('Magnitude Squared Response')
grid on

%%
% Problem A.1
y_corr1 = y(1:32);
r = xcorr(y_corr1, 'biased');
figure('name', 'y1[n]');
plot(32 * r);
% Found the scaling factor to be approximately 32
r2 = conv(y_corr1, fliplr(y_corr1));
figure('name', 'autocorrelation of y1[n] using xcorr()');
plot(r2);

figure('name', 'autocorrelation using the conv() function');
r3 = xcorr(y_corr1, 'unbiased');
plot(r3);
% Since bias is the difference between an estimator's
% expected value and the true value being approximated,
% the unbiased autocorrelation assumes that difference
% to be 0 or the expected value of an estimator matches
% the expected value of the parameter being tested. 
% In practical terms, for variance, the unbiased estimator
% divides by N - |m|, rather than simply N as it would 
% for biased estimators.
% The difference is that the biased estimator has bounded
% variance at the end points of the sequence whereas 
% the unbiased estimater does not and suffers from larger
% variance.

%% Problem A.2
% DONT DO??? -> mentioned in teams a) Power is always >0 and real, and the fourier transform 
% of the autocorrelation function is the power spectral density 

% Deterministic Autocorrelation:

% a)
figure('name', 'A.2.A');
det_auto = (conv(y_corr1, flip(y_corr1)));
plot(abs(det_auto));
title('Magnitude for Deterministic Autocorrelation');
xlabel('Frequency');
ylabel('Amplitude');


% b) 

new_Y = fft(r, 64);
%z = fftshift(Y);
%lY = length(Y);
%f = (-lY/2:lY/2-1)/lY*fs;

m = abs(new_Y);
p = angle(new_Y);

figure('name', 'A.2.B');
subplot(2,2,1)
plot(m)
title('Absolute Value of Magnitude of cy1,y1')
xlabel('Frequency');
ylabel('Amplitude');

subplot(2,2,2)
plot(p)
title('Phase of of cy1,y1')
xlabel('Frequency');
ylabel('Phase');

dft_det_auto = fft(det_auto, 64);
p1 = angle(dft_det_auto);
subplot(2,2,3)
plot(abs(dft_det_auto));
title('Absolute Value of Magnitude Det Autocorrelation')
xlabel('Frequency');
ylabel('Amplitude');

subplot(2,2,4)
plot(p1);
title('Phase of DFT of Det Autocorrelation')
xlabel('Frequency');
ylabel('Phase');

% Amplitude seems to be a constant scalar of one another 
% (32, same length of dft), while phase is the same?

% c)

figure('name', 'A.2.C');
plot(m * 32);
title('Absolute Value of Magnitude of cy1,y1, scaled')
xlabel('Frequency');
ylabel('Amplitude');

%% Problem A.3
% a)

figure('name', 'A.3.A');
plot(abs(dft_det_auto))
title('Absolute Value of Magnitude of Det Autocorrelation')
xlabel('Frequency');
ylabel('Amplitude');

% b)

figure('name', 'A.3.B');
plot((abs(dft_det_auto)).^2);
title('Magnitude^2 of DFT for Deterministic Autocorrelation');
xlabel('Frequency');
ylabel('Amplitude');

% c)

figure('name', 'A.3.C');
% mag squared of 64-pt dft of the first 64 pts of y
dft_y_64 = fft(y(1:64),64).^2;
plot(abs(dft_y_64));
title('Magnitude^2 of DFT for first 64 points of Y');
xlabel('Frequency');
ylabel('Amplitude');

% I'd say that since the points wrap around for dft for C, it may
% also be the autocorrelation but with another scalar (and it is bad 
% at the boundaries).

%% Problem B.1

% The periodogram can be calculated directly from   without first 
% convolving it with itself: Take a 64-point DFT of ...
% and then find its magnitude squared. This will give you 
% a 64-point DFT representing ... 

% Hejw -> 512 pts, 512/64 = 8 = downsample rate
% Want to match:
He_downsampled = downsample(Hejw2, 8);
y_32 = y(1:32);
periodgram_64 = abs(fft((y_32),64)).^2;


figure('name', 'B.1')
plot(He_downsampled)
title('64 point PSD Estimates')
hold on
plot(periodgram_64)
hold off
%plot(Hejw2);
legend('Original', 'Estimate - 64');
xlabel('Values of k');
ylabel('Magnitude');

grid on

% Error estimate as provided by the assignment:
% results in 64 total points
errors_64_point = sum((periodgram_64-He_downsampled).^2)/64;
%% Problem B.2

% 1024/64 = 16 required for downsampling rate
% using all 512 points in y
periodgram_512 = downsample(abs(fft(y,1024)).^2, 16);
figure('name', 'B.2')
plot(He_downsampled)
title('512 point PSD Estimates')
hold on
plot(periodgram_512)
hold off
%plot(Hejw2)
legend('Original', 'Estimate - 512 ');
xlabel('Values of k');
ylabel('Magnitude');

errors_512_point = sum((periodgram_512-He_downsampled).^2)/64;

%% Problem B.3

% Periodogram Averaging

periodgram_average_64 = abs(period_average(y));

figure('name', 'B.3')
plot(He_downsampled)
title('Average of 64 point PSD Estimates');
hold on
plot(periodgram_average_64)
hold off
legend('Original', 'Estimate - 64 Point Averages ');
xlabel('Values of k');
ylabel('Magnitude');

error_64_point_average = sum((periodgram_average_64 - He_downsampled).^2)/64;

% This method uses averaging as opposed to the other 2 methods, and perhaps
% this will result in a lower variance and therefore in a lower error.

%% Problem B.4

% Blackman-Tukey method of PDS estimation
% Abs value less than 15 is used for autocorrelation estimate
y = y(1:512);
det_auto_full = conv(y, fliplr(y));
trunc_dft = abs(fft(det_auto_full(1:15),64));

figure('name', 'B.1')
plot(He_downsampled)
title('64 point PSD Estimates')
hold on
plot(trunc_dft)
hold off
%plot(Hejw2);
legend('Original', 'Estimate - 64');
xlabel('Values of k');
ylabel('Magnitude');

grid on

error_Blackman_Tukey = sum((trunc_dft - He_downsampled).^2)/64;
%% Problem B.5

T = table(errors_64_point, errors_512_point, error_64_point_average, error_Blackman_Tukey);

triang(15)
estimate_triang = abs(fft(det_auto_full(1:15) *triang(15), 64)).^2;
error_triang = sum((estimate_triang - He_downsampled).^2)/64;

% A.) It looked like the Blackman-Tukey method did the best. Averaging 64
% points did the second best. 

% B.) The Blackman-Tukey method did well in comparison to the other methods
% which used averaging because it used less samples of y and the variances for
% other methods were higher because it used more values of yn that may have
% higher variance. 

% C.) Barlett or Triangular Windows produce different (probably less accurate)
% results to the previous results as the previous schemes utilized
% rectangular windows, where the weights were normally distributed, while
% the triangular window has larger weighting towards the middle. 
