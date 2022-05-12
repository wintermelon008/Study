clc;
clear;
close all;

% This is the lab for digital image courses
% Task 4 PART II
% Filter 

pout = imread("./pics/pout.bmp");
pout_fourier = fftshift(fft2(pout));
[m, n] = size(pout);
mid_m = floor(m/2);
mid_n = floor(n/2);


% 产生滤波器
% 低通滤波器
H_idel_l = zeros(m, n);
H_butterworze_l = zeros(m, n);
H_gauss_l = zeros(m, n);
% 高通滤波器
H_idel_h = zeros(m, n);
H_butterworze_h = zeros(m, n);
H_gauss_h = zeros(m, n);


T_l = 35;              % 理想低通
D_l = 200; N_l = 1;      % 巴特沃斯低通
Sigma_l = 50;          % 高斯低通

T_h = 20;                 % 理想高通  
D_h = 20; N_h = 1;      % 巴特沃斯高通
Sigma_h = 30;            % 高斯高通

for i = 1 : m
    for j = 1 : n
        dis = sqrt((i - mid_m)^2 + (j - mid_n)^2);
        if dis > T_l
            H_idel_l(i, j) = 0;
        else
            H_idel_l(i, j) = 1;
        end       
        if dis > T_h
            H_idel_h(i, j) = 1;
        else
            H_idel_h(i, j) = 0;
        end   
        
        H_butterworze_l(i, j) = (1 + (dis/D_l)^(2*N_l))^-1;
        H_butterworze_h(i, j) = (1 + (D_h/dis)^(2*N_h))^-1;
        
        H_gauss_l(i, j) = exp(-dis^2 / (2 * Sigma_l^2));
        H_gauss_h(i, j) = 1 - exp(-dis^2 / (2 * Sigma_h^2));
        
    end
end



% 频率域滤波
pout_idel_l = H_idel_l .* pout_fourier;
pout_butterworze_l = H_butterworze_l .* pout_fourier;
pout_gausss_l = H_gauss_l .* pout_fourier;

pout_idel_h = H_idel_h .* pout_fourier;
pout_butterworze_h = H_butterworze_h .* pout_fourier;
pout_gausss_h = H_gauss_h .* pout_fourier;




% 傅里叶反变换
pout_ifourier_idel_l = uint8(abs(ifft2(pout_idel_l)));
pout_ifourier_butterworze_l = uint8(abs(ifft2(pout_butterworze_l)));
pout_ifourier_gauss_l = uint8(abs(ifft2(pout_gausss_l)));

pout_ifourier_idel_h = (abs(ifft2(pout_idel_h)));
pout_ifourier_butterworze_h = (abs(ifft2(pout_butterworze_h)));
pout_ifourier_gauss_h = (abs(ifft2(pout_gausss_h)));


% 展示

figure();
subplot(2, 4, 1);
imshow(pout);
title("Pout 原始图");

subplot(2, 4, 2);
imshow(pout_ifourier_idel_l);
title("Pout 理想低通滤波图");

subplot(2, 4, 3);
imshow(pout_ifourier_butterworze_l);
title("Pout 巴特沃斯低通滤波图");

subplot(2, 4, 4);
imshow(pout_ifourier_gauss_l);
title("Pout 高斯低通滤波图");

subplot(2, 4, 5);
imshow(pout);
title("Pout 原始图");

subplot(2, 4, 6);
imshow(pout_ifourier_idel_h, []);
title("Pout 理想高通滤波图");

subplot(2, 4, 7);
imshow(pout_ifourier_butterworze_h, []);
title("Pout 巴特沃斯高通滤波图");

subplot(2, 4, 8);
imshow(pout_ifourier_gauss_h, []);
title("Pout 高斯高通滤波图");





