function resultat = BER(bits,origine)
sum = 0;
for i = 1:length(bits)
    if(bits(i)~=origine(i))
        sum = sum + 1 ;
    end
end
resultat = (sum*100)/length(bits);
end