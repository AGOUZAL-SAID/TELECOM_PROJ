function bits = demodulation(z)
bits = zeros(100,length(z));
for i = 1:100 
    bits(i)= symbols2bits(z(i),"PSK",2);
end
end