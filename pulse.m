function [ y ] = pulse( t,tho,A )

for i = 1 : length(t)
    if  0 <= t(i) && t(i) <= (tho) 
        y(i) = A * 1;
    else
        y(i) = 0;
    end
end
end

