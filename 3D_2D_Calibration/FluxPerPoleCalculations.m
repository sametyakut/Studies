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