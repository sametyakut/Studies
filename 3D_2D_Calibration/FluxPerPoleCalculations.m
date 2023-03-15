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
%% Variables
data3d = [];
data2d = xlsread("fpp2d.csv");
If = unique(data2d(:,1));

fpp2d = zeros(15,1); % flux per pole array of 2D results
fpp3d = zeros(15,1); % flux per pole array of 3D results
%% Flux Per Pole Calculations
sum = 0; % summation for surfaces of 3D model, i.e., 160 surfaces at each pole
j = 1; % just an index
for i = 1:length(data2d) % finding related fpp from 2D results data
    fpp2d(i) = max(data2d(i));
end

for i = 1:160 % integration of flux for 3D results
    sum = sum + data3d(i);
    if i == 160
        fpp3d(j) = sum;
        j = j+1;
    end
end

%% Plotting
scatter(If,fpp3d);
hold on
scatter(If,fpp2d);

%% Slot Leakage Flux Calculations
