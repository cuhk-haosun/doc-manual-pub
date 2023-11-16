
######牛刀小试:对矩阵各列使用不同的函数。##########
x <- matrix(1:20,nrow = 5,ncol = 4)
x
# 添加代表每列顺序的辅助行
x1 <- rbind(1:4,x)
x1

# 函数名称向量，其中“'*'”表示求乘积
funs <- c("mean","sd","range","'*'")
funs
library(plyr)
# 使用alply()函数
alply(x1,
      .margins = 2,# 选取按列计算
      .fun = function(x,funs.vec){# 匿名函数，用于选取funs中的函数
        if(x[1] != 4){ 
          eval(parse(text = paste0(funs[x[1]],"(x[-1])")))# 解析及计算表达式
        } else {
          eval(parse(text = paste0(funs[x[1]],"(x[-1],10)")))
        }
      },
      funs.vec = funs)

