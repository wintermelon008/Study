clc;
clear;
close all;

% This is the lab for digital image courses
% Task 3 PART I
% noise 


lena = imread("./pics/lena.bmp");
[m, n] = size(lena);

% 产生均匀分布矩阵
y = uint8(floor(rand(m, n) * 255));

lena_salt = imnoise(lena,'salt & pepper',0.03);
lena_gauss = imnoise(lena,'gaussian', 0, 0.01);

z = uint8(xor(lena ,lena_salt));
z1 = uint8(~z);
% 添加随机噪声
lena_random = z1 .* lena + z .* y;




% 均值滤波
lena_salt_average  = filter2(fspecial('average',3), lena_salt);
lena_gauss_average  = filter2(fspecial('average',3), lena_gauss);
lena_random_average  = filter2(fspecial('average',3), lena_random);

% 阈限均值滤波
% 设置阈限为 35
T = 35;
lena_salt_dooraverage = lena_salt;
lena_gauss_dooraverage = lena_gauss;
lena_random_dooraverage = lena_random;
for i = 1: m
    for j = 1 : n
        z_salt = get_average(lena_salt, i, j, 1, m, n);
        if abs(int16(z_salt) - int16(lena_salt(i, j))) > int16(T)
            % 超出阈限
            lena_salt_dooraverage(i, j) = uint8(z_salt);
        end
        
        z_gauss = get_average(lena_gauss, i, j, 1, m, n);
        if abs(int16(z_gauss) - int16(lena_gauss(i, j))) > int16(T)
            % 超出阈限
            lena_gauss_dooraverage(i, j) = uint8(z_gauss);
        end
        
        z_random = get_average(lena_random, i, j, 1, m, n);
        if abs(int16(z_random) - int16(lena_random(i, j))) > int16(T)
            % 超出阈限
            lena_random_dooraverage(i, j) = uint8(z_random);
        end
    end
end


figure();
subplot(3, 4, 1);
imshow(lena);
title("Lena 原始图");

subplot(3, 4, 2);
imshow(uint8(lena_salt));
title("Lena 3% 椒盐噪声");

subplot(3, 4, 3);
imshow(uint8(lena_gauss));
title("Lena 高斯噪声");

subplot(3, 4, 4);
imshow(uint8(lena_random));
title("Lena 随机噪声");

subplot(3, 4, 5);
imshow(lena);
title("Lena 原始图");

subplot(3, 4, 6);
imshow(uint8(lena_salt_average));
title("Lena 3% 椒盐噪声（均值滤波）");

subplot(3, 4, 7);
imshow(uint8(lena_gauss_average));
title("Lena 高斯噪声（均值滤波）");

subplot(3, 4, 8);
imshow(uint8(lena_random_average));
title("Lena 随机噪声（均值滤波）");

subplot(3, 4, 9);
imshow(lena);
title("Lena 原始图");

subplot(3, 4, 10);
imshow(uint8(lena_salt_dooraverage));
title("Lena 3% 椒盐噪声（超限均值滤波）");

subplot(3, 4, 11);
imshow(uint8(lena_gauss_dooraverage));
title("Lena 高斯噪声（超限均值滤波）");

subplot(3, 4, 12);
imshow(uint8(lena_random_dooraverage));
title("Lena 随机噪声（超限均值滤波）");

% 邻域均值计算
function ave = get_average(C, x, y, r, m, n)
    ave = C(x, y);
    sum = 0;
    for i = -r : r : 1
        for j = -r : r : 1
            if x + i < 1 || x + i > m || y + j < 1 || y + j > n
                return;
            end
            sum = sum + int16(C(x + i, y + j));
        end
    end
    ave = floor(sum / (2 * r + 1)^2);
    return;
end

