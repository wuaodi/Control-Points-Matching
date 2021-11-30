# Control-Points-Matching
通过控制点在matlab中配准光学和sar图像

所有程序使用matlab运行,可能需要修改路径

cut.m 按照等分将图片裁剪成小图,例如将一张大图裁成10*10个小图

cut_nem.m 按照给定小图大小将大图裁成一定数量的小图,右侧和下侧最后剩余的小部分边会被舍弃

CtrlPointsMatching.m 交互的方式进行控制点配准与配准区域的裁剪

hjy.m 交互方式配准,输出变换矩阵t

batchtrans.m 根据变换矩阵t对图像进行变换,输出变换后的配准区域

removeblack.m 根据光学图像，删除文件夹中全黑的图像，并删除sar与红外文件夹中对应的图像
