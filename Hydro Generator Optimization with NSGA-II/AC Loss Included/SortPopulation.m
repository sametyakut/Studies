function [pop, F] = SortPopulation(pop)

    % Sort Based on Crowding Distance
    [~, CDSO] = sort([pop.CrowdingDistance], 'descend'); 
    pop = pop(CDSO); 

    %[B,I] = sort(___) also returns a collection of index vectors for any of the previous syntaxes. 
    % I is the same size as A and describes the arrangement of the elements of A into B along the sorted dimension. 
    % For example, if A is a vector, then B = A(I).

    % Sort Based on Rank
    [~, RSO] = sort([pop.Rank]);  
    pop = pop(RSO);
    
    % Update Fronts
    Ranks = [pop.Rank];  
    MaxRank = max(Ranks);  
    F = cell(MaxRank, 1);
    for r = 1:MaxRank 
        F{r} = find(Ranks == r); 
    end

end