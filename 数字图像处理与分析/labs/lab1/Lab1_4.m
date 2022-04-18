clc;
clear;
close all;


% This is the lab for digital image courses
% Task 1-4


origin = imread("./pics/alphabet2.jpg");
right = imread("./pics/alphabet1.jpg");

figure();
subplot(1, 2, 2);
imshow(right);
title("标准图像");

subplot(1, 2, 1);
imshow(origin);
title("变形图像");
text(160, -70,'请在变形图像中选取第一个点');
[x1, y1] = ginput(1);
delete(findobj('type','text'));

text(160, -70,'请在标准图像中选取对应点');
[x2, y2] = ginput(1);
delete(findobj('type','text'));

text(-160, -70,'请在变形图像中选取第二个点');
[x3, y3] = ginput(1);
delete(findobj('type','text'));

text(160, -70,'请在标准图像中选取对应点');
[x4, y4] = ginput(1);
delete(findobj('type','text'));

text(-160, -70,'请在变形图像中选取第三个点');
[x5, y5] = ginput(1);
delete(findobj('type','text'));

text(160, -70,'请在标准图像中选取对应点');
[x6, y6] = ginput(1);
delete(findobj('type','text'));

text(-160, -70,'请在变形图像中选取第四个点');
[x7, y7] = ginput(1);
delete(findobj('type','text'));

text(160, -70,'请在标准图像中选取对应点');
[x8, y8] = ginput(1);
delete(findobj('type','text'));
% 用户输入完成

% x1 = 1;
% y1 = 1;
% x2 = 1;
% y2 = 1;
% x3 = 224;
% y3 = 1;
% x4 = 236;
% y4 = 1;
% x5 = 1;
% y5 = 224;
% x6 = 1;
% y6 = 234;

Origin_points = [x1 y1; x3 y3; x5 y5; x7 y7];
Correct_points = [x2 y2; x4 y4; x6 y6; x8 y8];
Transform = fitgeotrans(Origin_points, Correct_points, 'projective');
after_image = imwarp(origin, Transform, 'bilinear');

% A = [1, x2, y2; 1, x4, y4; 1, x6, y6];
% X = [x1, x3, x5]';
% Y = [y1, y3, y5]';
% a = A\X; 
% b = A\Y;
% 
% a0 = a(1); a1 = a(2); a2 = a(3);
% b0 = b(1); b1 = b(2); b2 = b(3);
% 
% 
% [after_m, after_n, after_chanel] = size(right);
% after_image = zeros(after_m, after_n, after_chanel);
% for chanel = 1: after_chanel
%     for i = 1 : after_m - 1
%         for j = 1: after_n - 1
%             x_temp = a0 + a1 * i + a2 * j;
%             y_temp = b0 + b1 * i + b2 * j;
%             x_i = floor(x_temp);
%             y_i = floor(y_temp);
%             if (x_i < 1 || y_i < 1 )
%                 after_image(i, j, chanel) = origin(1, 1, chanel);
%                 continue
%             end
%             if (x_i >= after_m || y_i >= after_n)
%                 after_image(i, j, chanel) = origin(after_m, after_n, chanel);
%                 continue
%             end
%             x_f = x_temp - x_i;
%             y_f = y_temp - y_i;
% 
%             after_image(i, j, chanel) = origin(x_i, y_i, chanel)*(1-x_f)*(1-y_f) +  origin(x_i+1, y_i, chanel)*x_f*(1-y_f) + origin(x_i, y_i+1, chanel)*(1-x_f)*y_f + origin(x_i+1, y_i+1, chanel)*x_f*y_f;
%             %after_image(i, j, chanel) = 0.25 *(origin(x_i, y_i, chanel) + origin(x_i + 1, y_i, chanel) + origin(x_i, y_i + 1, chanel) + origin(x_i + 1, y_i + 1, chanel));
% %             if (x_f <= 0.5 && y_f <= 0.5)
% %                 after_image(i, j, chanel) = origin(x_i, y_i, chanel);
% %             elseif (x_f > 0.5 && y_f <= 0.5)
% %                 after_image(i, j, chanel) = origin(x_i + 1, y_i, chanel);
% %             elseif (x_f <= 0.5 && y_f > 0.5)
% %                 after_image(i, j, chanel) = origin(x_i, y_i + 1, chanel);
% %             else
% %                 after_image(i, j, chanel) = origin(x_i + 1, y_i + 1, chanel);
% %             end
%         end
%     end
% end

close all;
figure();
subplot(1, 2, 1);
imshow(origin);
title("原始图像");

subplot(1, 2, 2);
imshow(uint8(after_image));
title("修复图像");

