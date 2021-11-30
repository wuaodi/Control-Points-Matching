clc;clear;

XX = "3950";

%% 重定义图片的名字大小和格式
% strcat()函数经常出现在批量处理的时候，这个时候我们需要用到for循环，
% 然后这个函数能够让变量和路径产生一些关系，这个时候我们就可以对其进行批量处理。
imagePath1 = strcat('D:\Alvin\datasets\高分数据\jpegimg\',XX,'\','opt',XX,'final\');    % 原光学图像位置
imagePathsar1 = strcat('D:\Alvin\datasets\高分数据\jpegimg\',XX,'\','sar',XX,'final\');  % 原sar图像位置
imagePathinf1 = strcat('D:\Alvin\datasets\高分数据\jpegimg\',XX,'\','inf',XX,'final\');  % 原红外图像位置

mkdir(strcat('D:\Alvin\datasets\高分数据清洗\jpegimg\',XX,'\','opt',XX,'final\'));
mkdir(strcat('D:\Alvin\datasets\高分数据清洗\jpegimg\',XX,'\','sar',XX,'final\'));
mkdir(strcat('D:\Alvin\datasets\高分数据清洗\jpegimg\',XX,'\','inf',XX,'final\'));
imagePath2 = strcat('D:\Alvin\datasets\高分数据清洗\jpegimg\',XX,'\','opt',XX,'final\');    % 重定义后光学图像位置
imagePathsar2 = strcat('D:\Alvin\datasets\高分数据清洗\jpegimg\',XX,'\','sar',XX,'final\');    % 重定义后sar图像位置
imagePathinf2 = strcat('D:\Alvin\datasets\高分数据清洗\jpegimg\',XX,'\','inf',XX,'final\');    % 重定义后红外图像位置


imageFiles = dir(imagePath1);    % 列出当前文件夹中的文件和文件夹  
numFiles = length(imageFiles);    % 获取图片的数量+2的值

%% 方法一，图片顺序可能会乱
tic
for i = 3:numFiles    % matlab 并行 其实和 for 一个用法               
    j = i-2;    % imageFiles 从第三项开始才是图片名字
    disp(j);    % disp() 函数直接将内容输出在 Matlab 命令窗口中  
    imageFile = strcat(imagePath1,imageFiles(i).name);    % 连接字符串，图片名称
    A = imread(imageFile);    % 读入图片  
    imgid = split(imageFile,"_");
    imgid = imgid(2);
    sarname = strcat(imagePathsar1,'sar',XX,'final_',imgid);
    infname = strcat(imagePathinf1,'inf',XX,'final_',imgid);
    B = imread(sarname); 
    C = imread(infname); 
    if sum(A , 'all') ~= 0
        imwrite (A, strcat(imagePath2,imageFiles(i).name));
        imwrite (B, strcat(imagePathsar2,'sar',XX,'final_',imgid));
        imwrite (C, strcat(imagePathinf2,'inf',XX,'final_',imgid));
    end     
end 
toc