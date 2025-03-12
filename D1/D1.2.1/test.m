mx = [1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1,0];
%code = BCH(mx,2);
%code_prim = code;
%code_prim(2)  = mod(code_prim(2)+1,2); 
%code_prim(9) = mod(code_prim(9)+1,2);
%decode = ML(code_prim ,2);
a = [5,6,7]
b = a.'
c = reshape(b,1,3)

disp(a);disp(b);disp(c);
