clc;
clear;
close all;

% This is the lab for digital image courses
% Task 5 PART I
% noise 

flower = (imread("./pics/flower1.jpg"));
[m, n] = size(flower);


% 产生运动模糊
len = 30;
theta = 45;
h_move = fspecial('motion',len,theta);
flower_move = (imfilter(im2double(flower), h_move,'conv','circular'));

% 产生高斯噪声
sigma = 0.0001;
flower_move_gauss = imnoise(flower_move,'gaussian', 0, sigma);

% 直接逆滤波
fourier_h_move = fft2(h_move, m, n);    % 产生 H
fourier_flower = fft2(flower_move);
ifourier_flower = ifft2(fourier_flower ./ fourier_h_move);

noise = flower_move_gauss - flower_move;
fourier_noise = fft2(noise);
fourier_h_move_gauss = fft2(h_move, m, n);    % 产生 H
fourier_flower_gauss = fft2(flower_move_gauss);
ifourier_flower_gauss = ifft2((fourier_flower_gauss - fourier_noise) ./ fourier_h_move_gauss);


% 维纳滤波
% 运动模糊
nsr= 0;
psf = h_move;
flower_re = deconvwnr(flower_move, psf, nsr);
% 高斯噪声
flower_double = im2double(flower);
nsr_move = sigma / var(flower_double(:));
psf_move = h_move;
flower_gauss_re = deconvwnr(flower_move_gauss, psf_move, nsr_move);

figure();
subplot(2, 4, 1);
imshow(flower);
title("Flower1 原始图");

subplot(2, 4, 2);
imshow(flower_move, []);
title("Flower1 运动模糊图");

subplot(2, 4, 3);
imshow(ifourier_flower, []);
title("Flower1 运动模糊逆滤波图");

subplot(2, 4, 4);
imshow(flower_re);
title("Flower1 运动模糊维纳滤波图");

subplot(2, 4, 5);
imshow(flower);
title("Flower1 原始图");

subplot(2, 4, 6);
imshow(flower_move_gauss);
title("Flower1 运动模糊高斯噪声图");

subplot(2, 4, 7);
imshow(ifourier_flower_gauss);
title("Flower1 运动模糊高斯噪声逆滤波图");

subplot(2, 4, 8);
imshow(flower_gauss_re);
title("Flower1 运动模糊高斯噪声维纳滤波图");