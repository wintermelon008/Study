clc;
clear;
close all;

% This is the lab for digital image courses
% Task 1-1

string = input("请输入平移偏移量 dx and dy\n(用逗号分隔)\n", 's');
in = strsplit(string, ',');
dx = str2num(in{1});
dy = str2num(in{2});


origin = imread("./pics/lena.bmp");
moved = imtranslate(origin, [dx, dy]);



figure();
subplot(1, 2, 1);
imshow(origin);
title("Origin Lana");

subplot(1, 2, 2);
imshow(moved);
title("Moved Lana");