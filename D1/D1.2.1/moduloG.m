function reste = moduloG(mx,t,d)
    if (t == 1 && d == 0)
        registre = [0,0,0,0,0];
        for i = 31:-1:1
            a = registre(1);
            b = registre(2);
            c = registre(3);
            d_val = registre(4);
            e = registre(5);
            registre(1) = mod(e + mx(i),2);
            registre(2) = a;
            registre(3) = mod(b + e,2);
            registre(4) = c;
            registre(5) = d_val;
        end
        
        reste = registre;
    end

    if (t == 2 && d == 0)
        registre2 = zeros(1,10);
        toggle = zeros(1,10);
        for i = 31:-1:1
            toggle = registre2;
            registre2(1) = mod(toggle(10) + mx(i),2);
            registre2(2) = toggle(1);
            registre2(3) = toggle(2);
            registre2(4) = mod(toggle(3) + toggle(10),2);
            registre2(5) = toggle(4);
            registre2(6) = mod(toggle(5) + toggle(10),2);
            registre2(7) = mod(toggle(6) + toggle(10),2);
            registre2(8) = toggle(7);
            registre2(9) = mod(toggle(8) + toggle(10),2);
            registre2(10) = mod(toggle(9) + toggle(10),2);
        end
        reste = registre2;
    end

    if (d == 1 && t == 1)
        registre = [0,0,0,0,0];
        for i = 31:-1:1
            a = registre(1);
            b = registre(2);
            c = registre(3);
            d_val = registre(4);
            e = registre(5);
            registre(1) = mod(e + mx(i),2);
            registre(2) = a;
            registre(3) = mod(b + e,2);
            registre(4) = c;
            registre(5) = d_val;
        end
        reste = registre;
    end

    if (d == 1 && t == 2)
        registre2 = zeros(1,10);
        toggle = zeros(1,10);
        for i = 31:-1:1
            toggle = registre2;
            registre2(1) = mod(toggle(10) + mx(i),2);
            registre2(2) = toggle(1);
            registre2(3) = toggle(2);
            registre2(4) = mod(toggle(3) + toggle(10),2);
            registre2(5) = toggle(4);
            registre2(6) = mod(toggle(5) + toggle(10),2);
            registre2(7) = mod(toggle(6) + toggle(10),2);
            registre2(8) = toggle(7);
            registre2(9) = mod(toggle(8) + toggle(10),2);
            registre2(10) = mod(toggle(9) + toggle(10),2);
        end
        reste = registre2;
    end
end
