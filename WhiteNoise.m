% White noise for tracking 
% Inspired by Anran Wang
% Author: Fengyuan Zhu

%% Initialization
clear;
clc;
close all;
fs = 48e3; % Sampling rate: 48kHz
blockDuration = 0.2; % Each block lasts for 0.2 sec
blockSize = blockDuration*fs;
randomPhase = rand(1,0.5*blockSize);
phase = [randomPhase,fliplr(randomPhase)];

%% Create white noise
a = exp(1j*phase*2*pi);
a_t = real(ifft(a)); %Imaginary part is zero
a_t = a_t./max(a_t);
full_audio = repmat(a_t,1,30);

%% Play White Noise
sound(full_audio,fs,24);
audiowrite('fakeWhite.wav',full_audio,fs,'BitsPerSample',24,'Title','Fake White Noise','Artist','Fengyuan');

%% A real random white noise
b = 2*(rand(size(full_audio))-0.5);
sound(b,fs,24);
audiowrite('realWhite.wav',b,fs,'BitsPerSample',24,'Title','Random White Noise','Artist','Fengyuan');

%% Turn fake white noise to chirp
t = 0:1/fs:(blockSize-1)/fs;
chirpRate = 0.5*fs/(0.5*blockSize/fs);
chirp = cos(2*pi*(0.5*chirpRate*t.^2));
sound(chirp,fs,24);
ChirpPhase = angle(fft(chirp));

%%
rx = a_t;
rx_f = fft(a_t);
rec = rx_f.*exp(1j*-phase*2*pi).*exp(1j*ChirpPhase);
rec_t = real(ifft(rec));
sound(rec_t,fs,24);
audiowrite('RecChirp.wav',repmat(rec_t,1,30),fs,'BitsPerSample',24,'Title','Chirp','Artist','Fengyuan');