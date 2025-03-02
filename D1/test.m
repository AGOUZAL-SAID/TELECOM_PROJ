mx = [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
code = BCH(mx,1);
decode = ML(code ,1);

if(isequal(code(1:26),decode))
    disp("bonne codage");
end