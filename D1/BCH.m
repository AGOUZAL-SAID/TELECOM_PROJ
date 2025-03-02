function code =  BCH(mx , t)

    if  (t ==1)
        C1 = moduloG(mx ,t ,0);
        C2 = [mx,[0,0,0,0,0]] ;
        k = C1 + C2 ;

        for i =  1: length(k)
            k(i) = mod(k(i),2);
        end
        code = k ;
    end

    if (t == 2) 
        C1 = moduloG(mx ,t ,0);
        C2 = [mx,zeros(1,10)] ;
        k = C1 + C2 ;
        for i =  1: length(k)
            k(i) = mod(k(i),2);
        end 
        code = k ; 

    end      
end