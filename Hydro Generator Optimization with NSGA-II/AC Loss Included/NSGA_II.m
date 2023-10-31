% List of file
%1 nsga2.m ok
%2 NonDominatedSorting.m ok
%3 Dominates.m ok
%4 CalcCrowdingDistance.m ok
%5 SortPopulation ok
%6 Crossover.m ok
%7 Mutate.m    ok
%8 Cost.m  ok
%9 PlotCosts.m ok 
clc;
clear;
close all;
warning('off', 'MATLAB:nearlySingularMatrix');
set(0,'defaulttextfontsize',18);
set(0,'defaultaxesfontsize',18);
set(0,'defaulttextfontname','Times');
set(0,'defaulttextinterpreter','latex');  
set(0, 'defaultAxesTickLabelInterpreter','latex');  
set(0, 'defaultLegendInterpreter','latex');
tic
%% Definition of Problem
CostFunction = @(x) Cost(x);      % Cost Function

nVar = 7;             % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix 

Do_max = 6.858e3;   % mm
Do_min = 6.858e3;   % mm

k_min = 0.7;
k_max = (Do_min - 2*152-200)/Do_min;

airgap_max = 30;     % mm
airgap_min = 10;      % mm

Ls_max = 2000;   %mm
Ls_min = 500;   %mm

h2_max = 300; % slot height, in mm
h2_min = 80;

Q_max = 330; % number of slots
Q_min = 7*32;

% b2_max = pi*Do_max*k_max/Q_min*0.75; % slot width, in terms of slot pitch
% b2_min = pi*Do_min*k_min/Q_max*0.25;

copperSkinDepth = 9.22; %mm @50Hz
strand_Insulation = 0.22; %mm
main_Insulation = 3; %mm
carbon_Paper_Thick = 0.2; %mm

b2_max = copperSkinDepth*2 + 2*strand_Insulation + 2*main_Insulation + 2*carbon_Paper_Thick;
b2_min = pi*Do_min*k_min/Q_max*0.4;

VarMin=[Do_min k_min airgap_min Ls_min b2_min h2_min Q_min]; % Lower Bound of Variables  
VarMax=[Do_max k_max airgap_max Ls_max b2_max h2_max Q_max]; % Upper Bound of Variables  



nObj =2; % Number of Objective Functions
 


%% NSGA II Parameters

MaxIt = 2;      % Maximum Number of Iterations 

nPop = 5;        % Population Size 

pCrossover = 0.7;                         % Crossover Percentage  
%nCrossover = 2*round(pCrossover*nPop/2);  % Number of Partners (Offsprings)
nCrossover = 70;

pMutation = 0.02;                          % Mutation Percentage  
nMutation = round(pMutation*nPop);        % Number of Mutants
mu = 0.05;                    % Mutation Rate

%sigma = 0.02*(VarMax-VarMin);  % Mutation Step Size
sigma = 0.1;
%% Initialization

empty_ind.Variables = []; % individuals
empty_ind.Cost = [];     % costs 
empty_ind.Rank = [];     % rank 
empty_ind.DominatedCount = []; % how many times an individual is dominated
empty_ind.DominationSet = []; % individuals dominated
empty_ind.CrowdingDistance = []; % distance between individuals
%%
pop = repmat(empty_ind, nPop, 1); % empty individual
count = 0;
i = 1;
% creating first population according to filters
while true 
    
    pop(i).Variables = round(unifrnd(VarMin, VarMax, VarSize),1); %unifrnd verilen min max aralıkta, varsize (4) kadar değer seçiyor. 
    
    if pop(i).Variables(1)<=pop(i).Variables(2)*pop(i).Variables(1) + 200
        continue
    elseif pop(i).Variables(2)*pop(i).Variables(1) - 2*pop(i).Variables(3) <= 32*406/pi
        continue
    else
        pop(i).Cost = CostFunction(pop(i).Variables); % calculation of first cost
        
        count = count + 1;
    end
    
    if count == nPop
        break
    end

    i = i+1;
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop); % sorting the whole population

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop
% further generations and calculations
for it = 1:MaxIt
    
    % Crossover
    popc = repmat(empty_ind, nCrossover/2, 2); 
    for k = 1:nCrossover/2 
        
        i1 = randi([1 nPop]); % selecting random individual
        p1 = pop(i1); % assigning parrent
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        [popc(k, 1).Variables, popc(k, 2).Variables] = Crossover(p1.Variables, p2.Variables);
        
        popc(k, 1).Cost = CostFunction(popc(k, 1).Variables);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Variables);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_ind, nMutation, 1);
    for k = 1:nMutation
        
        i = randi([1 nPop]);
        p = pop(i);
        
        popm(k).Variables = Mutate(p.Variables, mu, sigma,VarMin,VarMax);
        
        popm(k).Cost = CostFunction(popm(k).Variables);
        
    end
    
    % Merge
    pop = [pop
         popc
         popm]; 
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop); % sorting wrt rank
    
    % Truncate
    pop = pop(1:nPop); % selecting first 100 individuals
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1}); % storing frontier 1's
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]); % printing iteration number
    
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1); 
    xlabel('Initial Cost [USD]'); 
    ylabel('Efficiency (\%)'); 
    title('Iteration No:',num2str(it)) 
    pause(0.01);  
    
    % saving the population and frontier for preventing from loss of data
    outDataFileName = 'iterData_' + string(nPop) + 'pop_' + string(it) + '.mat';
    save(outDataFileName,'pop');

    outCostFileName = 'iterData_' + string(nPop) + 'cost_' + string(it) + '.mat';
    save(outCostFileName,'F1');
end
toc % Time of calculation



%% Results
% left blank for further calculations from the obtained results