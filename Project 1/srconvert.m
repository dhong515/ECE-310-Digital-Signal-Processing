% Danny Hong, Arthur Skok, Kenny Huang 
% Project 1: Sampling Rate Conversion: Multi-Stage Polyphased System

function out = srconvert(in)
tic 

%Declaring the num_mults and num_adds that represents the number of
%multiplications and additions. They will be used later when the values are
%to be reported. 
num_mults = 0;
num_adds = 0;

% Passband Cutoff (1/L) for the first Cheby2 filter with the upsample factor L = 10. 
Wp1 = 1/10;
% Stopband Frequency (1.2*Passband Cutoff) for the first Cheby2 filter.
Ws1 = 1.2*Wp1;
% Passband Ripple (dB) for the first Cheby2 filter. 
Rp1 = 0.1;
% Stopband Attenuation (dB) for the first Cheby2 filter. 
Rs1 = 81.4;

%Passband Ripple and Stop band Attenuation were adjusted within the constraits to
%ensure the filters and polyphase implementation passed the verify function
%provided for the assignment.

%Creating the first Cheby2 filter 
[n1,Wn1] = cheb2ord(Wp1,Ws1,Rp1,Rs1);
[b1,a1] = cheby2(n1,Rs1,Wn1);
[h1,t1] = impz(b1,a1);
freqz(b1,a1);

% Passband Cutoff (1/L) for the second Cheby2 filter with the upsample factor L = 8. 
Wp2 = 1/8;
% Stopband Frequency (1.2*Passband Cutoff) for the second Cheby2 filter.
Ws2 = 1.2*Wp2;
% Passband Ripple (dB) for the second Cheby2 filter. 
Rp2 = 0.09;
% Stopband Attenuation (dB) for the second Cheby2 filter. 
Rs2 = 80.3;

%Creating the second Cheby2 filter 
[n2,Wn2] = cheb2ord(Wp2,Ws2,Rp2,Rs2);
[b2,a2] = cheby2(n2,Rs2,Wn2);
[h2,t2] = impz(b2,a2);
freqz(b2,a2);

% Passband Cutoff (1/L) for the third Cheby2 filter with the upsample factor L = 4. 
Wp3 = 1/4;
% Stopband Frequency (1.2*Passband Cutoff) for the third Cheby2 filter.
Ws3 = 1.2*Wp2;
% Passband Ripple (dB) for the third Cheby2 filter. 
Rp3 = 0.08;
% Stopband Attenuation (dB) for the third Cheby2 filter. 
Rs3 = 94.3;

%Creating the third Cheby2 filter 
[n3,Wn3] = cheb2ord(Wp3,Ws3,Rp3,Rs3);
[b3,a3] = cheby2(n3,Rs3,Wn3);
[h3,t3] = impz(b3,a3);
freqz(b3,a3);

%Using poly1 to decompose each Cheby2 filter into polyphase filters for each interpolation stage
polyFilter10 = poly1(h1',10);
polyFilter8 = poly1(h2',8);
polyFilter4 = poly1(h3',4);

%Initialize each stage output as an array of zeros.
stage1 = zeros();
stage2 = zeros();
stage3 = zeros();

%We split our polyphase implementation into 3 stages, with upsamplings by
%10, 8, and 4, after experimenting with a 4 stage implementation of  5, 4,
%4 ,4 which did not pass one of the graphs for verification even after a
%lot of trial and error. (Though,it was through using a rather similar 
%implementation).

for i = 1:10
    signal_in = conv(polyFilter10(i,:), in);
    signal_in = upsample(signal_in, 10);
    signal_in = circshift(signal_in, i-1);
    stage1 = stage1 + signal_in;
end

%We used the formula from the textbook and the length of the filters to
%come up with the number of multiplies and additions per unit time for our
%implementation.
num_mults = num_mults + (10*(length(h1)/10));
num_adds = num_adds + ((10-1)+(10*((length(h1)/10)-1)));
%%stage1 = 7*downsample(stage1, 7);

%Initially we attempted to downsample between stages by 7, 7 and 3 respectively for the 3 stages; 
%however, the verify function gave terrible results for the passband response ripple. We experimented 
%and instead downsampled after all the polyphase components (which is a bit
%counterintuitive, but the results were better in terms of the verify function.

for i = 1:8
    signal_in = conv(polyFilter8(i,:), stage1);
    signal_in = upsample(signal_in, 8);
    signal_in = circshift(signal_in, i-1);
    stage2 = stage2 + signal_in;
end

num_mults = num_mults + (8*(length(h2)/8));
num_adds = num_adds + ((8-1)+(8*((length(h2)/8)-1)));
%%stage2 = 7*downsample(stage2, 7);

for i = 1:4
    signal_in = conv(polyFilter4(i,:), stage2);
    signal_in = upsample(signal_in, 4);
    signal_in = circshift(signal_in, i-1);
    stage3 = stage3 + signal_in;
end

num_mults = num_mults + (4*(length(h3)/4));
num_adds = num_adds + ((4-1)+(4*((length(h3)/4)-1)));
%%stage3 = 3*downsample(stage3, 3);

fprintf('Total number of multiplies: %d\n', num_mults); 
fprintf('Total number of adds: %d\n', num_adds); 

signal_out = 147*downsample(stage3, 147);
%As mentioned in one of the previous comments, we initially tried to
%downsample between stages, but the verify function would give terrible
%results.

%signal_out = stage3; If we were to downsample after each stage, stage3 would be the ouput 

toc
out = signal_out; %Sets the output of the function to signal_out
%% Comments and writeup

% srconvert.m function uses a multi-staged polyphased system.
% The upsample factor of 320 was broken up into 10, 8, and 4.
% The delta function passed the constraints for srconvert after testing it using verify.
% The ouputted audio file 'Wagner.wav' sounds nice.
% The total number of multiplies is 1652 and the total number of additions is 1649.

%As said before, we tried to downsample immediately after each
%interpolation stage by factors of 7, 7, and 3 (7*7*3 = 147), but our
%outputted Wagner file sounded pretty bad and out results after testing it on 
%the delta function showed that it did not pass completel pass verify since
%for the Passband response, the passband ripple exceeded 100 dB. Therefore,
%we decided to downsample in the very end by 147. We're not sure if this
%was acceptable, but the results were much better after doing this. 

%After publishing out srconvert.m we got an error at line 79: not enough
%input arguments, which is weird since the code compiled successfully when
%we ran it on our main.m. 
