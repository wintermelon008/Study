clc;
clear;
close all;

% This is the lab for digital image courses
% Task 3 PART II
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



% 中值滤波
lena_salt_middle  = medfilt2(lena_salt,[3 3]);
lena_gauss_middle  = medfilt2(lena_gauss,[3 3]);
lena_random_middle  = medfilt2(lena_random,[3 3]);

% 阈限中值滤波
% 设置阈限为 35
T = 35;
lena_salt_doormiddle = lena_salt;
lena_gauss_doormiddle = lena_gauss;
lena_random_doormiddle = lena_random;
for i = 1: m
    for j = 1 : n
        z_salt = get_middle(lena_salt, i, j, 1, m, n);
        if abs(int16(z_salt) - int16(lena_salt(i, j))) > int16(T)
            % 超出阈限
            lena_salt_doormiddle(i, j) = uint8(z_salt);
        end
        
        z_gauss = get_middle(lena_gauss, i, j, 1, m, n);
        if abs(int16(z_gauss) - int16(lena_gauss(i, j))) > int16(T)
            % 超出阈限
            lena_gauss_doormiddle(i, j) = uint8(z_gauss);
        end
        
        z_random = get_middle(lena_random, i, j, 1, m, n);
        if abs(int16(z_random) - int16(lena_random(i, j))) > int16(T)
            % 超出阈限
            lena_random_doormiddle(i, j) = uint8(z_random);
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
imshow(uint8(lena_salt_middle));
title("Lena 3% 椒盐噪声（中值滤波）");

subplot(3, 4, 7);
imshow(uint8(lena_gauss_middle));
title("Lena 高斯噪声（中值滤波）");

subplot(3, 4, 8);
imshow(uint8(lena_random_middle));
title("Lena 随机噪声（中值滤波）");

subplot(3, 4, 9);
imshow(lena);
title("Lena 原始图");

subplot(3, 4, 10);
imshow(uint8(lena_salt_doormiddle));
title("Lena 3% 椒盐噪声（超限中值滤波）");

subplot(3, 4, 11);
imshow(uint8(lena_gauss_doormiddle));
title("Lena 高斯噪声（超限中值滤波）");

subplot(3, 4, 12);
imshow(uint8(lena_random_doormiddle));
title("Lena 随机噪声（超限中值滤波）");

% 邻域中值计算
function mid = get_middle(C, x, y, r, m, n)
    mid = C(x, y);
    for i = -r : r : 1
        for j = -r : r : 1
            if x + i < 1 || x + i > m || y + j < 1 || y + j > n
                return;
            end
        end
    end
    S = sort(C(x-r : x+r, y-r : y+r));
    mid = S(r + 1, r + 1);
    return;
end

