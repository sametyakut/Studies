function [outputArg1,outputArg2] = Crossover(inputArg1,inputArg2)
p1=inputArg1;
p2=inputArg2;
outputArg1 = inputArg2;
outputArg2 = inputArg1;

r=randi([1,4],1,2);

 while r(1)==r(2)
   r=randi([1,4],1,2);
 end
 
 for i=1:2
 outputArg1(r(i))=p1(r(i));
 outputArg2(r(i))=p2(r(i));
 end

end
