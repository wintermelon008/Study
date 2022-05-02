clc;
clear;
close all;

% This is the lab for digital image courses
% Task 3 PART III
% edge 


lena = imread("./pics/lena.bmp");
[m, n] = size(lena);

lena_roberts = edge(lena, 'Roberts');
lena_sobel = edge(lena, 'Sobel');
lena_prewitt = edge(lena, 'Prewitt');
lena_canny = edge(lena, 'Canny');


filter_laplacian_1 = [0 1 0; 1 -4 1; 0 1 0];
filter_laplacian_2 = [-1 -1 -1; -1 8 -1; -1 -1 -1];

lena_laplacian_1 = imfilter(lena, filter_laplacian_1);
lena_laplacian_2 = imfilter(lena, filter_laplacian_2);



figure();
subplot(2, 4, 1);
imshow(lena);
title("Lena 原始图");

subplot(2, 4, 2);
imshow((lena_roberts));
title("Lena Roberts 边缘检测");

subplot(2, 4, 3);
imshow((lena_sobel));
title("Lena Sobel 边缘检测");

subplot(2, 4, 4);
imshow((lena_prewitt));
title("Lena Prewitt 边缘检测");


subplot(2, 4, 5);
imshow(lena);
title("Lena 原始图");

subplot(2, 4, 6);
imshow(lena_laplacian_1);
title("Lena Laplacian 边缘检测 1");

subplot(2, 4, 7);
imshow(lena_laplacian_2);
title("Lena Laplacian 边缘检测 2");

subplot(2, 4, 8);
imshow((lena_canny));
title("Lena Canny 边缘检测");




