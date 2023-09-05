function z = Cost(x)

copperPrice = 8.35; % USD/kg
steelPrice = 1.97; % USD/kg
elecPrice = 100; % USD/MWh

if x(1)<=x(2) + 2*x(3) + 200 % outer diameter must be greater than Dr + 2*airgap
                             % + h2 (slot depth), to ensure h2 is taken as
                             % 200 mm
    f1=1e8;
    f2=1e8;

elseif x(2)<=32*406/pi % Rotor perimeter must be greater than the p*(shoe width)
    f1 = 1e8;
    f2 = 1e8;
else
try
delete *.csv

dir = "C:/Users/samet/Documents/GitHub/Studies/Non-dominated Sorting Genetic Algorithm-II"; % working directory
                                                                                            % note that vbs uses
                                                                                            % slash in path names
                                                                                            % (not back slash)
projectName = "trialModel_v2";
designName = "RMxprtDesign1";
scrOrg = fopen('rmxprtExporting.vbs','r');
scrMod = fopen('script.vbs','w');

% checking for possible errors when initiating script
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
        fprintf(scrMod, "Dr = %f \n", x(2));
        fprintf(scrMod, "airgap = %f \n", x(3));
        fprintf(scrMod, "Ls = %f \n", x(4));
        fprintf(scrMod, 'dir = "%s" \n', dir);

    else % copying the rest of the code from the original script
        fprintf(scrMod, "%s \n", str);
    end

end

% Run FEA Model
system('script.vbs');

% Reading necessary results for calculation of costs and penalties

% Calculation of short circuit ratio by reading Xd (unsaturated)
scrData = xlsread('SCR.csv');
Xd = scrData(end,2);
Xd_pu = Xd/(13800/(sqrt(3)*1860)); % pu conversion
SCR = 1/Xd_pu;

% Calculation of initial cost
mass = xlsread('Mass.csv');
copperMass = mass(end,2);
steelMass = mass(end,3)/0.7; % Assuming 30% wastage
totalMaterialCost = copperMass*copperPrice + steelMass*steelPrice;
initCost = totalMaterialCost*2.5; % multiplied for including labor cost

% Reading loss data for calculating cost due to losses in the system
loss = xlsread('Losses.csv');
armatureCopperLoss = loss(end,2);
fieldCopperLoss = loss(end,3);
coreLoss = loss(end,4);
mechanicalLosses = 308; % kW
totalLoss = armatureCopperLoss + fieldCopperLoss + coreLoss + mechanicalLosses;
totalLossHour = totalLoss/1e3*3600; % MWh conversion
totalLossCost = totalLossHour*elecPrice;
totalIncome = 40/3*3600*elecPrice; % 40 MW of generation with 8 hours of working per day

% Reading efficiency
eff = xlsread('Efficiency.csv');

% Assigning costs
if SCR < 0.8 % SCR must be greater than 0.8. In order for helping the algorithm to converge
             % penalty due to lower SCR is assigned in the form of (1/x)^4
             % function
    f1 = 1e6*(1/SCR)^4;
    f2 = 1e6*(1/SCR)^4;
elseif SCR > 1.6 % SCR should be lower than 1.6. To make the algorithm converge, penalty is 
                 % assigned in the form of Ax function.
    f1 = 1e6*SCR;
    f2 = 1e6*SCR;
else % assigning the calculated costs if neither of the penalties is applicable
    f1 = initCost;
    f2 = 1/efficiency;
end

% in case of an error, give constant penalty
catch
    f1=1e8;
    f2=1e8;
end
end
z = [f1 f2]'; % returning costs
end