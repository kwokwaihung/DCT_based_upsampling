% execution file
% input bmp, or yuv file
% myCluster = parcluster('local');
% myCluster.NumWorkers = 7;  % 'Modified' property now TRUE
% saveProfile(myCluster); 
% matlabpool(7); matlabpool close; parpool(7); delete(gcp('nocreate'));

% Please cite the following paper when you use the code:
% Kwok-Wai Hung, Wan-Chi Siu, Novel DCT-based Image Up-sampling Scheme using Learning-based Adaptive k-Nearest Neighbor MMSE Estimation, IEEE Trans. on Circuit and Systems for Video technology, Accepted for publication.

clear
video=1;             % video=1 for yuv input, video=0 for image input

filterweight=0;   % filterweight=0 generates default results of the paper. filterweight=1 uses pre-computed filter weights (much faster, lower PSNR and SSIM)
cluster=1;        % no of cluster to be used. Default training is 1 cluster, other clusters can be avaialble by training (see readme)

imname='baboonY.bmp';   % image HR input for simulation
vdname='bus.yuv';       % video HR input for simulation

name=['images\' imname];
if video==1 
    name=['videos\' vdname];
end

if video==0
I=imread(name);
end

path(path,'YUV_2\')
width=352; height=288; initialF=0; noF=1;  % number of frames

[Y,U,V]=yuv_import(name,[width height],noF,initialF,'YUV420_8');
Y_DS=cell(1, noF);  U_DS=cell(1, noF); V_DS=cell(1, noF);
Y_DCT=cell(1, noF); Y_Over=cell(1, noF);  Y_BIC=cell(1, noF);
Y_WF=cell(1, noF); Y_WF_DCT=cell(1, noF);
Y_LS=cell(1, noF);  Y_LS_DCT=cell(1, noF);  Y_LSi=cell(1, noF); 

% for i=initialF+1:noF
for i=1:noF
display(i); csnr=0; ssim=0;

if video==1
I=Y{i}; 
end

U{i}=imresize(DCT_down_sample(U{i}), 2, 'bicubic');      % UV componenets are down-sampled by DCT and up-sampled by bicubic 
V{i}=imresize(DCT_down_sample(V{i}), 2, 'bicubic'); 

% % produce the down-sampled LR image if nessesary
Its=DCT_down_sample(I);                                  % Y components are down-sampled by DCT
imwrite(uint8(Its),[name '_DS_DCT.bmp']);

% Y_DS(:, :, i)= Its ;
Y_DS{i}= Its ;  U_DS{i}= DCT_down_sample(U{i});   V_DS{i}= DCT_down_sample(V{i});
tic; %Y_BIC{i}=imresize(Its, 2, 'bicubic'); 
Y_BIC{i}=twotime_1dbicubic(Its, 1,1);toc 

imwrite(uint8(Y_BIC{i}),[name '_BIC.bmp']);
csnr=[csnr csnr_index(double(uint8(Y_BIC{i})), double(uint8(I)),0,0)]  %csnr(double(It), double(I),0,0)
ssim=[ssim ssim_index(uint8(Y_BIC{i}), uint8(I))]

% % up-sample the LR image using DCT zero padding
[sy sx]=size(Its); It=zeros(sy*2,sx*2);
tic; It=unified_iterative(double((Its)), It, 8, 'overlap_fit', 1, 'no_fit', 1); toc
imwrite(uint8(It),[name '_DCT.bmp']);
csnr=[csnr csnr_index(double(uint8(It)), double(uint8(I)),0,0)]  %csnr(double(It), double(I),0,0)
ssim=[ssim ssim_index(uint8(It), uint8(I))]
Y_DCT{i}=It;

% % up-sample the LR image using DCT zero padding overlapping
It=zeros(sy*2,sx*2); tic; It=unified_iterative(Its, It, 2, 'overlap_fit', 1, 'no_fit', 1); toc
imwrite(uint8(It),[name '_DCT_overlapp.bmp']);
csnr=[csnr csnr_index(double(uint8(It)), double(uint8(I)),0,0)]  %csnr(double(It), double(I),0,0)
ssim=[ssim ssim_index(uint8(It), uint8(I))]
Y_Over{i}=It;

% % up-sample the LR image using spatial fixed coefficients methods
tic;It=twotime_1dfilter(Its,1,1); toc % 1,2
imwrite(uint8(It),[name '_WF.bmp']);
csnr=[csnr csnr_index(double(uint8(It)), double(uint8(I)),0,0)]
ssim=[ssim ssim_index(uint8(It), uint8(I))]
Y_WF{i}=It;
% % hybrid DCT-Wiener interpolation scheme 
tic; It=unified_iterative(Its, It, 8, 'overlap_fit', 1, 'no_fit', 1); toc
imwrite(uint8(It),[name '_WF+DCT.bmp']);
csnr=[csnr csnr_index(double(uint8(It)), double(uint8(I)),0,0)]
ssim=[ssim ssim_index(uint8(It), uint8(I))]
Y_WF_DCT{i}=It;

% % up-sample the LR image using k-NN MMSE
tic; [ItLS index_H2 sum_sorted H2_c]=k_NN_MMSE_cluster(Its,cluster,filterweight);  
imwrite(uint8(ItLS),[name '_LS.bmp']);
csnr=[csnr csnr_index(double(uint8(ItLS)), double(uint8(I)),0,0)]
ssim=[ssim ssim_index(uint8(ItLS), uint8(I))]
Y_LS{i}=ItLS;
% ItLS=hybrid_DCT_Wiener(Its, ItLS);
ItLS=unified_iterative(Its, ItLS, 8, 'nofitting', 0.05, 'best_fit', 1);
imwrite(uint8(ItLS),[name '_LS+DCT.bmp']);
csnr=[csnr csnr_index(double(uint8(ItLS)), double(uint8(I)),0,0)]
ssim=[ssim ssim_index(uint8(ItLS), uint8(I))]
Y_LS_DCT{i}=ItLS; 

% % iterative refinement for the hybrid DCT-Wiener interpolation scheme 
ItLSi=ItLS;  
for k=1:6
ItLSi=unified_iterative(Its, ItLSi, 2, 'inverse_fit', 0.05, 'best_fit', 1); 
imwrite(uint8(ItLSi),[name '_Our_' num2str(k) '_LSi.bmp']);
csnr=[csnr csnr_index(double(uint8(ItLSi)), double(uint8(I)),0,0)]
ssim=[ssim ssim_index(uint8(ItLSi), uint8(I))]
end
toc

Y_LSi{i}=ItLSi; 
end

csnr(1)=[];ssim(1)=[];
csvwrite([name '_' int2str(i) '_csnr' '.txt'],csnr);
csvwrite([name '_' int2str(i) '_ssim' '.txt'],ssim);


