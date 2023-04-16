%% Variables
clear all
clc
close all

p = 8; % number of poles in quarter symmetry
data3d = xlsread("fpp3d.csv");
data2d = xlsread("fpp2d.csv");
If = unique(data2d(:,1));
        % Flux values at different field currents
Flux_100 = data3d(1,2:end);
Flux_200 = data3d(2,2:end);
Flux_300 = data3d(3,2:end);
Flux_400 = data3d(4,2:end);
Flux_450 = data3d(5,2:end);
Flux_475 = data3d(6,2:end);
Flux_500 = data3d(7,2:end);
Flux_525 = data3d(8,2:end);
Flux_550 = data3d(9,2:end);
Flux_575 = data3d(10,2:end);
Flux_600 = data3d(11,2:end);
Flux_650 = data3d(12,2:end);
Flux_700 = data3d(13,2:end);
Flux_750 = data3d(14,2:end);
Flux_800 = data3d(15,2:end);

fpp2d = zeros(15,1); % flux per pole array of 2D results
fpp3d = zeros(15,1); % flux per pole array of 3D results
%% FFT of The Radial Flux Density Distribution
FundamentalFrequency = 50; % Hz
maxNoOfHarmonic = 20;
Flux = [Flux_500 Flux_500];
Flux = Flux';
Fs = FundamentalFrequency*2*maxNoOfHarmonic*p;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(Flux);     % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(Flux);        % fft of the signal

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% plotting the fft
figure
f = Fs*(0:(L/2))/L;
stem(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("Frequency (Hz)")
ylabel("|P1(f)|")

% computing the phases
z = angle(Y);
z = real(z);
ly = length(Y);
f = (0:ly-1)/ly*Fs;

% plotting the phases
figure
stem(f,z*180/pi)
title("Double-Sided Amplitude Spectrum of x(t)")
xlabel("Frequency (Hz)")
ylabel("|y|")

%% Induced Voltage Calculations
AngleShortList = []; 
MagShortList = [];
Interest = [1 5 7 11 13 15 17 19];
for i = Interest*50
    AngleShortList = [AngleShortList z(i/6.25+1)];
    MagShortList = [MagShortList P1(i/6.25+1)];
end

kw=[0.958 0.205 0.157 0.128 0.133 0 0.267 1.407];
V = 0;
time = 0:2*pi/1000:2*pi;
for i = 1:length(kw)
    V = V + 100*kw(i)*2*pi*50*Interest(i)*MagShortList(i)*sin(Interest(i).*time-AngleShortList(i));
end

plot(V)