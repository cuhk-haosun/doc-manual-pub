#########牛刀小试：将两个数据源绘制在同一个坐标系中############
set.seed(1234)
# 生成两列随机数
x1 <- rnorm(1000,0,1)
x2 <- rnorm(1000,2,1)
# 在ggplot()和geom_histgram()各设置一个数据源
ggplot(data = NULL,aes(x2)) +
  geom_line(stat = "density",color = "red") +
  geom_histogram(data = NULL, aes (x1, y = ..density..),
                 bins  = 30,color = "grey",fill = "yellow") +
  
  # 在geom_histgram()和geom_line()中各设置一个数据源
  ggplot() +
  geom_histogram(data= NULL,aes(x1,y = ..density..),
                 bins  = 30,color = "grey",fill = "yellow") +
  geom_line(data= NULL,aes(x2),stat = "density",color = "red")

