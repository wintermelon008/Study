clc;
clear;
close all;

% This is the lab for digital image courses
% Task 5 PART II
% ostu

lena = (imread("./pics/lena.bmp"));
[m, n] = size(lena);

T = graythresh(lena);
lena_2 = imbinarize(lena, T);

count = tabulate(lena(:));
total = m * n;

max = 0;
for i = 2 : 237
    n0 = sum(count(1:i - 1, 2));
    w0 = n0 / total;
    n1 = sum(count(i + 1:238, 2));
    w1 = n1 / total;
    if (n0 == 0)
        u0 = 0;
    else
        u0 = sum(count(1:i-1, 2) .* count(1:i-1, 1)) / n0;
    end
    if (n1 == 0)
        u1 = 0;
    else
        u1 = sum(count(i+1:238, 2) .* count(i+1:238, 1)) / n1;
    end
    
    g = w0 * w1 * (u0 - u1)^2;
    if g > max
        max = g;
        maxT = i;
    end
end

lena_3 = imbinarize(lena, maxT/256);

figure();
subplot(1, 3, 1);
imshow(lena);
title("Lena 原始图");

subplot(1, 3, 2);
imshow(lena_2, []);
title("Lena 二值分割图（调用函数实现）");

subplot(1, 3, 3);
imshow(lena_3, []);
title("Lena 二值分割图（自己实现）");