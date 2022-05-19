clc;
clear;
close all;

% This is the lab for digital image courses
% Task 5 PART III
% graph divide

cameraman=imread('./pics/cameraman.bmp');

S = qtdecomp(cameraman, .12);

blocks = repmat(uint8(0),size(S));



[m, n] = size(blocks);
one = ones(m, n);

for dim=[256 128 64 32 16 8 4 2 1]

    numblocks = length(find(S == dim));

    if(numblocks > 0)
        values = repmat(uint8(1), [dim dim numblocks]);
        values(2:dim, 2:dim, :) = 0;
        blocks = qtsetblk(blocks, S, dim, values);

        if (dim > 1) 
            blocks_fill = imfill(blocks);     
        else
            blocks_fill = blocks;
            break
        end
        temp = blocks_fill;

        for i = 1 : m
            for j = 1 : n
                   if (blocks_fill(i, j) == 1)
                       if check(blocks_fill, i, j) == 0
                           temp(i, j) = 0;
                       end
                   end
            end
        end      
        blocks = temp;     
        if (dim > 1) 
            blocks(1:n, m) = 1;
            blocks(n, 1:m) = 1;
        end
    end
end

S = qtdecomp(cameraman, .1);
blocks_1 = repmat(uint8(0),size(S));

for dim=[2 1]
    numblocks = length(find(S == dim));
    if(numblocks > 0)
        values = repmat(uint8(1), [dim dim numblocks]);
        values(2:dim, 2:dim, :) = 0;
        blocks_1 = qtsetblk(blocks_1, S, dim, values);
    end
end

S = qtdecomp(cameraman, .1);
blocks_2 = repmat(uint8(0),size(S));

for dim=[512 256 128 64 32 16 8 4 2 1]
    numblocks = length(find(S == dim));
    if(numblocks > 0)
        values = repmat(uint8(1), [dim dim numblocks]);
        values(2:dim, 2:dim, :) = 0;
        blocks_2 = qtsetblk(blocks_2, S, dim, values);
    end
end

figure();

subplot(2,2,1);
imshow(cameraman);
title('Cameraman 原始图');

subplot(2,2,2);
imshow(blocks_2,[]);
title('Cameraman 区域分解图');

subplot(2,2,3);
imshow(blocks,[]);
title('Cameraman 区域分解合成图 1');

subplot(2,2,4);
imshow(blocks_1,[]);
title('Cameraman 区域分解合成图 2');


function flag = check(A, i, j)
    flag = 1;
    [m, n] = size(A);
    if i == 1 || j == 1 || i == m || j == n
        return;
    end
    temp = A(i - 1, j - 1) * A(i - 1, j) * A(i - 1, j + 1)*A(i, j - 1)*A(i, j)*A(i, j + 1) * A(i + 1, j - 1) * A(i + 1, j) * A(i + 1, j + 1);
    if temp == 0
        return;
    end
    flag = 0;
    return;
end