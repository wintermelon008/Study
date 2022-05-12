clc;
clear;
close all;

% This is the lab for digital image courses
% Task 4 PART III
% Filter 

girl = imread("./pics/girl.bmp");
girl_fourier = fftshift(fft2(girl));
[m, n] = size(girl);
mid_m = floor(m/2);
mid_n = floor(n/2);

% 产生噪声
girl_salt = imnoise(girl,'salt & pepper',0.03);
girl_salt_fourier = fftshift(fft2(girl_salt));
girl_gauss = imnoise(girl,'gaussian', 0, 0.01);
girl_gauss_fourier = fftshift(fft2(girl_gauss));

% 产生低通滤波器
H_idel_l = zeros(m, n);
H_butterworze_l = zeros(m, n);
H_gauss_l = zeros(m, n);
H_idel_h = zeros(m, n);
H_butterworze_h = zeros(m, n);
H_gauss_h = zeros(m, n);

H_salt_idel = zeros(m, n);
H_salt_butterworze = zeros(m, n);
H_salt_gauss = zeros(m, n);
H_gauss_idel = zeros(m, n);
H_gauss_butterworze = zeros(m, n);
H_gauss_gauss = zeros(m, n);

%原图
T_l = 35;              % 理想低通
D_l = 200; N_l = 1;      % 巴特沃斯低通
Sigma_l = 50;          % 高斯低通

T_h = 20;                % 理想高通  sqrt(2)?
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

% 椒盐噪声图
T_salt = 40;              % 理想低通
D_salt = 150; N_salt = 2;      % 巴特沃斯低通
Sigma_salt = 25;          % 高斯低通
for i = 1 : m
    for j = 1 : n
        dis = sqrt((i - mid_m)^2 + (j - mid_n)^2);
        if dis > T_salt
            H_salt_idel(i, j) = 0;
        else
            H_salt_idel(i, j) = 1;
        end       
        H_salt_butterworze(i, j) = (1 + dis/D_salt)^(-2*N_salt);
        H_salt_gauss(i, j) = exp(-dis^2 / (2 * Sigma_salt^2));
    end
end

% 高斯噪声图
T_gauss = 40;              % 理想低通
D_gauss = 150; N_gauss = 2;      % 巴特沃斯低通
Sigma_gauss = 30;          % 高斯低通
for i = 1 : m
    for j = 1 : n
        dis = sqrt((i - mid_m)^2 + (j - mid_n)^2);
        if dis > T_gauss
            H_gauss_idel(i, j) = 0;
        else
            H_gauss_idel(i, j) = 1;
        end       
        H_gauss_butterworze(i, j) = (1 + dis/D_gauss)^(-2*N_gauss);
        H_gauss_gauss(i, j) = exp(-dis^2 / (2 * Sigma_gauss^2));
    end
end

% 频率域滤波
girl_idel_l = H_idel_l .* girl_fourier;
girl_butterworze_l = H_butterworze_l .* girl_fourier;
girl_gausss_l = H_gauss_l .* girl_fourier;

girl_idel_h = H_idel_h .* girl_fourier;
girl_butterworze_h = H_butterworze_h .* girl_fourier;
girl_gausss_h = H_gauss_h .* girl_fourier;

girl_salt_idel = H_salt_idel .* girl_salt_fourier;
girl_salt_butterworze = H_salt_butterworze .* girl_salt_fourier;
girl_salt_gauss = H_salt_gauss .* girl_salt_fourier;

girl_gauss_idel = H_gauss_idel .* girl_gauss_fourier;
girl_gauss_butterworze = H_gauss_butterworze .* girl_gauss_fourier;
girl_gauss_gauss = H_gauss_gauss .* girl_gauss_fourier;

% 傅里叶反变换
girl_ifourier_idel_l = uint8(abs(ifft2(girl_idel_l)));
girl_ifourier_butterworze_l = uint8(abs(ifft2(girl_butterworze_l)));
girl_ifourier_gauss_l = uint8(abs(ifft2(girl_gausss_l)));

girl_ifourier_idel_h = (abs(ifft2(girl_idel_h)));
girl_ifourier_butterworze_h =(abs(ifft2(girl_butterworze_h)));
girl_ifourier_gauss_h = (abs(ifft2(girl_gausss_h)));

girl_salt_ifourier_idel = uint8(abs(ifft2(girl_salt_idel)));
girl_salt_ifourier_butterworze = uint8(abs(ifft2(girl_salt_butterworze)));
girl_salt_ifourier_gauss = uint8(abs(ifft2(girl_salt_gauss)));

girl_gauss_ifourier_idel = uint8(abs(ifft2(girl_gauss_idel)));
girl_gauss_ifourier_butterworze = uint8(abs(ifft2(girl_gauss_butterworze)));
girl_gauss_ifourier_gauss = uint8(abs(ifft2(girl_gauss_gauss)));

% 展示

figure();
subplot(4, 4, 1);
imshow(girl);
title("Girl 原始图");

subplot(4, 4, 2);
imshow(girl_ifourier_idel_l);
title("Girl 理想低通滤波图");

subplot(4, 4, 3);
imshow(girl_ifourier_butterworze_l);
title("Girl 巴特沃斯低通滤波图");

subplot(4, 4, 4);
imshow(girl_ifourier_gauss_l);
title("Girl 高斯低通滤波图");

subplot(4, 4, 5);
imshow(girl_salt);
title("Girl 椒盐噪声图");

subplot(4, 4, 6);
imshow(girl_salt_ifourier_idel);
title("Girl 椒盐噪声理想低通滤波图");

subplot(4, 4, 7);
imshow(girl_salt_ifourier_butterworze);
title("Girl 椒盐噪声巴特沃斯低通滤波图");

subplot(4, 4, 8);
imshow(girl_salt_ifourier_gauss);
title("Girl 椒盐噪声高斯低通滤波图");

subplot(4, 4, 9);
imshow(girl_gauss);
title("Girl 高斯噪声图");

subplot(4, 4, 10);
imshow(girl_gauss_ifourier_idel);
title("Girl 高斯噪声理想低通滤波图");

subplot(4, 4, 11);
imshow(girl_gauss_ifourier_butterworze);
title("Girl 高斯噪声巴特沃斯低通滤波图");

subplot(4, 4, 12);
imshow(girl_gauss_ifourier_gauss);
title("Girl 高斯噪声高斯低通滤波图");

subplot(4, 4, 13);
imshow(girl);
title("Girl 原始图");

subplot(4, 4, 14);
imshow(girl_ifourier_idel_h, []);
title("Girl 理想高通滤波图");

subplot(4, 4, 15);
imshow(girl_ifourier_butterworze_h, []);
title("Girl 巴特沃斯高通滤波图");

subplot(4, 4, 16);
imshow(girl_ifourier_gauss_h, []);
title("Girl 高斯高通滤波图");
