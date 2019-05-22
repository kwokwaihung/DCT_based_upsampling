function [ItLS index_H2 sum_sorted H2_c]=k_NN_MMSE_cluster(Its,cluster, FW)
% up-sample using k-NN MMSE
% Its - input DCT downsampled image

useH=22; fac=4;  % mode22 is the algorithm in the paper

if useH==22

load ([num2str(cluster) '_ItsNDict_6_k.mat']);
load ([num2str(cluster) '_IDict_k.mat']);load ([num2str(cluster) '_ItsDict_4_k.mat']); 
load ([num2str(cluster) '_ItsNDict_6_FW.mat']); 
load 'H2.mat';
    HU=H2; fac=1; scale2=16; [scY scX]=size(ItsNDict_6_k);

end


pd=8;
ItsP=padimage_2(Its, pd);  %pad image
[sy sx] =size(ItsP);

scale=2; 

% initialize the weights for mode 22
H2_cALL=zeros(16, 64, sy*2-6, sx);  index_H2ALL=zeros(1,sy*2-6, sx);  sum_sortedALL=zeros(1,sy*2-6, sx); 

ItLSTempALL=zeros(2*sy,8, sx);  
parfor jj=1:1:sx-3-2
j=jj*2+1;
     display(j);
 ItLSTemp=zeros(2*sy,8);  
  H2_cTemp=zeros(16, 64, sy*2-6);   index_H2Temp=zeros(1,sy*2-6);  sum_sortedTemp=zeros(1,sy*2-6); 
    for i=1+scale:scale:sy*2-6-scale

      % mode 22      
      if useH==22  
                   if j>3 && j<sx*2-6-3 && i>3 && i<sy*2-6-3
   if var(reshape(ItsP((i+1)/2-0:(i+7)/2+0,(j+1)/2-0:(j+7)/2+0), 16,1)) > 25

        % 6x6 block for search           
        temp=reshape(ItsP((i+1)/2-1:(i+7)/2+1,(j+1)/2-1:(j+7)/2+1), 36,1);
        meanT= mean(temp); 
        stdT= sqrt(sum((temp-meanT).^2)/36);   
        temp= (temp- meanT)/(stdT); 
        
% before search, identify the cluster
diffC= zeros(1,scY-1);
for cc=1:scY-1
diffC(1,cc)=norm(ItsNDict_6_k{scY}(:,cc)-temp);
end
[sorted,indexC]= sort(diffC);

     if FW==0
     temp=temp./36;
        corre= temp'*ItsNDict_6_k{indexC(1)};
                 
         [ sorted,index]= sort(corre,'descend');
        
            k=600; sum_sortedT=0; W=zeros(k,k); %W=diag(w); 
          XO=zeros(16,k); Y=zeros(64,k); 
           for m=1+1:k+1
               XO(:,m-1)= ItsDict_4_k{indexC(1)}(:,index(m-1));   %original universal
               Y(:,m-1)= IDict_k{indexC(1)}(:,index(m-1));
               W(m-1,m-1)= exp(sorted(1,m-1)*40);

           sum_sortedT=sum_sortedT+ sorted(1,m-1);                
                    if sum_sortedT > 350     
                    break;
               end
           end
           H =(Y*W*XO'*inv(XO*W*XO'))';       
         
           % check outlier
           W=W./sum(sum(W));
                 
           if sum(sum((Y-H'*XO)*W*(Y-H'*XO)')) < 5000 
           index_H2Temp(1,i)=1; 

           sum_sortedTemp(1,i)= m;
               
           else
               H=HU;
           end
            else
         
       H =   ItsNDict_6_FW{indexC(1)}';
         index_H2Temp(1,i)=1; 
     end
           
              else
                H=HU;
                  end
          temp= reshape(ItsP((i+1)/2-0:(i+7)/2+0,(j+1)/2-0:(j+7)/2+0),16, 1);
          
% %          overlap 
           temp= H'*temp;
           ItLSTemp(i+0:i+7,1:8)= ItLSTemp(i+0:i+7,1:8)+ reshape(temp,8,8 )*fac;    
                   end 
            
                 
      end          
    end
ItLSTempALL(:,:,jj)= ItLSTemp(:,:);
H2_cALL(:,:,:,jj)= H2_cTemp(:, :, :);
index_H2ALL(:,:,jj)=index_H2Temp(:,:);
sum_sortedALL(:,:,jj)= sum_sortedTemp(:,:);
end

% initialize the weights for mode 22
H2_c=zeros(16, 64, sy*2-6, sx*2-6);  index_H2=zeros(1,sy*2-6, sx*2-6);  sum_sorted=zeros(1,sy*2-6, sx*2-6); 
ItLS= zeros(2*sy, 2*sx);

for jj=1:1:sx-3-2
j=jj*2+1;
ItLS(:,j+0:j+7)= ItLS(:,j+0:j+7)+ ItLSTempALL(:,:,jj);
H2_c(:,:,:,j)=H2_cALL(:,:,:,jj);
index_H2(:,:,j)=index_H2ALL(:,:,jj);
sum_sorted(:,:,j)=sum_sortedALL(:,:,jj);
end
    
ItLS=ItLS./scale2; ItLS=ItLS(pd*2+1:sy*2-pd*2,pd*2+1:sx*2-pd*2); 
% csnr(double(uint8(ItLS)), double(uint8(I)),0,0)
% ssim_index(uint8(ItLS), uint8(I))

return