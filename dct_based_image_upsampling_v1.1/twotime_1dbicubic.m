function final=twotime_1dbicubic(f,s1,s2)

%f is input observed image
% final is estimated image
% psf is psf of imaging sytem
% m is the magnification factor
% im is the interpolation method
% fac is the factor of error 
% f=It; 

% x=0.75; a=-0.5;
% (a+2)*(abs(x))^3- (a+3)*(abs(x))^2+1
% x=1.25;
% (a)*(abs(x))^3- 5*(a)*(abs(x))^2+ 8*a*abs(x)-4*a

%  0.8672    0.2266
%  -0.0703   -0.0234

pd=5;
f=padimage_2(f, pd);  %pad image
[sy sx] =size(f);
final= zeros(2*sy, 2*sx); final2= zeros(2*sy, 2*sx);
 
 pd=pd-3;
for j=1+pd:sy-pd
    for i=1+pd:sx-pd
        final(2*j,2*i)= (f(j,i-1)*-0.0703+f(j,i)*0.8672+f(j,i+1)*0.2266+f(j,i+2)*-0.0234); 
        final(2*j,2*i+1)= (f(j,i-1)*-0.0234+f(j,i)*0.2266+f(j,i+1)*0.8672+f(j,i+2)*-0.0703);
    end
end

for j=1+pd:sy-pd
    for i=1+pd:sx*2-pd
        final2(2*j,i)= final(2*j-2,i)*-0.0703+final(2*j,i)*0.8672+final(2*j+2,i)*0.2266+final(2*j+4,i)*-0.0234;
        final2(2*j+1,i)= final(2*j-2,i)*-0.0234+final(2*j,i)*0.2266+final(2*j+2,i)*0.8672+final(2*j+4,i)*-0.0703;
    end
end
 pd=pd+3;

final=final2;

final=final(pd*2+s1:sy*2-pd*2+s1-1,pd*2+s2:sx*2-pd*2+s2-1);

return ;