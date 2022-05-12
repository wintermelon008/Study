clc;
clear;
close all;

% This is the lab for digital image courses
% Task 4 PART I
% Fourier

rect1 = imread("./pics/rect1.bmp");
rect2 = rgb2gray(imread("./pics/rect2.bmp"));

f1 = fftshift(fft2(rect1));
f2 = fftshift(fft2(rect2));
f1c = conj(f1);
f2c = conj(f2);

rect1_fourier_amp = uint8(sqrt(abs(f1)));
rect2_fourier_amp = uint8(sqrt(abs(f2)));

rect1_ifourier_amp = uint8(ifft2(abs(f1)));
rect1_ifourier_ang = uint8(ifft2(8000 * exp(1i * angle(f1))));
rect2_ifourier_amp = uint8(ifft2(abs(f2)));
rect2_ifourier_ang = uint8(ifft2(8000 * exp(1i * angle(f2))));

rect1_ifourier_conj_amp = uint8(abs(ifft2(f1c)));
rect2_ifourier_conj_amp = uint8(abs(ifft2(f2c)));


figure();
subplot(3, 4, 1);
imshow(rect1);
title("Rect1 原始图");

subplot(3, 4, 2);
imshow(rect1_fourier_amp);
title("Rect1 傅里叶变换图");

subplot(3, 4, 3);
imshow(rect2);
title("Rect2 原始图");

subplot(3, 4, 4);
imshow(rect2_fourier_amp);
title("Rect2 傅里叶变换图");

subplot(3, 4, 5);
imshow(rect1_ifourier_amp);
title("Rect1 傅里叶幅度反变换图");

subplot(3, 4, 6);
imshow(rect1_ifourier_ang,[]);
title("Rect1 傅里叶相位反变换图");

subplot(3, 4, 7);
imshow(rect2_ifourier_amp);
title("Rect2 傅里叶幅度反变换图");

subplot(3, 4, 8);
imshow(rect2_ifourier_ang);
title("Rect2 傅里叶相位反变换图");

subplot(3, 4, 9);
imshow(rect1_ifourier_conj_amp);
title("Rect1 傅里叶共轭反变换图");

subplot(3, 4, 11);
imshow(rect2_ifourier_conj_amp);
title("Rect2 傅里叶共轭反变换图");