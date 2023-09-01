function [out] = Mutate(input,mu,sigma,VarMin,VarMax)
 

nVar = numel(input);  
nMu = ceil(mu*nVar); 
j = randsample(nVar, nMu);    
out = input; 
 if numel(sigma)>1 
        sigma = sigma(j);  
 end

out(j) = input(j)+sigma.*rand(1,numel(j));
 if out(j)<VarMin(j) 
        out(j)=VarMin(j);
 end
    
  if out(j)>VarMax(j)
        out(j)=VarMax(j);
  end
end
