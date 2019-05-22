Novel DCT-based Image Up-sampling Scheme using Learning-based Adaptive k-Nearest Neighbor MMSE Estimation

Module Leader: Prof. W.C. Siu, PhD, CEng, FIEE, FHKIE, FIEEE, Chair Professor

Research Engineer: Dr. Kwok-Wai Hung, PhD(PolyU)

Version 1.1
- Second release.
- Updated to be compatible with MATLAB 2015a. 
- Note: Your computer needs 4GB memory to run this program. These codes hightly possibly needs 64 bit MATLAB.

1). Please cite the following paper when you use the code:

Kwok-Wai Hung, Wan-Chi Siu, Novel DCT-based Image Up-sampling Scheme using Learning-based Adaptive k-Nearest Neighbor MMSE Estimation, IEEE Trans. on Circuit and Systems for Video technology, vol.24, no.12, pp.2018,2033, Dec. 2014. 

2). 
(A) Training (required for once): 
(i) Replace or use the default training_image.bmp in training folder. 
(ii) Run training_step_1.m
(iii) Set the number of cluster you want to use in training_step_2.m (default is 1)
(iv) Run training_step_2.m

(B) Execution:
(i) Open execution.m
(ii) If your computer has >4 CPU threads and >8GB memory, you can input "matlabpool(X);" or "parpool(X);" in workspace, where X is number of CPU threads of your computer and each additional thread needs around 1GB memory during run.
(iii) Set video=1 for video and video=0 for image
(iv) Put the original HR image or HR video into folder "images" or "videos" and set the file name in "name" or in "fileNameOri" in the execution.m
(v) Set the number of cluster you have trained to use (if the cluster number is not avaliable, train it (See step (A))) and run execution.m
(vi) Check the files in folder "images" or "videos" for the results, and PSNR/SSIM values.