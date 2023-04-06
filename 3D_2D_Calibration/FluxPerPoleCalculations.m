% This basic script aims to calibrate the ANSYS Maxwell 3D and 2D in terms
% of axial length of a large scale salient pole synchronous machine. The
% methodology is to calculate the flux per poles in both Maxwell 3D and 2D,
% so that see the how axial length differs. The analytically calculated
% effective axial length from Carter's equations is 913.46 mm, where the
% actual axial length is 925 mm. The input model depth of 2D model is
% analytically calculated effective axial length. Note that 2g (2*airgap)
% term is ignored during effective length calculation because the stator
% core ends have 3 steps to reduce fringing flux. In 3D model, those
% fringings are also included. 

% Further, leakage fluxes of the slots will be calculated to check the
% Roebel transposition validities.

% This is the first version: published in 15.03.2023

%--------------------Update Note--------------------------------------%
% 3D and 2D model results are presented throughout the code. At first step,
% the flux per poles are calculated at the surfaces defined in the airgap
% in 3D model. In analogy, the flux per poles of the 2D model is calculated
% at the lines in the airgap. Then, in order to obtain a meaningful result,
% a line is defined in the 3D model at the middle of the airgap in the
% middle of the axial length. Afterwards, flux per pole is also calculated
% on this line. Results showed that they are same with the 2D results.
% Then, FFT performed on the 3D and 2D radial B graphes to see the
% harmonics, and their phases. Still working on...

% This is the updated first version (v1.1): published in 06.04.2023
%% Variables
clear all
clc
close all

data3d = xlsread("fpp3d.csv");
data2d = xlsread("fpp2d.csv");
If = unique(data2d(:,1));

fpp2d = zeros(15,1); % flux per pole array of 2D results
fpp3d = zeros(15,1); % flux per pole array of 3D results
%% Flux Per Pole Calculations
NumSurfaces = 1280; % number of surfaces in quarter symmetry
poles = 8; % number of poles in quarter symmetry
PoleSurface = NumSurfaces/poles; % number of surfaces in front of a pole

data3d = data3d(1:end,2:PoleSurface+1);
data2d = reshape(data2d,102,[]);
data2d = data2d(1:end,31:end);


for i = 1:length(If) % finding related fpp from 2D results data
    fpp2d(i) = max(data2d(1:end,i));
end


for j = 1:length(If)
    fpp3d(j) = sum(data3d(j,1:end));
end

fpp3d = 2*fpp3d; % due to half symmetry in the axial direction

%% Plotting Flux per Pole
figure
scatter(If,fpp3d,'LineWidth',2);
hold on
scatter(If,fpp2d,'LineWidth',2);
legend('3D','2D')
xlabel('$I_{F}$ (A)')
ylabel('Flux per Pole (Wb)')
xlim([0 800])
ylim([0 0.6])
%% Slot Leakage Flux Calculations
leakageData = xlsread("leakage_flux_3d.csv"); % data import


for j = 1:length(If)
    k=1;
    for i = 2:2:length(leakageData)-1 % distinguishing the pair surfaces
        new_leakageData(j,k) = leakageData(j,i); 
        k = k+1;
    end
end

for j = 1:length(If)
    k=1;
    for i = 3:2:length(leakageData) % distinguishing the pair surfaces
        new_leakageData_pair(j,k) = leakageData(j,i); 
        k = k+1;
    end
end

for i = 1:length(If) % finding maximum leakage fluxes for each If
    leakage(i) = max(abs(new_leakageData(i,1:end)));
    leakage_pair(i) = max(abs(new_leakageData_pair(i,1:end)));
end

max_leakage = max(leakage); % finding absolute maximum leakage flux
max_leakage_pair = max(leakage_pair); % finding absolute maximum leakage flux for pair surfaces

normalized_leakage = leakage./fpp3d'*100; % normalization
normalized_leakage_pair = leakage_pair./fpp3d'*100;

%% Plotting Normalized Leakage
figure
scatter(If,normalized_leakage,'LineWidth',2)
hold on
scatter(If,normalized_leakage_pair,'LineWidth',2)
legend('Leakage','Leakage Pair')
xlabel('$I_F$ (A)')
ylabel('Leakage Flux (\% of Flux per Pole)')
xlim([0 800])
ylim([0 2])

%% B_rad Data Plotting
Brad_2D = xlsread("B_rad_2D_Fine_Mesh.csv"); % reading the data
Brad_3D = xlsread("Brad_If500_CoarseMesh_3D.csv"); % reading the data

position2D = Brad_2D(1:end,3);
B_2D = Brad_2D(1:end,4);
position3D = Brad_3D(1:end,2);
B_3D = Brad_3D(1:end,3);

%integration with Riemann Sum
int_2D = 0;
int_3D = 0;
for i = 2:497
    dx = position2D(i)-position2D(i-1);
    y1 = B_2D(i-1);
    y2 = B_2D(i);
    int_2D = 0.5*(y1+y2)*dx + int_2D;
end
for i = 2:126
    dx = position3D(i)-position3D(i-1);
    y1 = B_3D(i-1);
    y2 = B_3D(i);
    int_3D = 0.5*(y1+y2)*dx + int_3D;
end

%% FFT of The Radial Flux Density Distribution

Fs = 2e3;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(B_2D);     % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(B_2D);        % fft of the signal

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
                      % computing the two-sided spectrum, and converting it
                      % into a single-sided spectrum

% plotting the fft
f = Fs*(0:(L/2))/L;
stem(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

% computing the phases
z = fftshift(Y);
ly = length(Y);
f = (0:ly-1)/ly*Fs;

% plotting the phases
figure
stem(f,z*180/pi)
title("Double-Sided Amplitude Spectrum of x(t)")
xlabel("Frequency (Hz)")
ylabel("|y|")