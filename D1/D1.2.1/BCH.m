function code =  BCH(mx , t)

    if  (t ==1)
        C1 = moduloG(mx ,t ,0);
        code = [C1,mx] ;
    end

    if (t == 2) 
        C1 = moduloG(mx ,t ,0);
        code = [C1,mx] ;
    end      
end