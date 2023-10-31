function z = Cost(x)

copperPrice = 8.35; % USD/kg
steelPrice = 1.97; % USD/kg
elecPrice = 100; % USD/MWh

if x(1)<=x(2)*x(1) + 200 % outer diameter must be greater than Dr + 2*airgap
                             % + h2 (slot depth), to ensure h2 is taken as
                             % 200 mm
    f1=1e8;
    f2=1e8;

elseif x(1)*x(2)-2*x(3)<=32*406/pi % Rotor perimeter must be greater than the p*(shoe width)
    f1 = 1e8;
    f2 = 1e8;
else
try
delete *.csv

dir = "C:/Users/samet/Documents/GitHub/Studies/Hydro Generator Optimization with NSGA-II/AC Loss Included/"; % working directory
                                                                         % note that vbs uses
                                                                           % slash in path names
                                                                           % (not back slash)
% x(7) is slot number variable, thus we are making it multiple of 3
temp = round(x(7));

if mod(temp,3) == 0
    Q = temp;
elseif mod(temp,3) == 1
    Q = temp-1;
else
    Q = temp+1;
end

% selecting coil pitch wrt slot number, y: coil pitch Q: slot number
if (Q>=7*32) && (Q<8*32)
    y = 7;
elseif (Q>=8*32) && (Q<9*32)
    y = 8;
elseif (Q>=9*32) && (Q<10*32)
    y = 9;
elseif (Q>=10*32) && (Q<11*32)
    y = 10;
elseif (Q>=11*32) && (Q<12*32)
    y = 11;
else
    y = 12;
end

% x(5): slot width (b2), x(6): slot height (h2)
[armatureCopperLoss,numberOfStrands,copperWidth,copperHeight] = roebelAnalysis(x(4),Q,x(5),x(6));

% connecting ANSYS
projectName = "trialModel_v2"; % ANSYS EM Project Name
designName = "RMxprtDesign1"; % Active design name
scrOrg = fopen('rmxprtExporting.vbs','r'); % original recorded script
scrMod = fopen('script.vbs','w'); % modified script

% if script is not opened, return error
if scrOrg < 0
    error('Cannot open original script')
end

if scrMod < 0
    error('Cannot open modified script')
end

% Updating the Modified Script File
while true

    if feof(scrOrg)  % checking the end of the file, if reached -> break the loop
        fclose(scrOrg);
        fclose(scrMod);
        break;
    end

    str = fgetl(scrOrg); % reading the original script line-by-line

    if strcmpi(str(2:end),'matlab') % writing the parameters from MATLAB
        fprintf(scrMod, 'projectName = "%s" \n', projectName);
        fprintf(scrMod, 'designName = "%s" \n', designName);
        fprintf(scrMod, "outDia = %f \n", x(1));
        fprintf(scrMod, "Dr = %f \n", x(1)*x(2)-2*x(3));
        fprintf(scrMod, "airgap = %f \n", x(3));
        fprintf(scrMod, "Ls = %f \n", x(4));
        fprintf(scrMod, "b2 = %f \n", x(5));
        fprintf(scrMod, "h2 = %f \n", x(6));
        fprintf(scrMod, "Q = %f \n", Q);
        fprintf(scrMod, "lambda = %f \n", y);
        fprintf(scrMod, "wireWidth = %f \n", copperWidth*1e3);
        fprintf(scrMod, "wireHeight = %f \n", copperHeight*1e3);
        fprintf(scrMod, "strands = %f \n", numberOfStrands);
        fprintf(scrMod, 'dir = "%s" \n', dir);

    else % copying the rest of the code from the original script
        fprintf(scrMod, "%s \n", str);
    end

end

% Run FEA Model
system('script.vbs');

% short circuit ratio calculation
scrData = xlsread('SCR.csv');
Xd = scrData(end,2);
Xd_pu = Xd/(13800/(sqrt(3)*1860)); % pu conversion
SCR = 1/Xd_pu;

% material mass calculation
mass = xlsread('Mass.csv');
copperMass = mass(end,2)*2.2;
steelMass = mass(end,3)/0.7; % assuming 30% wastage
totalMaterialCost = copperMass*copperPrice + steelMass*steelPrice;
initCost = totalMaterialCost*2.5; % including labor cost, for simplicity multiplied with 2.5

% Exporting core and field losses
loss = xlsread('Losses.csv');
fieldCopperLoss = loss(end,3)*1e3;
coreLoss = loss(end,4)*1e3;
mechanicalLosses = 308e3; % kW
totalLoss = armatureCopperLoss + fieldCopperLoss + coreLoss + mechanicalLosses;

% Efficiency 
efficiency = 40e6/(totalLoss + 40e6)*100;

% assigning cost with penalty functions
if SCR < 0.8
    f1 = initCost + 1e8*(1/SCR)^4;
    f2 = 1/efficiency + 1e8*(1/SCR)^4;
else
    f1 = initCost;
    f2 = 1/efficiency;
end


catch
    f1=1e8;
    f2=1e8;
end
end
z = [f1 f2]';
end