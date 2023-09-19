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
CostFunction = @(x) Cost(x);      % Cost Function % Cost fonksiyonunu x de tanımlamış, costfunction(x) diye çağırabilir. 

nVar = 7;             % Number of Decision Variables % 4 tane değişkeni var, benim durumdaki gibi

VarSize = [1 nVar];   % Size of Decision Variables Matrix % [1,4] matrix de değişken sayınısı tutmuş. 

Do_max = 7e3;   % mm
Do_min = 7e3;   % mm

k_min = 0.7;
k_max = (Do_min - 2*152-200)/Do_min;

airgap_max = 30;     % mm
airgap_min = 10;      % mm

%Dr_max = Do_max - 2*airgap_min - 400;   % mm
%Dr_min = Do_min - 2*airgap_max - 400;   % mm

Ls_max = 2000;   %mm
Ls_min = 500;   %mm

h2_max = 300;
h2_min = 80;

Q_max = 330;
Q_min = 7*32;

b2_max = pi*Do_max*k_max/Q_min*0.75; % slot pitchin 4'te 1'i slot olsun
b2_min = pi*Do_min*k_min/Q_max*0.25;

VarMin=[Do_min k_min airgap_min Ls_min b2_min h2_min Q_min]; % Lower Bound of Variables % Sırasıyla lower band variable ları bir matrix de tutmuş, 
VarMax=[Do_max k_max airgap_max Ls_max b2_max h2_max Q_max]; % Upper Bound of Variables % Sırasıyla upper boundlar bir matrix de tutmuş (1,4) matrix, 



nObj =2; % Number of Objective Functions armatür mass ve current density
 


%% NSGA II Parameters

MaxIt = 20;      % Maximum Number of Iterations % algoritma 100 kere çalışacak

nPop = 150;        % Population Size % İlk populasyonun sayısı 100 olarak belirlenmiş

pCrossover = 0.7;                         % Crossover Percentage % Populasyonun %70, crossover olacak 
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Partners (Offsprings)

pMutation = 0.1;                          % Mutation Percentage % populasyonun %40 ı mutasyona uğrayacak 
nMutation = round(pMutation*nPop);        % Number of Mutants

mu = 0.02;                    % Mutation Rate

sigma = 0.02*(VarMax-VarMin);  % Mutation Step Size

%% Initialization

empty_ind.Variables = []; % bireylerin, variable değerlerinin tutulduğu array. 
empty_ind.Cost = [];     % birelerin costlarının tutulduğu array, 2 tane cost var. 
empty_ind.Rank = [];     % rank hangi frontier da olduğunu gösteriyor. 
empty_ind.DominatedCount = []; % Bu bireyin kaç kere domine edildiğini sayıyor
empty_ind.DominationSet = []; % Bu bireyin domine ettiği bireylerin listesini tutuyor
empty_ind.CrowdingDistance = []; % Bir Frontier içindeki bireylerin birbirine olan mesafesini tutuyor

pop = repmat(empty_ind, nPop, 1); % empty individual, populasyon sayısı kadar alt alta kopyalamış, initial population oluşmuş
count = 0;
i = 1;
while true % 100 kere döndürerek ilk populasyon oluşturuluyor. 
    
    pop(i).Variables = round(unifrnd(VarMin, VarMax, VarSize),1); %unifrnd verilen min max aralıkta, varsize (4) kadar değer seçiyor. 
    
    if pop(i).Variables(1)<=pop(i).Variables(2)*pop(i).Variables(1) + 200
        continue
    elseif pop(i).Variables(2)*pop(i).Variables(1) - 2*pop(i).Variables(3) <= 32*406/pi
        continue
%     elseif pop(i).Variables(6)<(pop(i).Variables(1)-pop(i).Variables(1)*pop(i).Variables(2))/2
%         continue
    else
        pop(i).Cost = CostFunction(pop(i).Variables); % 4 tane variable' ı olan her populasyon üyesi için cost hesaplanıyor.
    %ilk kez cost lar burada bulunuyor. 
        
        count = count + 1;
    end
    
    if count == nPop
        break
    end

    i = i+1;
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop); % Burada populasyonu, sıralamak için nondominatedsorting i çağırıyor
%tüm populasyon input, çıkış olarak, F ile birlikte populasyonu sıralanmış
%çıkarıyor olabilir. 

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop
% Structure 35x2 ise, index verirken x(1), ilk (1,1) çağırıyor, x(36) ise
% (1,2) yi çağırıyor. Yani satırları alt alta dizmiş ve (70,1) struture
% oluşturmuş gibi düşünülebilir. 
for it = 1:MaxIt
    
    % Crossover
    popc = repmat(empty_ind, nCrossover/2, 2); %(35,2) structure oluşturulmuş. 
    for k = 1:nCrossover/2 % 35e kadar sayıyoruz. 
        
        i1 = randi([1 nPop]); % populasyonda random birey seçilir, 
        p1 = pop(i1); % Bu birey parent 1 e atanır. 
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        % Crossover fonksiyonu iki tane output veriyor. bunları
        % crosspopulasyonda structure da birinci ve ikinci kolonda
        % tutuyoruz. 
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
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop); % rankına göre sıralıyor. 
    
    % Truncate
    pop = pop(1:nPop); % populasyonu sıraladıktan sonra ilk 100 ü alıyor. 
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1}); % populasyonda frontier 1 olanları F1 e yazıyor. 
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]); % ekranda iterasyon sayısı ve F1 sayısını gösterme
    
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1); % Burda bir fonksiyon çağırılmış. 
    xlabel('Initial Cost [USD]'); % Bende burası Armature mass olacak
    ylabel('1/Efficiency'); % Burası Saddle Current Density Homogeneity
    title('Iteration No:',num2str(it)) % Tepede iterasyon numarası yazacak 
    pause(0.01); % % Her 0.01 saniye de bir plot ettirmeyi durdur diyoruz. 


     pop_cost=[pop.Cost];
      conv_best1(it)=min(pop_cost(1,:));
      conv_worst1(it)=max(pop_cost(1,:));

      conv_best2(it)=min(pop_cost(2,:));
      conv_worst2(it)=max(pop_cost(2,:));

      conv_1(it,:)=pop_cost(1,:);
      conv_2(it,:)=pop_cost(2,:);
    
     outDataFileName = 'iterData_' + string(nPop) + 'pop_' + string(it) + '.mat';
     save(outDataFileName,'pop');

     outCostFileName = 'iterData_' + string(nPop) + 'cost_' + string(it) + '.mat';
     save(outCostFileName,'F1');
end
toc % Time of calculation

% figure;
% plot((1:it),conv_1,'r*', 'MarkerSize', 8);
% xlim([0 it+1]);
% ylim([0 5]);
% xlabel('Iteration');
% ylabel('Rail Length (m)');
% grid on;
% 
% figure;
% plot((1:it),conv_2,'r*', 'MarkerSize', 8);
% xlim([0 it+1]);
% ylim([0 1]);
% xlabel('Iteration');
% ylabel('$I_{exit}/I_{peak}$');
% grid on;




%% Results
