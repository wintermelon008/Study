clc;
clear;
close all;

% This is the lab for digital image courses
% Task 2-3

string = input("请输入灰度直方图的下限 min 与上限 max \n(用逗号分隔)\n", 's');
in = strsplit(string, ',');
min = str2num(in{1});
max = str2num(in{2});

lena = imread("./pics/lena.bmp");
[counts, bins] = imhist(lena);

new_bins = zeros(max - min + 1: 1);
new_counts = zeros(max - min + 1: 1);
for i = 1: max - min + 1
    new_bins(i, 1) = i + min - 1;
    new_counts(i, 1) = counts(i + min, 1);
end

figure();
subplot(1, 2, 1);
imshow(lena);
title("Lana 原始图");
subplot(1, 2, 2);
bar(new_bins, new_counts);
title("Lana 灰度直方图");


