clc;
clear;
close all;

% This is the lab for digital image courses
% Task 1-2

angle = input("请输入旋转角度\n(取逆时针为正方向, 用角度制)\n");
disp(angle);

origin = imread("./pics/lena.bmp");
rotate_nearist = imrotate(origin, angle, 'nearest');
rotate_bilinear = imrotate(origin, angle, 'bilinear');


figure();
subplot(1, 3, 1);
imshow(origin);
title("Origin Lana");

subplot(1, 3, 2);
imshow(rotate_nearist);
title("Nearist");

subplot(1, 3, 3);
imshow(rotate_bilinear);
title("Bilinear");

