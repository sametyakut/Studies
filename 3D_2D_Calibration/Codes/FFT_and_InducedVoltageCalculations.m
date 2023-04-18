clear all
clc 
close all
%% Data Import

filename="C:\Users\samet\Documents\GitHub\Studies\3D_2D_Calibration\Codes\Data\fpp3d.csv";
dataLines= [8 8];
data= importfile(filename, dataLines);

Flux=data(2:end);
%% Flux per pole calculation

p=8; % number of poles in symmetry model
length_pole=round(length(Flux)/p); % defining the number of surfaces per pole

flux_per_pole=[];
Flux2=[Flux,Flux];

for i=0:length(Flux)-1
    Sum=0;
    
    for j=1:length_pole
    Sum=Sum+2*Flux2(i+j); % 2 is due to half symmetry in the axial direction
    end
    
    flux_per_pole=[flux_per_pole; Sum];
end
%% FFT Calculations

k=[1 5 7 11 13 17 19]; % selected harmonics
i = 1; % phase A index for phase shifting
[n_short_listedA, mag_short_listedA, angle_shortlistedA] = fftCalculator(k, flux_per_pole, i, length_pole);
i=1+length_pole*2/3; % phase B index for phase shifting
[n_short_listedB, mag_short_listedB, angle_shortlistedB] = fftCalculator(k, flux_per_pole, i, length_pole);
i=1+length_pole*4/3; % phase C index for phase shifting
[n_short_listedC, mag_short_listedC, angle_shortlistedC] = fftCalculator(k, flux_per_pole, i, length_pole);
%% Induced Voltage Calculations

k=[1 5 7 11 13 17 19]; % selected harmonics
time = 0:2*pi/400:2*pi; % time vector
kw=[0.958 0.205 0.157 0.128 0.133 0.267 1.407]; % winding factors of the selected harmonics
value = 'Phase'; % for phase voltages value = 'Phase', o.w. value = 'Line2Line'
[Va, Vb, Va_fund, Vb_fund] = inducedVoltageCalculator(k, time, kw, mag_short_listedA, angle_shortlistedA, mag_short_listedB, angle_shortlistedB, value);
