%% Non-dominated Sorting Genetic Algorithm-II Code
% This code is created with the help of MATLAB file exchange website.
% Thanks to Yarpiz / Mostapha Heris for their great effort.

% This code is created for optimizing a hydro generator design by changing
% outer diameter, rotor diameter, airgap length, and axial length. RMxprt
% is utilized for faster but less accurate simulations. "vbs" is used to
% connect MATLAB to ANSYS. This tool can be seen in MATLAB2ANSYS folder in
% this repo.

% List of file to check
%1 nsga2.m ok
%2 NonDominatedSorting.m ok
%3 Dominates.m ok
%4 CalcCrowdingDistance.m ok
%5 SortPopulation ok
%6 Crossover.m ok
%7 Mutate.m    ok
%8 Cost.m  ok
%9 PlotCosts.m ok 
%%
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
CostFunction = @(x) Cost(x);      % Cost Function % Cost fonksiyonunu x de tanımlamış, costfunction(x) diye çağırabilir. 

nVar = 4;             % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix

% Defining variable ranges
Do_max = 10e3;   % mm
Do_min = 5e3;   % mm

airgap_max = 30;     % mm
airgap_min = 10;      % mm

Dr_max = Do_max - 2*airgap_min - 400;   % mm
Dr_min = Do_min - 2*airgap_max - 400;   % mm

Ls_max = 1500;   %mm
Ls_min = 400;   %mm

VarMin=[Do_min Dr_min airgap_min Ls_min]; % Lower Bound of Variables  
VarMax=[Do_max Dr_max airgap_max Ls_max]; % Upper Bound of Variables 



nObj =2; % Number of Objective Functions 
 


%% NSGA II Parameters

MaxIt = 10;      % Maximum Number of Iterations 

nPop = 50;        % Population Size 

pCrossover = 0.7;                         % Crossover Percentage  
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Partners (Offsprings)

pMutation = 0.1;                          % Mutation Percentage  
nMutation = round(pMutation*nPop);        % Number of Mutants

mu = 0.1;                    % Mutation Rate

sigma = 0.1*(VarMax-VarMin);  % Mutation Step Size

%% Initialization
% Defining empty matrices for storing population members' variables, costs, 
% ranks dominated counts, domination sets, and crowding distances
empty_ind.Variables = [];  
empty_ind.Cost = [];      
empty_ind.Rank = [];      
empty_ind.DominatedCount = []; 
empty_ind.DominationSet = []; 
empty_ind.CrowdingDistance = []; 

pop = repmat(empty_ind, nPop, 1); % copying empty individual to store for all individuals in population

% Creating first population
count = 0;
i = 1;
while true  
    
    pop(i).Variables = round(unifrnd(VarMin, VarMax, VarSize),1); % selecting a variation 
    
    % Constraints for variables
    if pop(i).Variables(1)<=pop(i).Variables(2) + 2* pop(i).Variables(3) + 200
        continue
    elseif pop(i).Variables(2) <= 32*406/pi
        continue
    else
        pop(i).Cost = CostFunction(pop(i).Variables); % Calculation of costs
        count = count + 1;
    end
    
    if count == nPop
        break
    end

    i = i+1;
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop); % Calling non-dominated sorting algorithm for sorting the population

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop

% Calculations for populations other than the initial one, i.e., crossovers
% and mutations are performed in this loop. Thus, named as main NSGA-II
% loop.
for it = 1:MaxIt
    
    % Crossover
    popc = repmat(empty_ind, nCrossover/2, 2);  
    for k = 1:nCrossover/2  
        
        i1 = randi([1 nPop]); % selecting a random individual from population
        p1 = pop(i1); % assigning the selected individual as a parent 
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);

        % Performing crossovers and storing their outputs
        [popc(k, 1).Variables, popc(k, 2).Variables] = Crossover(p1.Variables, p2.Variables);
        
        % Calculating the cost function for new population
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
    pop = SortPopulation(pop); 
    
    % Truncate
    pop = pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1}); % storing frontier 1's in another struct
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]); 
    
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1); 
    xlabel('Initial Building Cost (USD)'); 
    ylabel('1/Efficiency'); 
    title('Iteration No:',num2str(it))  
    pause(0.01); 

    % storing best and worst costs of the each iteration
    pop_cost=[pop.Cost];
    conv_best1(it)=min(pop_cost(1,:));
    conv_worst1(it)=max(pop_cost(1,:));

    conv_best2(it)=min(pop_cost(2,:));
    conv_worst2(it)=max(pop_cost(2,:));

    conv_1(it,:)=pop_cost(1,:);
    conv_2(it,:)=pop_cost(2,:);
    
    % Saving the results of each iteration for convenience. In case of an
    % power outage, the last iteration is saved. Later, this iteration can be
    % loaded into the code to continue from there.
    outDataFileName = 'iterData_' + string(nPop) + 'pop_' + string(it) + '.mat';
    save(outDataFileName,'pop');
end
toc % Time of calculation

%% Results 
% This section is created for extra plots. For now, it is kept empty
% intentionally.