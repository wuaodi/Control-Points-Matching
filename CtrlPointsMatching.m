%%% 本程序用来控制点的方法配准两张图像,并将配准后的图像裁剪重叠区域，裁剪后的图像保存在读入路径
%%% 通过交互方式选择控制点，计算projective矩阵，对图像进行变换
%%% 变换后的图像在对应像素位置表示的点相同
%% 初始化：图片路径，重叠区域掩膜闭操作窗口大小
path = "D:\Alvin\datasets\高分数据\jpegimg\3952\";
optical_name = "opt3952";
sar_name = "sar3952";
infrared_name = "inf3952";
format = ".jpg";
closesize = [200 200];

%% 读入图片
optical_ori = imread(path+optical_name+format);
% optical = imresize(optical_ori,0.1); % 用缩放后得到的射影矩阵不能用于原图，会有一定的偏差
sar_ori = imread(path+sar_name+format);
infrared_ori = imread(path+infrared_name+format);



%% 交互方式选择控制点，选完后叉掉即可
% 选15-20对相同位置点，选的时候尽可能均匀分布在整张图片
disp("----------请人工选择15-20对控制点----------")
[op,sp] = cpselect(optical_ori,sar_ori, 'Wait' ,true);


%% 对光学图像做变换
disp("----------计算射影矩阵，对光学图像做变换----------")
tic
t1 = fitgeotrans(op,sp,'projective');

% 图像变换
Rfixed = imref2d(size(sar_ori));
optical_trans = imwarp(optical_ori,t1,'OutputView',Rfixed);
infrared_trans = imwarp(infrared_ori,t1,'OutputView',Rfixed);

% 图像展示
figure; imshowpair(imresize(sar_ori,0.1),imresize(optical_trans,0.1),'blend')
toc


%% 找到重叠区域mask
disp("----------计算重叠区域mask----------")
tic
overlap_mask = ones(size(sar_ori)); % 初始化重叠区域mask，将非重叠置0，重叠区域置1
optical_sum = double(optical_trans(:,:,1)) ...
    + double(optical_trans(:,:,2)) ...
    + double(optical_trans(:,:,3)); % 将光学各个通道相加，尽量有内容的地方出现假黑色区域
sar_sum = double(sar_ori); % 转成double类型，计算方便

% 找到sar与optical_trans都是黑色的区域
addsaropt = sar_sum + optical_sum;
both_zero = find(addsaropt==0);
overlap_mask(both_zero) = 0;

% 找到有sar没有光学的区域
minussaropt = sar_sum - (sar_sum - optical_sum); % 值为0代表sar有东西，而光学区域为0
optical_zero = find(minussaropt==0);
overlap_mask(optical_zero) = 0;

% 找到有光学没有SAR的区域
minusoptsar = optical_sum - (optical_sum - sar_sum); % 值为0代表sar有东西，而光学区域为0
sar_zero = find(minusoptsar==0);
overlap_mask(sar_zero) = 0;

% 将非重叠区域置0
figure; imshow(imresize(overlap_mask,0.1))
SE = strel('rectangle',closesize); % 这里的阈值可以修改
overlap_mask = imclose(overlap_mask,SE); % 闭操作滤除重叠区域的错误点
figure, imshow(imresize(overlap_mask,0.1))
toc


%% 利用重叠区域msak裁剪原图
disp("----------利用重叠区域msak裁剪原图并写入文件夹----------")
tic
overlap_mask = uint8(overlap_mask); % 与图片格式相同类型才能点乘运算
sar_final = sar_ori.*overlap_mask;
optical_final = optical_trans.*overlap_mask;
infrared_final = infrared_trans.*overlap_mask;
figure; imshow(imresize(sar_final,0.1))
figure; imshow(imresize(optical_final,0.1))
figure; imshow(imresize(infrared_final,0.1))
imwrite(optical_final,path+optical_name+"final.jpg");
imwrite(sar_final,path+sar_name+"final.jpg");
imwrite(infrared_final,path+infrared_name+"final.jpg");
toc