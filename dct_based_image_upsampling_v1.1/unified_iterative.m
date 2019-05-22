function [ItLSi]=unified_iterative(Its, ItLS,  scale, onthefly, fac, refinement, noofiter)

% Its - input DCT downsampled image
% If learning the universal filter is needed, the original I is required.

[soy sox] =size(ItLS);

pd=8;  ItLSi=ItLS; 
ItsP=padimage_2(Its, pd);  %pad image
[sy sx] =size(ItsP);
 load 'H1.mat'; 
 H=H1;

for k=1:noofiter
    
    if strcmp(onthefly,'overlap_fit')==1    
ItLSi= padimage_2(ItLSi, pd*2);  ItLSiTemp= ItLSi; ItLSiTemp(:,:)=0; sfac=(8/scale)^2; 
%least square filter  % equvalent to iterative ML with 0 initialization 
for j=1+scale:scale:sx*2-6-scale
    for i=1+scale:scale:sy*2-6-scale
         temp= reshape(ItLSi(i:i+7,j:j+7),64, 1); 
          tempL= reshape(ItsP((i+1)/2:(i+7)/2,(j+1)/2:(j+7)/2),16, 1);  
          temp= H'*(H*temp./1-tempL)*4;
          ItLSiTemp(i:i+7,j:j+7)=ItLSiTemp(i:i+7,j:j+7)+( ItLSi(i:i+7,j:j+7)- reshape(temp,8, 8)*fac);
         end
end
ItLSiTemp=ItLSiTemp/sfac;
ItLSiTemp=ItLSiTemp(pd*2+1:sy*2-pd*2,pd*2+1:sx*2-pd*2);  ItLSi= ItLSiTemp;
% csnr(double(uint8(ItLSi)), double(uint8(I)),0,0)
% ssim_index(uint8(ItLSi), uint8(I))
    end

    
     if strcmp(onthefly,'inverse_fit')==1  
ItLSi= padimage_2(ItLSi, pd*2);  
%least square filter  % equvalent to iterative ML with 0 initialization 
for j=1+scale:scale:sx*2-6-scale
    for i=1+scale:scale:sy*2-6-scale
         temp= reshape(ItLSi(i:i+7,j:j+7),64, 1); 
         tempL= reshape(ItsP((i+1)/2:(i+7)/2,(j+1)/2:(j+7)/2),16, 1);  
          temp= H'*(tempL-H*temp./1);
          ItLSi(i:i+7,j:j+7)= ItLSi(i:i+7,j:j+7)- reshape(temp,8, 8)*fac;
         end
end
ItLSi=ItLSi(pd*2+1:sy*2-pd*2,pd*2+1:sx*2-pd*2); 
% csnr(double(uint8(ItLSi)), double(uint8(I)),0,0)
% ssim_index(uint8(ItLSi), uint8(I))
    end   
    
    
if strcmp(refinement,'best_fit')==1     
   
Itd=zeros(soy,sox);  Iobserved=zeros(soy,sox);
for j=1:8:sox
    for i=1:8:soy
          Itd(i:i+7,j:j+7)=dct2(ItLSi(i:i+7,j:j+7));
          Iobserved(i:i+3,j:j+3)= dct2(Its((i+1)/2:(i+7)/2,(j+1)/2:(j+7)/2));
          Itd(i:i+3,j:j+3)=Iobserved(i:i+3,j:j+3)*2;
          ItLSi(i:i+7,j:j+7)=idct2(Itd(i:i+7,j:j+7));
    end
end
% csnr(double(uint8(ItLSi)), double(uint8(I)),0,0)
% ssim_index(uint8(ItLSi), uint8(I))

end
end

return

