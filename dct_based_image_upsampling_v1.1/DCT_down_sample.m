function Its=DCT_down_sample(I)
% I - input image
% ds - downsample factor is 2; repeat if nessesary

[soy sox] =size(I);
Id=zeros(soy,sox);Iobserved=zeros(soy,sox);
% dct and insert zeros
for j=1:8:sox
    for i=1:8:soy
        Id(i:i+7,j:j+7)=dct2(I(i:i+7,j:j+7));
        Iobserved(i:i+3,j:j+3)=Id(i:i+3,j:j+3)./2;
    end
end
%idct
% It=zeros(soy,sox);
Its=zeros(soy/2,sox/2);
for j=1:8:sox
    for i=1:8:soy
%         It(i:i+7,j:j+7)=idct2(Id(i:i+7,j:j+7));
%           It(i:i+7,j:j+7)=idct2(Iobserved(i:i+7,j:j+7).*2);
          Its((i+1)/2:(i+7)/2,(j+1)/2:(j+7)/2)= idct2(Iobserved(i:i+3,j:j+3));
    end
end
% imshow(uint8(It));
% csnr(double(uint8(It)), double(uint8(I)),0,0)  %csnr(double(It), double(I),0,0)
% ssim_index(uint8(It), uint8(I))
% imwrite(uint8(Its),'lena_DS_DCT.bmp');
% imwrite(uint8(It),'lena_DCT.bmp');


return