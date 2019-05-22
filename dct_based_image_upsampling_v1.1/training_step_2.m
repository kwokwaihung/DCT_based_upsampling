% k means clustering for k-NN MMSE DCT upsampling

clear;
 nofc=1;   % no of cluster to be used
 
 load 'IDict.mat';load 'ItsDict_4.mat'; load 'ItsNDict_6.mat';
 IDict(:,1)=[];ItsDict_4(:,1)=[];ItsNDict_6(:,1)=[];
 [sy sx]=size(ItsNDict_6); [sy4 sx]=size(ItsDict_4); [sy8 sx]=size(IDict);
 map = kmeans(ItsNDict_6',nofc,'MaxIter',10000, 'Display','final');
 
 % calculate centriods
cen=zeros(sy,nofc);
sumc=zeros(1,nofc);

for i=1:sx
%     display(i)
cen(:,map(i))=cen(:,map(i))+ItsNDict_6(:,i);
sumc(:,map(i))=sumc(:,map(i))+1;
end
for i=1:nofc
    cen(:,i)=cen(:,i)/sumc(1,i);
end

% form the sub-dictionary
ItsNDict_6_k=cell(nofc+1,1);
ItsDict_4_k=cell(nofc,1);
IDict_k=cell(nofc,1);

% writing the centriods
ItsNDict_6_k{nofc+1}= cen;

for i=1:nofc
ItsNDict_6_k{i}=zeros(sy,sumc(i));
ItsDict_4_k{i}=zeros(sy4,sumc(i));
IDict_k{i}=zeros(sy8,sumc(i));
end

sumc=zeros(1,nofc);
for i=1:sx
%     display(i)
 sumc(:,map(i))=sumc(:,map(i))+1;
ItsNDict_6_k{map(i)}(:,sumc(1,map(i)))=ItsNDict_6(:,i);
ItsDict_4_k{map(i)}(:,sumc(1,map(i)))=ItsDict_4(:,i);
IDict_k{map(i)}(:,sumc(1,map(i)))=IDict(:,i);
end

save([num2str(nofc) '_ItsNDict_6_k.mat'],'ItsNDict_6_k','-v7.3'); 
save([num2str(nofc) '_ItsDict_4_k.mat'],'ItsDict_4_k','-v7.3'); 
save([num2str(nofc) '_IDict_k.mat'],'IDict_k','-v7.3'); 

% computer filter weights
ItsNDict_6_FW=cell(nofc+1,1);
ItsNDict_6_FW{nofc+1}= cen;

for i=1:nofc
ItsNDict_6_FW{i}= IDict_k{i}*ItsDict_4_k{i}'*inv(ItsDict_4_k{i}*ItsDict_4_k{i}')';
end

save([num2str(nofc) '_ItsNDict_6_FW.mat'],'ItsNDict_6_FW','-v7.3'); 
