clc;
clear;
close all;

% This is the lab for digital image courses
% Task 2-1

string = input("请输入斜率 fa 与截距 fb \n(用逗号分隔)\n", 's');
in = strsplit(string, ',');
fa = str2num(in{1});
fb = str2num(in{2});

lena = imread("./pics/lena.bmp");

[m, n] = size(lena); 
moved = zeros(m, n);
for i = 1 : m
    for j = 1 : n
        temp = lena(i, j) * fa + fb;
        if (temp < 0)
            temp = 0;
        elseif (temp > 255)
            temp = 255;
        end
        moved(i, j) = temp;
    end
end

figure();
subplot(1, 2, 1);
imshow(lena);
title("Lana 原始图");

subplot(1, 2, 2);
imshow(uint8(moved));
title("Lana 灰度变换图");
