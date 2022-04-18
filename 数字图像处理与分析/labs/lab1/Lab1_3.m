clc;
clear;
close all;

% This is the lab for digital image courses
% Task 1-3

string = input("请输入长宽伸缩比例 c and d\n(用逗号分隔, 数值大于一为放大)\n", 's');
in = strsplit(string, ',');
c = str2num(in{1});
d = str2num(in{2});

origin = imread("./pics/lena.bmp");
[h, w, c] = size(origin);
resize_nearist = imresize(origin, [h*c, w*d], 'nearest');
resize_bilinear = imresize(origin, [h*c, w*d], 'bilinear');


figure();
subplot(1, 3, 1);
imshow(origin);
title("Origin Lana");

subplot(1, 3, 2);
imshow(resize_nearist);
title("Nearist");

subplot(1, 3, 3);
imshow(resize_bilinear);
title("Bilinear");