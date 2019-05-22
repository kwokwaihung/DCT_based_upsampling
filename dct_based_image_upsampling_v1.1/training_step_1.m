% forming dictionary by extracting high-freq training pairs
clear
I=imread('training\training_image.bmp');

[sy sx]=size(I);

% formulate the LR image first
Id=zeros(sy,sx);Iobserved=zeros(sy,sx);
%dct
for j=1:8:sx
    for i=1:8:sy
        Id(i:i+7,j:j+7)=dct2(I(i:i+7,j:j+7));
        Iobserved(i:i+3,j:j+3)=Id(i:i+3,j:j+3)./2;
    end
end
%idct
It=zeros(sy,sx);  Its=zeros(sy/2,sx/2);
for j=1:8:sx
    for i=1:8:sy
          Its((i+1)/2:(i+7)/2,(j+1)/2:(j+7)/2)= idct2(Iobserved(i:i+3,j:j+3));
    end
end
imshow(uint8(It));
csnr_index(double(uint8(It)), double(uint8(I)),0,0)  %csnr(double(It), double(I),0,0)
ssim_index(uint8(It), uint8(I))
imwrite(uint8(Its),'training\lena_DS_DCT.bmp');
imwrite(uint8(It),'training\lena_DCT.bmp');

Ig=gradient(double(I)); Ig=abs(Ig); 
imwrite(uint8(Ig),'training\lena_Gra.bmp');
Its=imread('training\lena_DS_DCT.bmp');
Itsg=gradient(double(Its));  Itsg= abs(Itsg);
imwrite(uint8(Itsg),'training\lena_DS_Gra.bmp');


%training start here
clear
%read the images  % inteval 6 or threshold 64 doesn't work
I=imread('training\training_image.bmp'); [sy sx]=size(I);
Its=imread('training\lena_DS_DCT.bmp');
Itsg=imread('training\lena_DS_Gra.bmp');

%build the database
IDict=zeros(64,1); ItsDict=zeros(64,1);  ItsgDict=zeros(64,1);   ItsgNDict=zeros(64,1); 
IDict_6=zeros(36,1); ItsDict_6=zeros(36,1); IDict_4=zeros(16,1); 
ItsDict_4=zeros(16,1); ItsNDict_6=zeros(36,1);
Itsg=double(Itsg);  Its=double(Its);

%fixed matrix size, much faster
ItsNDict_6=zeros(36,500000); IDict=zeros(64,500000); ItsDict_4=zeros(16,500000); 

k=0; index=2; 
for j=9+32*0:8:sx-8-32*0  %257:8:320
    for i=9+32*0:8:sy-8-32*0

          if sum(sum(Itsg((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1)))> 48

%  using normalized image intensity, 6x6 instead of 8x8 block
temp=reshape(Its((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1), 36,1);
         meanT= mean(temp); %[sT sT2]=size(temp);
         stdT= sqrt(sum((temp-meanT).^2)/36);
%  ItsNDict_6=[ItsNDict_6 reshape((Its((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1)-meanT)/stdT, 36,1) reshape((Its((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1)'-meanT)/stdT, 36,1)]; 
 ItsNDict_6(:,index)=reshape((Its((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1)-meanT)/stdT, 36,1); 
 ItsDict_4(:,index)=reshape(Its((i+1)/2-0:(i+7)/2+0,(j+1)/2-0:(j+7)/2+0), 16,1); 
 IDict(:,index)=reshape(I(i:i+7,j:j+7),64, 1); 
 
  index=index+1;
 
  ItsNDict_6(:,index)=reshape((Its((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1)'-meanT)/stdT, 36,1); 
 ItsDict_4(:,index)=reshape(Its((i+1)/2-0:(i+7)/2+0,(j+1)/2-0:(j+7)/2+0)',16,1);
 IDict(:,index)=reshape(I(i:i+7,j:j+7)',64, 1);
 
   index=index+1;

k=k+1;             
          end
    end
end

% delete the zero elements
ItsNDict_6=ItsNDict_6(:,1:index-1); 
ItsDict_4=ItsDict_4(:,1:index-1); %ItsDict_4=uint8(ItsDict_4); % slower if uint8 format
IDict=IDict(:,1:index-1); %IDict=uint8(IDict);
   

save 'ItsNDict_6.mat' ItsNDict_6;
save 'ItsDict_4.mat' ItsDict_4;
save 'IDict.mat' IDict;
