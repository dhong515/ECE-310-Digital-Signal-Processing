%% Danny Hong, Kenny Huang, Arthur Skok
% DSP Project 2: All-pass filters and filter structures
% Professor Keene

clc;
clear all;
close all;
load ('projIA');

% Original speech (uncomment to listen)
%soundsc(speech,fs);

%------------------------------ PART A -----------------------------------%
% Using impz to find the impulse response of the filter
[h,t] = impz(b,a); 

% Plotting the Frequency Response (using freqz) with n-point = 100
figure('Name','Frequency Response');
freqz(b,a,100);
title("Plot of the Frequency Response");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');

% Plotting the Impulse Response (using impz) of the first 100 samples for N = 1
figure('Name','Impulse Response, Group Delay, and Pole-Zero Plot');
subplot(2,2,1)
impz(b,a,100);
title("Plot of the Impulse Response");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;

% Plotting the Group Delay (using grpdelay) with n-point = 100
subplot(2,2,2);
grpdelay(b,a,100);
title("Plot of the Group Delay");

%------------------------------ PART B -----------------------------------%
% Plotting the pole-zero diagram (using zplane) for N = 1 of the filter 
subplot(2,2,[3 4]);
zplane(b,a);
title("Plot of the Pole-Zero Diagram");
grid on;

%------------------------------ PART C -----------------------------------%
% Processing speech file by using filter function to run the filter in part a 
result = filter(b,a,speech);

%soundsc(result, 11025);
% The result is played (uncomment to play audio) and sounds qualitatively
% great (very much like the original audio) as it has very minimal audible distortion.

%---------------------------- PARTs D + E --------------------------------%
%% DIRECT FORM 1 MACHINE PRECISION

% Implements a Direct Form I (using machine precision) filter using Matlabs dfilt objects.
hd = dfilt.df1(b,a);

% Cascades the filter for machine precision.
cascaded_df1 = dfilt.cascade(repmat(hd,50,1));

% Plotting the Frequency Response of this Direct Form 1 Filter.
freqz(cascaded_df1,5000);
title("Plot of the Frequency Response for Cascaded Direct Form 1");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');

% Plotting the Impulse Response of this Direct Form 1 Filter.
impz(cascaded_df1,5000);
title("Plot of the Impulse Response for Cascaded Direct Form 1");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;

% Plotting the Group Delay of this Direct Form 1 Filter.
grpdelay(cascaded_df1,5000);
title("Plot of the Group Delay for Cascaded Direct Form 1");

% Plotting the Pole-Zero Diagram of this Direct Form 1 Filter.
zplane(cascaded_df1);
title("Plot of the Pole-Zero Diagram for Cascaded Direct Form 1");
grid on;

% Using filter function to process the speech.
cascaded_df1_speech = filter(cascaded_df1,speech);

%soundsc(cascaded_df1_speech,fs);
% Upon playing the audio (uncomment to play) there is clear noise
% distortion that exists. However, the audio can still be heard, just not clearly. 
% (Wavy and pings added to the original words)

%% DIRECT FORM I SOS MACHINE PRECISION

% Implements a Direct Form I SOS (using machine precision) filter using Matlabs dfilt objects.
hd_sos = sos(hd);

% Cascades the filter for machine precision.
cascaded_df1_sos = dfilt.cascade(repmat(hd_sos,50,1));

% Plotting the Frequency Response of this Direct Form 1 SOS Filter.
freqz(cascaded_df1_sos,5000);
title("Plot of the Frequency Response for Cascaded Direct Form 1 SOS");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');

% Plotting the Impulse Response of this Direct Form 1 SOS Filter.
impz(cascaded_df1_sos,5000);
title("Plot of the Impulse Response for Cascaded Direct Form 1 SOS");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;

% Plotting the Group Delay of this Direct Form 1 SOS Filter.
grpdelay(cascaded_df1_sos,5000);
title("Plot of the Group Delay for Cascaded Direct Form 1 SOS");

% Plotting the Pole-Zero Diagram of this Direct Form 1 SOS Filter.
zplane(cascaded_df1_sos);
title("Plot of the Pole-Zero Diagram for Cascaded Direct Form 1 SOS");
grid on;

% Using filter function to process the speech.
cascaded_df1_sos_speech = filter(cascaded_df1_sos,speech);

%soundsc(cascaded_df1_sos_speech,fs);
% Uncomment to play the audio. The audio is quite similar, if not the same
% as the previous implementation.

%% DIRECT FORM 1 ALTERNATIVE

% Declaring secondary a and b values in order for foiling to occur later. 
alternate_a = a;
alternate_b = b;

% In using the alternate method for Direct Form 1 Filtering, machine
% precision is not utilized and so the filter will not be cascaded. Instead
% the numerators and denominators of the Impulse Response will be foiled
% which will be done through the following for loop. Additionally, the conv
% function (convolution) represents the multiplication of two polynomials.
for N = 1:50
     alternate_a = conv(alternate_a, a);
     alternate_b = conv(alternate_b, b);
end

% Creates the alternate Direct Form 1 filter using dfilt.
alternate_df1 = dfilt.df1(alternate_b, alternate_a);

% Plotting the Frequency Response of this Direct Form 1 Filter.
freqz(alternate_df1,5000);
title("Plot of the Frequency Response for Alternative Direct Form 1");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');
 
% Plotting the Impulse Response of this Direct Form 1 Filter.
impz(alternate_df1,5000);
title("Plot of the Impulse Response for Alternative Direct Form 1");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;
 
% Plotting the Group Delay of this Direct Form 1 Filter.
grpdelay(alternate_df1,5000);
title('Direct Form 1 Alternative Group Delay');

% Plotting the Pole-Zero Diagram of this Direct Form 1 Filter.
zplane(alternate_df1);
title("Direct Form 1 Alternative Pole-Zero Diagram");
grid on;
 
% Using filter function to process the speech.
alternate_df1_speech = filter(alternate_df1,speech);
 
soundsc(alternate_df1_speech,fs);
% Uncomment to play audio. The result sounds qualitatively awful. 
% This is because the audio is inaudible since nothing can be heard. 

%% DIRECT FORM I SOS ALTERNATIVE
% 
% Implements a Direct Form 1 SOS Filter using the alternate method.
alternate_df1_sos = sos(alternate_df1);

% Plotting the Frequency Response of this Direct Form 1 SOS Filter.
freqz(alternate_df1_sos,5000);
title("Plot of the Frequency Response for Alternative Direct Form 1 SOS");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');

% Plotting the Impulse Response of this Direct Form 1 SOS Filter.
impz(alternate_df1_sos,5000);
title("Plot of the Impulse Response for Alternative Direct Form 1 SOS");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;

% Plotting the Group Delay of this Direct Form 1 SOS Filter.
grpdelay(alternate_df1_sos,5000);
title("Plot of the Group Delay for Alternative Direct Form 1 SOS");

% Plotting the Pole-Zero Diagram of this Direct Form 1 SOS Filter.
zplane(alternate_df1_sos);
title("Plot of the Pole-Zero Diagram for Alternative Direct Form 1 SOS");
grid on;

% Using filter function to process the speech.
alternate_df1_sos_speech = filter(alternate_df1_sos,speech);

soundsc(alternate_df1_sos_speech,fs);
% Uncomment to play the audio. The result is qualitatively awful since the
% audio is inaudible and cannot be heard.

%% DIRECT FORM 2 SOS MACHINE PRECISION

% Implements a Direct Form 2 (using machine precision) filter using Matlabs dfilt objects.
hd2 = dfilt.df2(b,a);
hd2_sos = sos(hd2);

% Cascades the filter for machine precision.
cascaded_df2_sos = dfilt.cascade(repmat(hd2_sos, 50, 1));

% Plotting the Frequency Response of this Direct Form 2 SOS Filter.
freqz(cascaded_df2_sos,5000);
title("Plot of the Frequency Response for Cascaded Direct Form 2 SOS");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');

% Plotting the Impulse Response of this Direct Form 2 SOS Filter.
impz(cascaded_df2_sos,5000);
title("Plot of the Impulse Response for Cascaded Direct Form 2 SOS");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;

% Plotting the Group Delay of this Direct Form 2 SOS Filter.
grpdelay(cascaded_df2_sos,5000);
title("Plot of the Group Delay for Cascaded Direct Form 2 SOS");

% Plotting the Pole-Zero Diagram of this Direct Form 2 SOS Filter.
zplane(cascaded_df2_sos);
title("Plot of the Pole-Zero Diagram for Cascaded Direct Form 2 SOS");
grid on;

% Using filter function to process the speech.
cascaded_df2_sos_speech = filter(cascaded_df2_sos,speech);

%soundsc(cascaded_df2_sos_speech,fs);
% Uncomment to play the audio. The audio is, basically the same in terms of
% distortion as the previous implementations.

%% DIRECT FORM 2 SOS ALTERNATIVE

% Implements a Direct Form 2 SOS Filter using the alternate method.
alternate_df2 = dfilt.df2(alternate_a, alternate_b);
alternate_df2_sos = sos(alternate_df2);
 
% Plotting the Frequency Response of this Direct Form 2 SOS Filter.
freqz(alternate_df2_sos,5000);
title("Plot of the Frequency Response for Alternative Direct Form 2 SOS");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');
 
% Plotting the Impulse Response of this Direct Form 2 SOS Filter.
impz(alternate_df2_sos,5000);
title("Plot of the Impulse Response for Alternative Direct Form 2 SOS");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;
 
% Plotting the Group Delay of this Direct Form 2 SOS Filter.
grpdelay(alternate_df2_sos,5000);
title("Plot of the Group Delay for Alternative Direct Form 2 SOS");
 
% Plotting the Pole-Zero Diagram of this Direct Form 2 SOS Filter.
zplane(alternate_df2_sos);
title("Plot of the Pole-Zero Diagram for Alternative Direct Form 2 SOS");
grid on;
 
% Using filter function to process the speech.
alternate_df2_sos_speech = filter(alternate_df2_sos,speech);
 
%soundsc(alternate_df2_sos_speech,fs);
% Uncomment to play the audio. The result is qualitatively awful as it is
% inaudible and cannot be heard. 

%% TRANSPOSED DIRECT FORM 2 SOS MACHINE PRECISION

% Uses Matlab built in tf2sos function to transpose the Direct Form 2 SOS Filter
[sos,g] = tf2sos(b,a);

% Implements the transposed Direct Form 2 SOS filter using Matlab's dfilt objects 
transposed_hd2_sos = dfilt.df2tsos(sos,g);

% Cascades the filter for Machine Precision
cascaded_transposed_hd2_sos = dfilt.cascade(repmat(transposed_hd2_sos,50,1));

% Plotting the Frequency Response of the Transposed Direct Form 2 SOS Filter.
freqz(cascaded_transposed_hd2_sos,5000);
title("Plot of the Frequency Response for Transposed Cascaded Direct Form 2 SOS");
xlabel('Number of Samples (n)');
ylabel('Frequency (Hz)');

% Plotting the Impulse Response of this Direct Form 2 SOS Filter.
impz(cascaded_transposed_hd2_sos,5000);
title("Plot of the Impulse Response for Transposed Cascaded Direct Form 2 SOS");
xlabel('Number of Samples (n)');
ylabel('Amplitude');
grid on;

% Plotting the Group Delay of this Direct Form 2 SOS Filter.
grpdelay(cascaded_transposed_hd2_sos,5000);
title("Plot of the Group Delay for Transposed Cascaded Direct Form 2 SOS");

% Plotting the Pole-Zero Diagram of this Direct Form 2 SOS Filter.
zplane(cascaded_transposed_hd2_sos);
title("Plot of the Pole-Zero Diagram for Transposed Cascaded Direct Form 2 SOS");
grid on;

% Using filter function to process the speech.
cascaded_transposed_hd2_sos_speech = filter(cascaded_transposed_hd2_sos,speech);

%soundsc(cascaded_transposed_hd2_sos_speech,fs);
% Uncomment to play the audio. Similar audio distortion to the previous 3
% methods is present.

%% PART E ANALYSIS
%The audio seems to have little to no difference between all 4 methods
%being used, whether it be Direct form 1, Direct form 1 of a second order
%system, Direct form 2 of a second order system, or Direct form 2 of a
%transposed second order system. 

%Here we are testing the plausibility of a common "folk theorem", which
%states that the (human) ear is insensitive to phase in waves, which
%implies that phase distortion is inaudibile. However, regardless of
%implementation of the all-pass filter being used to pass the given audio
%through, it seems that distortion is present (and rather similarly between
%the four forms) in comparison to the original audio sample. 

%Since as all-pass filters should theoretically pass all frequencies present
%in a signal equally in gain, the distortion evident in the signal should 
%be attributed to phase, as all-pass filters DO change the phase relationship 
%present between frequencies in a signal. Therefore, since the human ear
%(which is being used to test the differences in audio output), detects
%distortions in the signal being passed through these all-pass filters,
%this common form of folk's theorem does not seem to hold water. 

%The alternative methods used produced audio that was inaudible 
%(as in not only could distortion not be heard, but quite
%literally nothing at all). This is because of the convolution operation
%applying itself 50 times to the polynomials of the system is beyond
%MATLAB's capabilitites to perform precisely due to the limits of the
%software. (Precision is too low to perform this operation that many times
%accurately).