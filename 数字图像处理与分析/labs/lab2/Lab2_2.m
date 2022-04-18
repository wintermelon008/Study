clc;
clear;
close all;

% This is the lab for digital image courses
% Task 2-2

string = input("请输入第一个转折点坐标 x1, y1 \n(用逗号分隔)\n", 's');
in = strsplit(string, ',');
x1 = str2num(in{1});
y1 = str2num(in{2});
string = input("请输入第二个转折点坐标 x2, y2 \n(用逗号分隔)\n", 's');
in = strsplit(string, ',');
x2 = str2num(in{1});
y2 = str2num(in{2});

if (x1 == 0)
    x1 = 1;
elseif (x2 == 0)
    x2 = 1;
elseif (x1 == 255)
    x1 = 254;
elseif (x2 == 255)
    x2 = 254;
end

lena = imread("./pics/lena.bmp");

[m, n] = size(lena); 
moved = zeros(m, n);
for i = 1 : m
    for j = 1 : n
        if (lena(i, j) < x1)
            temp = y1 / x1 * lena(i, j);
        elseif (lena(i, j) < x2)
            temp = (y2 - y1)/(x2 - x1) * (lena(i, j) - x1) + y1;
        else
            temp = (255 - y2) / (255 - x2) * (lena(i, j) - x2) + y2;
        end
                
        temp = round(temp);
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
title("Lana 灰度拉伸图");
