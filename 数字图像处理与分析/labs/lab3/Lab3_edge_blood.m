clc;
clear;
close all;

% This is the lab for digital image courses
% Task 3 PART III
% edge 


blood = imread("./pics/blood.bmp");
[m, n] = size(blood);

blood_roberts = edge(blood, 'Roberts');
blood_sobel = edge(blood, 'Sobel');
blood_prewitt = edge(blood, 'Prewitt');
blood_canny = edge(blood, 'Canny');


filter_laplacian_1 = [0 1 0; 1 -4 1; 0 1 0];
filter_laplacian_2 = [-1 -1 -1; -1 8 -1; -1 -1 -1];

blood_laplacian_1 = imfilter(blood, filter_laplacian_1);
blood_laplacian_2 = imfilter(blood, filter_laplacian_2);



figure();
subplot(2, 4, 1);
imshow(blood);
title("Blood 原始图");

subplot(2, 4, 2);
imshow((blood_roberts));
title("Blood Roberts 边缘检测");

subplot(2, 4, 3);
imshow((blood_sobel));
title("Blood Sobel 边缘检测");

subplot(2, 4, 4);
imshow((blood_prewitt));
title("Blood Prewitt 边缘检测");


subplot(2, 4, 5);
imshow(blood);
title("Blood 原始图");

subplot(2, 4, 6);
imshow(blood_laplacian_1);
title("Blood Laplacian 边缘检测 1");

subplot(2, 4, 7);
imshow(blood_laplacian_2);
title("Blood Laplacian 边缘检测 2");

subplot(2, 4, 8);
imshow((blood_canny));
title("Blood Canny 边缘检测");




