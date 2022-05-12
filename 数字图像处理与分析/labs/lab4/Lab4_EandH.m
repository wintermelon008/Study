clc;
clear;
close all;

% This is the lab for digital image courses
% Task 4 PART IV
% Pic emphasis and histeq 

pout = imread("./pics/pout.bmp");
pout_fourier = fftshift(fft2(pout));
[m, n] = size(pout);
mid_m = floor(m/2);
mid_n = floor(n/2);

% 产生滤波器
% 高通滤波器
H_idel_h = zeros(m, n);
H_butterworze_h = zeros(m, n);
H_gauss_h = zeros(m, n);
% 高频增强滤波器
H_emphasis_idel_h = zeros(m, n);
H_emphasis_butterworze_h = zeros(m, n);
H_emphasis_gauss_h = zeros(m, n);


T_h = 35;                % 理想高通  sqrt(2)?
D_h = 35; N_h = 1;       % 巴特沃斯高通
Sigma_h = 30;            % 高斯高通

a = 1;                   % 高通滤波器参数
b = 5;

for i = 1 : m
    for j = 1 : n
        dis = sqrt((i - mid_m)^2 + (j - mid_n)^2);   
        if dis > T_h
            H_idel_h(i, j) = 1;
        else
            H_idel_h(i, j) = 0;
        end   
        

        H_butterworze_h(i, j) = (1 + (D_h/dis)^(2*N_h))^-1;
        
        H_gauss_h(i, j) = 1 - exp(-dis^2 / (2 * Sigma_h^2));
        
        H_emphasis_idel_h(i, j) = a + b * H_idel_h(i, j);
        H_emphasis_butterworze_h(i, j) = a + b * H_butterworze_h(i, j);
        H_emphasis_gauss_h(i, j) = a + b * H_gauss_h(i, j);
    end
end



% 先高频增强，后直方图均衡化
%滤波
pout_emphasis_idel_h = H_emphasis_idel_h .* pout_fourier;
pout_emphasis_butterworze_h = H_emphasis_butterworze_h .* pout_fourier;
pout_emphasis_gausss_h = H_emphasis_gauss_h .* pout_fourier;
%反变换
pout_emphasis_ifourier_idel_h = uint8(abs(ifft2(pout_emphasis_idel_h)));
pout_emphasis_ifourier_butterworze_h = uint8(abs(ifft2(pout_emphasis_butterworze_h)));
pout_emphasis_ifourier_gauss_h = uint8(abs(ifft2(pout_emphasis_gausss_h)));
%均衡化
pout_emphasis_histeq_idel = histeq(pout_emphasis_ifourier_idel_h, 256);
pout_emphasis_histeq_butterworze = histeq(pout_emphasis_ifourier_butterworze_h, 256);
pout_emphasis_histeq_gauss = histeq(pout_emphasis_ifourier_gauss_h, 256);

% 先直方图均衡化，后高频增强
%均衡化
pout_histeq = histeq(pout, 256);
pout_histeq_fourier = fftshift(fft2(pout_histeq));
%滤波
pout_histeq_emphasis_idel_h = H_emphasis_idel_h .* pout_histeq_fourier;
pout_histeq_emphasis_butterworze_h = H_emphasis_butterworze_h .* pout_histeq_fourier;
pout_histeq_emphasis_gauss_h = H_emphasis_gauss_h .* pout_histeq_fourier;
%反变换
pout_histeq_emphasis_idel = uint8(abs(ifft2(pout_histeq_emphasis_idel_h)));
pout_histeq_emphasis_butterworze = uint8(abs(ifft2(pout_histeq_emphasis_butterworze_h)));
pout_histeq_emphasis_gauss = uint8(abs(ifft2(pout_histeq_emphasis_gauss_h)));

subplot(2, 4, 1);
imshow(pout);
title("Pout 原始图");

subplot(2, 4, 2);
imshow(pout_emphasis_histeq_idel, []);
title("Pout 先高频增强后均衡化图(理想高通)");

subplot(2, 4, 3);
imshow(pout_emphasis_histeq_butterworze, []);
title("Pout 先高频增强后均衡化图(巴特沃斯高通)");

subplot(2, 4, 4);
imshow(pout_emphasis_histeq_gauss, []);
title("Pout 先高频增强后均衡化图(高斯高通)");

subplot(2, 4, 5);
imshow(pout);
title("Pout 原始图");

subplot(2, 4, 6);
imshow(pout_histeq_emphasis_idel, []);
title("Pout 先均衡化后高频增强图(理想高通)");

subplot(2, 4, 7);
imshow(pout_histeq_emphasis_butterworze, []);
title("Pout 先均衡化后高频增强图(巴特沃斯高通)");

subplot(2, 4, 8);
imshow(pout_histeq_emphasis_gauss, []);
title("Pout 先均衡化后高频增强图(高斯高通)");

