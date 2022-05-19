clc;
clear;
close all;

% This is the lab for digital image courses
% Task 5 PART III
% graph divide
cameraman=imread('./pics/cameraman.bmp');
S = qtdecomp(cameraman, .2,2);
blocks = repmat(uint8(0),size(S));

for dim=[2]
    numblocks = length(find(S == dim));
    if(numblocks > 0)
        values = repmat(uint8(1), [dim dim numblocks]);
        values(2:dim, 2:dim, :) = 0;
        blocks = qtsetblk(blocks, S, dim, values);
    end
end

figure();

subplot(1,2,1);

imshow(cameraman);

title('Cameraman 原始图');

subplot(1,2,2);

imshow(blocks,[]);

title('Cameraman 分解图');