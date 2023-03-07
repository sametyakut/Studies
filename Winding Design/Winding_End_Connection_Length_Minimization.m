% Winding End Connection Bars Minimization
Q = 300; % number of slots
a_plus = 1; % a+ connection in winding diagram
a_minus = 257; % a- connection in winding diagram
b_plus = 26; % b+ connection in winding diagram
b_minus = 282; % b- connection in winding diagram
c_plus = 51; % c+ connection in winding diagram
c_minus = 7; % c- connection in winding diagram

min = 1000; % dummy variable for finding minimum length

for n = 1:Q

    l_a_plus = n-a_plus;
    if abs(l_a_plus)>Q/2
        l_a_plus = abs(Q-abs(l_a_plus));
    else l_a_plus = abs(l_a_plus);
    end
    
    l_b_plus = n-b_plus;
    if abs(l_b_plus)>Q/2
        l_b_plus = abs(Q-abs(l_b_plus));
    else l_b_plus = abs(l_b_plus);
    end
    
    
    l_c_plus = n-c_plus;
    if abs(l_c_plus)>Q/2
        l_c_plus = abs(Q-abs(l_c_plus));
    else l_c_plus = abs(l_c_plus);
    end
    
    
    l_a_minus = n-a_minus;
    if abs(l_a_minus)>Q/2
        l_a_minus = abs(Q-abs(l_a_minus));
    else l_a_minus = abs(l_a_minus);
    end
    
    
    l_b_minus = n-b_minus;
    if abs(l_b_minus)>Q/2
        l_b_minus = abs(Q-abs(l_b_minus));
    else l_b_minus = abs(l_b_minus);
    end
    
    
    l_c_minus = n-c_minus;
    if abs(l_c_minus)>Q/2
        l_c_minus = abs(Q-abs(l_c_minus));
    else l_c_minus = abs(l_c_minus);
    end

    total = l_a_minus + l_a_plus +l_b_minus + l_b_plus + l_c_minus + l_c_plus;
    if total<min
        min = total;
        p = n;
    end
end

