% Danny Hong, Arthur Skok, Kenny Huang 
% Project 1: Sampling Rate Conversion: Main Function

clc;
clear;
close all;

%Reads in the audio file 'Wagner.wav'
[signal_in, Fs] = audioread('Wagner.wav'); 

%Passing in the audio 'Wagner.wav' as the input signal to the function.
y1=srconvert(signal_in); 

%Plays the outputted audio signal with a target audio frequency of 24000 Hz
soundsc(y1, 24000); 

%Passing in the delta function as the input signal to the function.
y2 = srconvert([1 zeros(1, 3000)]);

%Checking if the outputted delta signal passes the verify function.
verify(y2);