function pop = CalcCrowdingDistance(pop, F)

    nF = numel(F); % number of fronts, 1 e kadar düşebilir. 
    
    for k = 1:nF
        
        Costs = [pop(F{k}).Cost]; % costları bir değişkene eşitledi, mesela F1 içindeki elemanlar
        
        nObj = size(Costs, 1); 
        
        n = numel(F{k});
        
        d = zeros(n, nObj);
        
        for j = 1:nObj
            
            [cj, so] = sort(Costs(j, :));
            
            d(so(1), j) = inf; % en baştaki elemanı inf yapıyoruz. 
            
            for i = 2:n-1 % bir öndeki ile bir arkasındaki elemanlar ile olan mesafeleri hesaplanıyor.
                
                d(so(i), j) = abs(cj(i+1)-cj(i-1))/abs(cj(1)-cj(end)); 
                
            end
            
            d(so(end), j) = inf; % son elemanı inf yapıyoruz, çeşitliliği korumak için. 
            
        end
        
        
        for i = 1:n
            
            pop(F{k}(i)).CrowdingDistance = sum(d(i, :));
            
        end
        
    end


end

