function H = toeplitz_perso(h,L)
N = length(h);
H = zeros(N, N);

for i = 1:N
    for j = 1:N
        if (j - i) >= -L && (j - i) <= L  
            H(i, j) = h(j - i + L + 1);
        end
    end
end
end