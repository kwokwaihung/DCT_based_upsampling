function final=twotime_1dfilter(f,s1,s2)

%f is input observed image
% final is estimated image
% psf is psf of imaging sytem
% m is the magnification factor
% im is the interpolation method
% fac is the factor of error 
% f=It; 
pd=5;
f=padimage_2(f, pd);  %pad image
[sy sx] =size(f);
final= zeros(2*sy, 2*sx);

% [1 -5 20 20 -5 1]./32;
pd=pd-2;
for j=1+pd:sy-pd
    for i=1+pd:sx-pd
        final(2*j,2*i+1)= (f(j,i-2)*1+f(j,i-1)*-5+f(j,i)*20+f(j,i+1)*20+f(j,i+2)*-5+f(j,i+3)*1)/32; 
        final(2*j,2*i)= f(j,i);
    end
end

for j=1+pd:sy-pd
    for i=1+pd:sx-pd
        final(2*j+1,2*i)= (f(j-2,i)*1+f(j-1,i)*-5+f(j,i)*20+f(j+1,i)*20+f(j+2,i)*-5+f(j+3,i)*1)/32; 
        final(2*j+1,2*i+1)= (final(2*j-4,2*i+1)*1+final(2*j-2,2*i+1)*-5+final(2*j,2*i+1)*20+final(2*j+2,2*i+1)*20+final(2*j+4,2*i+1)*-5+final(2*j+6,2*i+1)*1)/32; 
    end
end
pd=pd+2;

final=final(pd*2+s1:sy*2-pd*2+s1-1,pd*2+s2:sx*2-pd*2+s2-1);

return ;

