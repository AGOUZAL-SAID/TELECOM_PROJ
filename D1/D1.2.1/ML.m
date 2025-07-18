function decision = ML(Cx, t)
    code = Cx;
    registre = moduloG(Cx, t);
    
    if isequal(registre, zeros(1, 5*(t == 1) + 10*(t == 2))) % Adapté à la taille du registre
        % Aucune erreur détectée
        if t == 1
            decision = Cx(6:31);
            disp("no erreur");
        elseif t == 2
            decision = Cx(11:31);
            disp("no erreur");
        end
    else
        state = 0;
        
        if t == 1
            % Correction pour t=1 (1 erreur)
            for i = 1:31
                L = zeros(1, 31);
                L(i) = 1;
                e = moduloG(L, 1);
                if isequal(registre, e)
                    decision = code;
                    decision(i) = mod(code(i) + 1, 2);
                    decision = decision(6:31); % Message de 26 bits
                    disp("une erreur corriger");
                    disp(i);
                    state = 1;
                    break;
                end
            end
            
        elseif t == 2
            % Correction pour t=2 (1 ou 2 erreurs)
            for i = 1:31
                % Test des erreurs simples
                L = zeros(1, 31);
                L(i) = 1;
                e = moduloG(L, 2);
                if isequal(registre, e)
                    decision = code;
                    decision(i) = mod(code(i) + 1, 2);
                    decision = decision(11:31); % Message de 21 bits
                    disp("une erreur corriger")
                    disp(i)
                    state = 1;
                    break;
                end
                
                % Test des erreurs doubles
                for j = (i + 1):31
                    L2 = zeros(1, 31);
                    L2([i, j]) = 1;
                    e = moduloG(L2, 2);
                    if isequal(registre, e)
                        decision = code;
                        decision(i) = mod(code(i) + 1, 2);
                        decision(j) = mod(code(j) + 1, 2);
                        decision = decision(11:31); % Message de 21 bits
                        disp("deux erreurs corriger");
                        disp(i);
                        disp(j);
                        state = 1;
                        break;
                    end
                end
                if state == 1
                    break;
                end
            end
        end
        
        % Si aucune erreur n'a été corrigée
        if state == 0
            if t == 1
                decision = Cx(1:26); % Retourne le message brut (non corrigé)
            elseif t == 2
                decision = Cx(1:21); % Correction cohérente avec t=2
            end
        end
    end
end