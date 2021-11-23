clc;clear;
%%% 本程序作用，输入大图和要等分的数量，裁剪成对应小图并保存到文件夹中

% 初始化，输入读取图片的名称，切割的W和H
name = "opt3952";
format = ".jpg"
W = 440;
H = 441;
% 输入要等分的个数，M是行方向、N是列方向，整数
% M = 行像素个数(h)/ 单个小图像素个数 如29210/256，再round取整
% N = 列像素个数(w)/ 单个小图像素个数 如30680/256，再round取整
M=39; N=40; 

result_dir = "result" +name+"000";
mkdir(result_dir);
resultPath = result_dir+"/";


% 读取SAR图像
% figure;
img = imread(name+format);


rgb=img;
[m,n,c]=size(rgb);
xb=round(m/M)*M;yb=round(n/N)*N; %找到能被整除的M,N
rgb=imresize(rgb,[xb,yb]);
[m,n,c]=size(rgb);
count =1;
for i=1:M
    for j=1:N
        % 分块
        block = rgb((i-1)*m/M+1:m/M*i,(j-1)*n/N+1:j*n/N,:); % 图像分成块
        % 写上要对每一块的操作
        imwrite (block, strcat(resultPath,'frame',num2str(count),'.jpg'));  
        count = count+1;
    end
end

