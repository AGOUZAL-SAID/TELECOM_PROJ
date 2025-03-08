function code =  BCH(mx , t)

    if  (t ==1)
        mot_1 = [[0,0,0,0,0],mx];
        C1 = moduloG(mot_1 ,t ,0);
        code = [C1,mx] ;
    end

    if (t == 2) 
        mot_2 = [zeros(1,10),k];
        C1 = moduloG(mot_2 ,t ,0);
        code = [C1,mx] ;
    end      
end