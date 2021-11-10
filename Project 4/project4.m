%Danny Hong, Arthur Skok, and Kenny Huang
%DSP Project 4: Spectogram Analysis and Applications

clc
clear
close all

%% 1.)

fs = 5*10^6; %Sampling Frequency
u = 4*10^9; %Chirp Rate
tLimit = 200*10^-6; %Chirp lasts 200 microseconds
t = 0:(1/fs):tLimit; %Declaring time vector 
x = cos(2*pi*u*(t.^2)); %x(t) function

%Generates a spectogram for Xn(w) using 256-point FFT?s, a 256-point triangular 
%window and an overlap of 255 samples between sections
figure;
spectrogram(x, triang(256), 255, 256, fs, "yaxis") 
title("Spectogram for X_n(\omega) for \mu = 4 x 10^{9}");

%% 2.)

f1 = u*t; %f1(x) function definition
derivative = 4*pi*u*t; %Taking the time derivative of the phase of x(t): 2*pi*u*(t.^2)
f2 = (1/(2*pi))*derivative; %f2(x) function definition

%Plotting f1(t) with respect to time
figure;
subplot(1, 2, 1);
plot(t, f1);
title("Instantaneous Frequency plot for f_1(t)");
xlabel("time (t)");
ylabel("f_1(t)");

%Plotting f2(t) with respect to time
subplot(1, 2, 2);
plot(t, f2);
title("Instantaneous Frequency plot for f_2(t)");
xlabel("time (t)");
ylabel("f_2(t)");

%The instantaneous frequency formula provided by f2(t) corresponds to 
%the ridge slope of the spectogram. 

%% 3.)

fs = 5*10^6; %Sampling Frequency
u = 1*10^10; %Chirp Rate
tLimit = 200*10^-6; %Chirp lasts 200 microsecond
t = 0:(1/fs):tLimit; %Declaring time vector
x = cos(2*pi*u*(t.^2)); %x(t) function

%Generates a spectogram for Xn(w) using 256-point FFT?s, a 256-point triangular 
%window and an overlap of 255 samples between sections
figure;
spectrogram(x, triang(256), 255, 256, fs, "yaxis")
title("Spectogram for X_n(\omega) for \mu = 1 x 10^{10}");

%At first, the slope of this spectogram is greater than the slope of the
%previous spectogram. However, this spectogram then shows the slope flattening and 
%attaining a negative value as the frequency starts to decrease. 

%% 4.)

%Loading in s1 and s5 speech files
load s1.mat 
load s5.mat 

fs = 8*10^3; %Sampling Frequency for Questions 4-7

%Generates a spectogram for s1 using 512-point FFT?s, a 512-point triangular 
%window and an overlap of 511 samples between sections
figure;
subplot(1, 2, 1);
spectrogram(s1, triang(512), 511, 512, fs, 'yaxis')
title("Spectogram for s1 speech file");

%Generates a spectogram for s5 using 1024-point FFT?s, a 1024-point triangular 
%window and an overlap of 1023 samples between sections
subplot(1, 2, 2);
spectrogram(s5, triang(1024), 1023, 1024, fs, 'yaxis')
title("Spectogram for s5 speech file");

%After some guessing and checking, we determined that using 512-point FFT?s, a 512-point 
%triangular window and an overlap of 511 samples between sections are sufficient parameters for 
%generating a narrowband spectogram for s1. Likewise, we determined that using 1024-point
%FFT's, a 1024-point triangular window, and an overlap of 1023 samples
%between sections are sufficient parameters for generating a narrowband
%spectogram for s5. These respective parameter values are the best for helping us
%observe the fundamental frequencies for both s1 and s5. Other powers of 2
%we experimented with were: 128, 256, and 2048.
%% 5.)

fs = 8*10^3; %Sampling Frequency for Questions 4-7

%Generates a spectogram for s1 using 64-point FFT?s, a 64-point triangular 
%window and an overlap of 63 samples between sections
figure;
subplot(1, 2, 1);
spectrogram(s1, triang(64), 63, 64, fs, 'yaxis')
title("Spectogram for s1 speech file");

%Generates a spectogram for s5 using 128-point FFT?s, a 128-point triangular 
%window and an overlap of 127 samples between sections
subplot(1, 2, 2);
spectrogram(s5, triang(128), 127, 128, fs, 'yaxis')
title("Spectogram for s5 speech file");

%After some guessing and checking, we determined that using 64-point FFT?s, a 64-point 
%triangular window and an overlap of 63 samples between sections are sufficient parameters for 
%generating a wideband spectogram for s1. Likewise, we determined that using 128-point
%FFT's, a 128-point triangular window, and an overlap of 127 samples
%between sections are sufficient parameters for generating a wideband
%spectogram for s5. These respective parameter values are the best for helping us
%observe the formant frequencies for both s1 and s5. Other powers of 2
%we experimented with were: 32, 256, and 512.

%In general we noticed that relatively lower powers of 2 help generate good
%wideband spectograms while relatively higher powers of 2 help generate
%good narrowband spectograms. 
%% 6.)

%Loading in vowels speech file
load vowels.mat

fs = 8*10^3; %Sampling Frequency for Questions 4-7

%Plotting 'Vowels' Signal 
figure;
subplot(1, 2, 1);
plot(vowels);
title("Input Signal Plot for 'Vowels' ");
xlabel("Number of Samples");
ylabel("Signal");

%Generates a spectogram for 'vowels' using 1024-point FFT?s, a 256-point rectangular 
%window and an overlap of 128 samples between sections with a sampling frequency of 8 kHz.
s = spectrogram(vowels, rectwin(256), 128, 1024, fs, 'yaxis');

%Returns the estimated signal from a modified STFT by passing the signal from the
%spectogram along with n = 1024 into our estimate function.
signalEstimate = estimate(1024, s);

%Plotting the output estimated signal plot for 'Vowels' 
subplot(1, 2, 2);
plot(signalEstimate);
title("Output Estimated Signal Plot for 'Vowels' ");
xlabel("Number of Samples");
ylabel("Signal");

%Estimate worked well since the two signals looked very alike.
%% 7.) 

%Loading in vowels speech file
load vowels.mat

fs = 8*10^3; %Sampling Frequency for Questions 4-7

%Compressing the time scale for vowels by a factor of 2
vowelsCompressed = vowels(1:2:numel(vowels));

%Generates a spectogram for 'vowels' using 1024-point FFT?s, a 256-point rectangular 
%window and an overlap of 128 samples between sections with a sampling frequency of 8 kHz.
s = spectrogram(vowelsCompressed, rectwin(256), 128, 1024, fs, 'yaxis'); 

%Returns the estimated signal from a modified STFT by passing the signal from the
%spectogram along with n = 1024 into our estimate function.
signalEstimate = estimate(1024, s);

%Plotting 'Vowels' Signal 
figure;
subplot(1, 2, 1);
plot(vowels);
title("Input Signal Plot for 'Vowels'");
xlabel("Number of Samples");
ylabel("Signal");

%Plotting the output estimated signal plot for 'Vowels' after compressing its time axis by 2
subplot(1, 2, 2);
plot(signalEstimate);
title("Output Estimated Signal Plot for Compressed 'Vowels' by 2");
xlabel("Number of Samples");
ylabel("Signal");

%%soundsc(vowels);
%%soundsc(signalEstimate);

%After playing the 2 signals we can verify that our processing is working well since the audio from 
%signalEstimate sounds as if the audio from vowels is sped up, which is expected after altering the rate.