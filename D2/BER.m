function resultat = BER(bits,origine)
sum = 0;
bits = reshape(bits,[],1);
origine = reshape(origine,[],1);
for i = 1:1:size(bits,1)
    if(bits(i,:)~=origine(i,:))
        sum = sum + 1 ;
    end
end
resultat = (sum*100)/length(bits);
end