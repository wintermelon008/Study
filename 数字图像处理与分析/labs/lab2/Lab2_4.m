clc;
clear;
close all;


% This is the lab for digital image courses
% Task 2-4

pout = imread("./pics/pout.bmp");
[counts, bins] = imhist(pout);
%J_pout = imadjust(pout, [0.3, 0.7], [0, 1]);
J_pout = histeq(pout, 256);
[J_counts, J_bins] = imhist(J_pout);

% 计算高斯直方图
G_bins = zeros(256, 1);
G_counts = zeros(256, 1);
x = 1: 1: 255;
y = Gaussian(x, 0, 13);
y = y * 30000;
y = round(y) + 100;

G_pout = histeq(pout, y);
[G_counts, G_bins] = imhist(G_pout);

figure();
subplot(3, 2, 1);
imshow(pout);
title("Pout 原始图");
subplot(3, 2, 2);
bar(bins, counts);
title("Pout 灰度直方图");
subplot(3, 2, 3);
imshow(J_pout);
title("Pout 增强图");
subplot(3, 2, 4);
bar(J_bins, J_counts);
title("Pout 增强灰度直方图");
subplot(3, 2, 5);
imshow(G_pout);
title("Pout 高斯规定化图");
subplot(3, 2, 6);
bar(G_bins, G_counts);
title("Pout 高斯规定化灰度直方图");

function [y] = Gaussian(x, mu, sigma)
y = 1/(sqrt(2*pi)*sigma)*exp(-(x-mu).^2/(2*sigma^2));
end