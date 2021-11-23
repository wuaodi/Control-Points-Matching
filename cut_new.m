clc;clear;
%%% 本程序作用，输入大图和要裁剪的小图尺寸，裁剪成对应小图并保存到文件夹中，如果不能够整除，则舍弃右边和下边边缘



main("3952");

function main(index)
% 初始化，输入读取图片的名称，切割的W和H
path = "D:\Alvin\datasets\高分数据\jpegimg\"+index+"\"; %图片路径
optname = "opt"+index+"final"; %图片名称
sarname = "sar"+index+"final"; %图片名称
infname = "inf"+index+"final"; %图片名称
format = ".jpg"; %图片格式
W = 1024; %小图宽，可以有小数
H = 1024; %小图高，可以有小数

cutimg(path, optname, format, W, H);
cutimg(path, sarname, format, W, H);
cutimg(path, infname, format, W, H);

disp
end

function cutimg(path, name, format, W, H)
% path = "D:\Alvin\datasets\高分数据\jpegimg\3950\" %图片路径
% name = "inf3950final"; %图片名称
% format = ".jpg" %图片格式
% W = 1024; %小图宽，可以有小数
% H = 1024; %小图高，可以有小数

result_dir = path + name;
mkdir(result_dir);
resultPath = result_dir+"\"; %自动在读入图片的路径创建一个保存结果的文件夹


% 读取图像
figure;
img = imread(path+name+format);
imshow(img);
hold on;
title("切割示意图","FontSize",16,"FontWeight","bold","Color","b")


% 切割与保存图像
[m,n,~] = size(img);     % h*w*c
M = floor(m/H); % H方向切割块数的值
N = floor(n/W); % W方向切割块数的值

for i=0:N
    plot([round(W*i),round(W*i)],[1,round(H*M)],"-r","LineWidth",2)
end

for i=0:M
    plot([1,round(W*N)],[round(H*i),round(H*i)],"-r","LineWidth",2)
end


count =1;
for i=1:M
    for j=1:N
        % 分块
        block = img(round((i-1)*H)+1:round(i*H),round((j-1)*W)+1:round(j*W),:); % 图像分成块
        % 写上要对每一块的操作
        imwrite (block, strcat(resultPath,name,"_",num2str(count),".jpg"));  
        count = count+1;
    end
end

end

