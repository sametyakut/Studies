function [y, lambda] = lookUpTable(Q)
    round(Q)
    if mod(Q,3) == 0
        y = Q;
    elseif mod(Q,3) == 1
        y = Q-1;
    else
        y = Q+1;
    end
    
    if (y>=7*32) && (y<8*32)
        lambda = 7;
    elseif (y>=8*32) && (y<9*32)
        lambda = 8;
    elseif (y>=9*32) && (y<10*32)
        lambda = 9;
    elseif (y>=10*32) && (y<11*32)
        lambda = 10;
    elseif (y>=11*32) && (y<12*32)
        lambda = 11;
    else
        lambda = 12;
    end
end
