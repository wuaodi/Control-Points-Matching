%% 初始化：图片路径，闭操作窗口大小
index = "3952";
path = "D:\Alvin\datasets\高分数据\jpegimg\"+index+"\";
optical_name = "opt"+index;
sar_name = "sar"+index;
infrared_name = "inf"+index;
format = ".jpg";

%% 读入图片
optical_ori = imread(path+optical_name+format);
% optical = imresize(optical_ori,0.1); % 用缩放后得到的射影矩阵不能用于原图，会有一定的偏差
sar_ori = imread(path+sar_name+format);
infrared_ori = imread(path+infrared_name+format);



%% 交互方式选择控制点，选完后叉掉即可
% 选15-20对相同位置点，选的时候尽可能均匀分布在整张图片
disp("----------请人工选择15-20对控制点----------")
[op,sp] = cpselect(optical_ori,sar_ori, 'Wait' ,true);
disp("----------计算射影矩阵----------")
tic
t1 = fitgeotrans(op,sp,'projective');
save(index+".mat","t1") %保存t1到当前文件夹