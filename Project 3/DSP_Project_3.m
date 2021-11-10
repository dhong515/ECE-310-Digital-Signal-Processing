%% Danny Hong, Kenny Huang, Arthur Skok
% DSP Project 3: Filter Design
% Professor Keene

clc;
close;
clear all;

load('projIB.mat');

Fs = 44100; %Sampling Frequency 
Wp = 2500; %Passband Edge
Ws = 4000; %Stopband Edge
Rp = 3; %Deviation of Passband Ripple
Rs = 95; %Deviation of Stopband Ripple

%%soundsc(noisy, fs); %Playing the original 'noisy' audio. It sounds absolutely terrible.
%% Butterworth Filter

%Creating the butterworth filter. 
[n1, Wn_Butter] = buttord(Wp/(fs/2), Ws/(fs/2), Rp, Rs);
[z1, p1, k1] = butter(n1, Wn_Butter);
%Converting it to sos through zp2sos.
sos_Butter = zp2sos(z1, p1, k1);

figure;

%Taking the Magnitude Response and then Plotting It.
[h1, w1]=freqz(sos_Butter);
subplot(3, 1, 1)
plot(w1, 20*log10(abs(h1)))
title('Magnitute Response Plot for Butterworth Filter')

%Plotting the Magnitude Response with respect to the Passband Ripple
subplot(3, 1, 2)
plot(w1, 20*log10(abs(h1)))
xlim([0 Wp/(Fs/2)])
title('Magnitute Response Passband Ripple for Butterworth Filter')

%Computing and Plotting the Group Delay
[gd1, w1] = grpdelay(sos_Butter);
subplot(3, 1, 3)
plot(w1, gd1);
title('Group Delay Plot for Butterworth Filter')

figure();

%Taking the Impulse Response for 100 samples and then plotting it
[h1, t1] = impz(sos_Butter, 100);
subplot(2, 1, 1)
stem(t1, h1);
title("Impulse Response Plot for Butterworth filter (100 samples)");

%Plotting the Pole-Zero Plot
subplot(2, 1, 2)
zplane(z1, p1, k1);
title("Pole-Zero Plot for Butterworth filter");

%Using the Butterworth filter to de-noise the orinigal 'noise' file
sos_filter_Butter = dfilt.df2sos(sos_Butter);
filter_Butter = filter(sos_filter_Butter, noisy);

%soundsc(filter_Butter, fs); %Playing the de-noised audio: sounds much better than the original.

%% Chebyshev I Filter

%Creating the Chebyshev I Filter. 
[n2, Wn_Cheby1] = cheb1ord(Wp/(fs/2), Ws/(fs/2), Rp, Rs);
[z2, p2, k2] = cheby1(n2, Rp, Wn_Cheby1);
%Converting it to sos through zp2sos.
sos_Cheby1 = zp2sos(z2, p2, k2);

figure;

%Taking the Magnitude Response and then Plotting It.
[h2, w2] = freqz(sos_Cheby1);
subplot(3, 1, 1)
plot(w2, 20*log10(abs(h2)));
title('Magnitute Response for Chebyshev Filter Type 1')

%Plotting the Magnitude Response with respect to the Passband Ripple.
subplot(3, 1, 2)
plot(w2, 20*log10(abs(h2)));
xlim([0 Wp/(Fs/2)])
title('Magnitute Response Passband Ripple for Chebyshev Filter Type 1')

%Computing and Plotting the Group Delay
[gd2, w2] = grpdelay(sos_Cheby1);
subplot(3, 1, 3)
plot(w2, gd2);
title('Group Delay for Chebyshev Filter Type 1');

figure();

%Taking the Impulse Response for 100 samples and then plotting it
subplot(2, 1, 1)
[h2, t2] = impz(sos_Cheby1, 100);
stem(t2, h2);
title("Impulse Response Plot for Chebyshev Filter Type 2 (100 samples)")

%Plotting the Pole-Zero Plot
subplot(2, 1, 2)
zplane(z2, p2, k2);
title("Pole-Zero Plot Plot for Chebyshev Filter Type 2 (100 samples)")

%Using the Chebyshev I filter to de-noise the orinigal 'noise' file
sos_filter_Cheby1 = dfilt.df2sos(sos_Cheby1);
filter_Cheby1 = filter(sos_filter_Cheby1, noisy);

%soundsc(filter_Cheby1, fs); %Playing the de-noised audio: Sounds much better than the original

%% Chebyshev 2 Filter

%Creating the Chebyshev 2 Filter. 
[n3, Wn_Cheby2] = cheb2ord(Wp/(fs/2), Ws/(fs/2), Rp, Rs);
[z3, p3, k3] = cheby2(n3, Rs, Wn_Cheby2);
%Converting it to sos through zp2sos.
sos_Cheby2 = zp2sos(z3, p3, k3);

figure;

%Taking the Magnitude Response and then Plotting It.
[h3, w3] = freqz(sos_Cheby2);
subplot(3, 1, 1)
plot(w3, 20*log10(abs(h3)));
title('Magnitute Response for Chebyshev Filter Type 2')

%Plotting the Magnitude Response with respect to the Passband Ripple.
subplot(3, 1, 2)
plot(w3, 20*log10(abs(h3)));
xlim([0 Wp/(Fs/2)])
title('Magnitute Response Passband Ripple for Chebyshev Filter Type 2')

%Computing and Plotting the Group Delay
[gd3, w3] = grpdelay(sos_Cheby2);
subplot(3, 1, 3)
plot(w3, gd3);
title('Group Delay for Chebyshev Filter Type 2');

figure();

%Taking the Impulse Response for 100 samples and then plotting it
subplot(2, 1, 1)
[h3, t3] = impz(sos_Cheby2, 100);
stem(t3, h3);
title("Impulse Response Plot for Chebyshev Filter Type 2 (100 samples)")

%Plotting the Pole-Zero Plot
subplot(2, 1, 2)
zplane(z3, p3, k3);
title("Pole-Zero Plot for Chebyshev Filter Type 2 (100 samples)")

%Using the Chebyshev 2 filter to de-noise the orinigal 'noise' file
sos_filter_Cheby2 = dfilt.df2sos(sos_Cheby2);
filter_Cheby2 = filter(sos_filter_Cheby2, noisy);

%soundsc(filter_Cheby2, fs); %Playing the de-noised audio: Sounds much better than the original

%% Elliptic Filter

%Creating the Elliptic Filter. 
[n4, Wp_Ellip] = ellipord(Wp/(fs/2), Ws/(fs/2), Rp, Rs);
[z4, p4, k4] = ellip(n4, Rp, Rs, Wp_Ellip);
%Converting it to sos through zp2sos.
sos_Ellip = zp2sos(z4, p4, k4);

%Taking the Magnitude Response and then Plotting It.
[h4, w4] = freqz(sos_Ellip);
subplot(3, 1, 1)
plot(w4, 20*log10(abs(h4)));
title('Magnitute Response for Elliptic Filter')

%Plotting the Magnitude Response with respect to the Passband Ripple.
subplot(3, 1, 2)
plot(w4, 20*log10(abs(h4)));
xlim([0 Wp/(Fs/2)])
title('Magnitute Response Passband Ripple for Elliptic Filter')

%Computing and Plotting the Group Delay
[gd4, w4] = grpdelay(sos_Ellip);
subplot(3, 1, 3)
plot(w4, gd4);
title('Group Delay for Elliptic Filter');

figure();

%Taking the Impulse Response for 100 samples and then plotting it
subplot(2, 1, 1)
[h4, t4] = impz(sos_Ellip, 100);
stem(t4, h4);
title("Impulse Response Plot for Elliptic Filter (100 samples)")

%Plotting the Pole-Zero Plot
subplot(2, 1, 2)
zplane(z4, p4, k4);
title("Pole-Zero Plot for Elliptic Filter (100 samples)")

%Using the Elliptic filter to de-noise the orinigal 'noise' file
sos_filter_Ellip = dfilt.df2sos(sos_Ellip);
filter_Ellip = filter(sos_filter_Ellip, noisy);

%soundsc(filter_Ellip, fs); %Playing the de-noised audio: Sounds much better than the original

%% Converting Ripple to Linear Units

% Converting the ripple to linear units in order to be used for IIR specs.
linear_Rs = (2 * 10^(-Rs/20))/(2 - (1 - 10^(-Rp/20)));
linear_Rp = (1 - 10^(-Rp/20))/(2 - (1 - 10^(-Rp/20)));

f = [Wp/(fs/2) Ws/(fs/2)];
a = [1 0];

%% Parks-McClellan Filter

%Creating the Parks-McClellan Filter. 
[n, fo, ao, w5] = firpmord(f, a, [linear_Rp linear_Rs]);
filter_PM = firpm(n + 6, fo, ao, w5);

%Taking the Magnitude Response and then Plotting It.
[h5, w5] = freqz(filter_PM);
subplot(3, 1, 1)
plot(w5, 20*log10(abs(h5)));
title('Magnitute Response for Parks-McClellan Filter')

%Plotting the Magnitude Response with respect to the Passband Ripple.
subplot(3, 1, 2)
plot(w5, 20*log10(abs(h5)));
xlim([0 Wp/(Fs/2)])
title('Magnitute Response Passband Ripple for Parks-McClellan Filter')

%Computing and Plotting the Group Delay
[gd5, w5] = grpdelay(filter_PM);
subplot(3, 1, 3)
plot(w5, gd5);
title('Group Delay for Parks-McClellan Filter');

figure();

%Taking the Impulse Response for 100 samples and then plotting it
subplot(2, 1, 1)
[h5, t5] = impz(filter_PM, 100);
stem(t5, h5);
title("Impulse Response Plot for Parks-McClellan Filter (100 samples)")

%Plotting the Pole-Zero Plot
subplot(2, 1, 2)
zplane(filter_PM);
title("Pole-Zero Plot for Parks-McClellan Filter (100 samples)")

%Using the Parks-McClellan filter to de-noise the orinigal 'noise' file by taking the convolution
filtered_PM = conv(filter_PM, noisy);

%soundsc(filtered_PM, fs); %Playing the de-noised audio: Sounds much better than the original

%% Kaiser Filter

%Creating the Kaiser Filter. 
[n6, Wn_Kaiser, beta, ftype] = kaiserord(f, a, [linear_Rp linear_Rs]);
filter_Kaiser = fir1(n6, Wn_Kaiser, ftype, kaiser(n6 + 1, beta), 'noscale');

%Taking the Magnitude Response and then Plotting It.
[h6, w6] = freqz(filter_Kaiser);
subplot(3, 1, 1)
plot(w6, 20*log10(abs(h6)));
title('Magnitute Response for Kaiser Filter')

%Plotting the Magnitude Response with respect to the Passband Ripple.
subplot(3, 1, 2)
plot(w6, 20*log10(abs(h6)));
xlim([0 Wp/(Fs/2)])
title('Magnitute Response Passband Ripple for Kaiser Filter')

%Computing and Plotting the Group Delay
[gd6, w6] = grpdelay(filter_Kaiser);
subplot(3, 1, 3)
plot(w6, gd6);
title('Group Delay for Kaiser Filter');

figure();

%Taking the Impulse Response for 100 samples and then plotting it
subplot(2, 1, 1)
[h5, t5] = impz(filter_Kaiser, 100);
stem(t5, h5);
title("Impulse Response Plot for Kaiser Filter (100 samples)")

%Plotting the Pole-Zero Plot
subplot(2, 1, 2)
zplane(filter_Kaiser);
title("Pole-Zero Plot for Kaiser Filter (100 samples)")

%Using the Kaiser filter to de-noise the orinigal 'noise' file by taking the convolution
filtered_Kaiser = conv(filter_Kaiser, noisy);

%soundsc(filtered_Kaiser, fs); %Playing the de-noised audio: Sounds much better than the original
