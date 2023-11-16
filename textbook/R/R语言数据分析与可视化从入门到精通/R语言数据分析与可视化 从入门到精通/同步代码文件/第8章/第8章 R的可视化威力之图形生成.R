#######第8章 R君的可视化威力之图形生成##########

#########8.2 单变量及双变量绘图#############

#########8.2.1 散点图#######

library(ggplot2)
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point()

ggplot() + 
  geom_point(data = mtcars,aes(x = wt,y = mpg),shape = 2,col = "red")

ggplot() + 
  geom_point(data = mtcars,aes(x = wt,y = mpg),shape = 24,col = "red",fill ="black")

# 拟合一条直线
ggplot(mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  stat_smooth(method ="lm",level=0.95 )

# 拟合一条平滑曲线
ggplot(mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  stat_smooth(method ="loess",level=0.95 )

# 将am转换为因子
mtcars1 <- mtcars
mtcars1$am <- factor(mtcars1$am)

# 将am映射给形状
ggplot(mtcars1,aes(x = wt,y = mpg,shape= am)) + 
  geom_point() 

# 将am映射给颜色
ggplot(mtcars1,aes(x = wt,y = mpg,col= am)) + 
  geom_point() 

# 将am映射给形状，并添加线性回归直线
ggplot(mtcars1,aes(x = wt,y = mpg,shape= am)) +
  geom_point() +
  stat_smooth(method ="lm",level=0.95 )

# 将am映射给颜色，并添加线性回归直线
ggplot(mtcars1,aes(x = wt,y = mpg,col= am)) +
  geom_point() +
  stat_smooth(method ="lm",level=0.95 )

# 设置随机种子
set.seed(123)

# 生成10个随机并重复10次
x<- rep(round(rnorm(10,0,1),digits = 2),10)
x
# 单变量散点图
stripchart(x)

# 对单变量散点图添加上下扰动
stripchart(x,method = "jitter")


######8.2.2 折线图 ###########
# 为了使用汇总函数
library(dplyr)
data1 <- mtcars %>% 
  group_by(carb) %>% 
  summarize_at(.vars = "mpg",.funs = mean) 

# 绘制简单折线图
ggplot(data1,aes(x = carb,y = mpg)) +
  geom_line() 

# 根据变量carb汇中数据后，将carb变为字符串
data2 <- mtcars %>% 
  group_by(carb) %>% 
  summarize_at(.vars = "mpg",.funs = mean) %>% 
  mutate(carb = as.character(carb))

# 当x轴变量为离散型数据且未指定aes(group = 1)时将无法画出正确的图
ggplot(data2,aes(x = carb,y = mpg)) + 
  geom_line() 

# 绘制x变量为离散型数据时的简单折线图
ggplot(data2,aes(x = carb,y = mpg,group = 1)) + 
  geom_line() + 
  geom_point(shape =22,size = 2)

data3 <- mtcars %>% 
  group_by(am,cyl) %>% 
  summarize_at(.vars = "mpg",.funs = mean) %>% 
  ungroup() %>% 
  mutate(am = as.character(am)) 

# 将am映射给线型
ggplot(data3,aes(x = cyl,y = mpg,linetype = am )) + 
  geom_line()

# 将am映射给线条颜色
ggplot(data3,aes(x = cyl,y = mpg,color = am )) + 
  geom_line()

#########8.2.3 条形图#########

# 使用car扩展包中的Salaries数据集
library(car)

# 该大学教员职称构成情况
data1 <- as.data.frame(table(Salaries$rank)) %>% 
  setNames(c("Rank","Num"))

# 该大学教员性别构成情况
data2 <- as.data.frame(table(Salaries$sex)) %>% 
  setNames(c("Sex","Num"))

# 绘制大学教员职称构成的条形图
ggplot(data1,aes(x = Rank,y = Num)) + 
  geom_bar(stat = "identity")

# 绘制大学教员性别构成的条形图,并指定条形的颜色
ggplot(data2,aes(x = Sex,y = Num)) + 
  geom_bar(stat = "identity", color = "black",fill = "green")

# 另外种方法绘制大学教员职称构成的条形图
ggplot(Salaries,aes(x = rank)) + 
  geom_bar(stat = "count")

# 不同职称和性别教员的平均工资
data3 <- Salaries %>% 
  group_by(rank,sex) %>% 
  summarise_at(.vars = "salary",.funs = mean)

# 绘制簇状条形图
ggplot(data3,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge")

图8-11    关于不同职称和性别教员的平均工资簇状条形图

而对于堆积条形图，position参数要设置为“stack”（默认），见图8-12。实现代码如下：
# 绘制堆积条形图
ggplot(data3,aes(x = rank,y = salary,fill = sex)) + 
  geom_bar(stat = "identity",position = "stack")

# 或者不指定position参数的具体值，因为position = "stack"是默认设置

data3 <- data3 %>% 
  group_by(rank) %>% 
  mutate(salary_percent = salary/sum(salary) *100)

# 绘制堆积条形图
# 或者不指定position参数的具体值，因为position = "stack"是默认设置
ggplot(data3,aes(x = rank,y = salary_percent,fill = sex)) + 
  geom_bar(stat = "identity",position = "stack")

########8.2.4 饼图 ###########3
# 绘制大学教员职称构成的饼图
data1 <- as.data.frame(table(Salaries$rank)) %>% 
  setNames(c("Rank","Num")) %>% 
  mutate(Ratio = Num/sum(Num) *100 )
ggplot(data1,aes(x = "",y = Ratio,fill = Rank)) + 
  geom_bar(stat = "identity",width=0.5,position = "stack") + 
  coord_polar(theta = "y")


# 绘制大学教员职称构成的3D饼图
library(plotrix)
pie3D(x = data1$Ratio,labels = data1$Rank,
      col = c("burlywood","turquoise","gold"),explode = 0.1,
      labelcex = 0.95,radius = 0.9,mar = c(1,1,1,1))

# 绘制大学教员职称构成的扇形图
fan.plot(x = data1$Ratio,labels = as.character(data1$Rank),
         max.span=pi,col = c("burlywood","turquoise","gold"),
         ticks = 100 )

##########8.2.5 箱线图###########

# 获取MathAchieve数据集
library(nlme)

# 绘制简单箱线图
ggplot(MathAchieve,aes(x = 0,y = MathAch)) + 
  geom_boxplot(width=0.5) + 
  xlim(-1,1) + 
  theme(axis.text.x = element_blank(),axis.title.x = element_blank())


# 将学生按其SES大小分组
data1 <- MathAchieve
data1$SES1 <- cut(data1$SES,
                  breaks = c(min(data1$SES),-1,0,1,max(data1$SES)),
                  labels = c("SES(低于-1)","SES(-1~0)",
                             "SES(0~1)","SES(高于1)"),
                  include.lowest = T,right = T)
# 绘制多组比较的箱线图
ggplot(data1,aes(x = SES1 ,y = MathAch,fill =SES1)) + 
  geom_boxplot()

# 向箱线图中添加凹槽和平均值点，同时移除图例
ggplot(data1,aes(x = SES1 ,y = MathAch,fill =SES1)) + 
  geom_boxplot(notch = TRUE,show.legend = FALSE) + 
  stat_summary(fun.y = "mean",geom = "point",shape = 15,
               size = 2,color = "red", show.legend = FALSE)
########8.2.6 直方图和核密度图##########

# 为了获得MathAchieve数据集
library(nlme)

# 绘制学生的数学成就测验成绩的分布直方图
ggplot(MathAchieve,aes(x = MathAch )) + 
  geom_histogram()
`stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

# 优化学生的数学成就测验成绩的分布直方图
ggplot(data = NULL,aes(x = MathAchieve$MathAch)) + 
  geom_histogram(bins= 20,col = "black",fill = "lightblue")

# 在直方图上叠加核密度曲线
ggplot(MathAchieve,aes(x = MathAch,y =..density..)) + 
  geom_histogram(bins= 20,col = "black",fill = "lightblue",size = 0.2) + 
  geom_density(size = 1) +
  xlim(-10,30)

# 基于分组数据的核密度曲线
ggplot(MathAchieve,aes(x = MathAch,color = Sex)) + 
  geom_line(stat = "density")


#########8.3 多变量绘图#########

#############8.3.1 气泡图########

# 绘制气泡图
ggplot(trees,aes(x = Girth,y = Height,size = Volume)) +
  geom_point(shape = 21,fill = "steelblue",color = "burlywood",alpha = 0.5)

# 绘制气泡图（将变量映射给气泡的面积）
ggplot(trees,aes(x = Girth,y = Height,size = Volume)) +
  geom_point(shape = 21,fill = "steelblue",color = "black",alpha = 0.5) +
  scale_size_area(max_size = 10)

symbols(x = trees$Girth,y = trees$Height,circles = sqrt(trees$Volume),
        bg= "red",fg = "black",inches = 0.2,
        xlab = "Girth",ylab = "Height" )

########8.3.2 热图##################
# 为了获取coalash数据集
library(sm)
head(coalash)
# 用geom_raster()函数绘制热图
ggplot(coalash,aes(x = East,y = North,fill = Percent)) +
  geom_raster() +
  scale_fill_gradient(low = "blue",high = "red")

library(lattice)
# 用levelplot()函数绘制热图
attach(coalash)
levelplot(Percent ~ East * North,col.regions = gray(0:50/50))

########8.3.3 马赛克图##############

# HairEyeColor数据结构
str(HairEyeColor)

# 展示原始的HairEyeColor数据集
HairEyeColor

# 以“平铺”的方式展示HairEyeColor数据集
ftable(HairEyeColor)
# 使用mosaicplot()函数绘制马赛克图
mosaicplot(~ Hair + Eye + Sex, data = HairEyeColor, color = 6:7)

library(vcd)
# 使用mosaic()函数绘制基础马赛克图
mosaic(~ Hair + Eye + Sex,data = HairEyeColor, 
       labeling_args=list(gp_labels=gpar(fontsize=10)))

# 美化mosaic()函数绘制的马赛克图
mosaic(~ Hair + Eye + Sex,data = HairEyeColor, 
       labeling_args=list(gp_labels=gpar(fontsize=10)),
       highlighting= "Sex",
       highlighting_fill = c("slateblue2","skyblue2"),
       direction = c("v","h","v"))

############8.3.4 相关矩阵图##############3

# 抽取mtcars中部分变量
data1 <- mtcars[,c("mpg","disp","hp","drat","wt","qsec")]
# 绘制散点图矩阵
library(car)
scatterplotMatrix(~ mpg + disp + hp + drat + wt + qsec,
                  data = data1,
                  diagonal = list(method ="histogram", breaks="FD"),
                  smooth = FALSE)

# 计算相关矩阵
cor_data1 <- cor(data1)
# 绘制相关矩阵图
library(corrplot)
par(mfrow = c(2,2)) # 绘图布局，具体参见第9章
corrplot(cor_data1) # method的默认值：“circle”
corrplot(cor_data1,method = "number",tl.srt = 45)
corrplot(cor_data1,method = "color",tl.srt = 45,order = "AOE")
corrplot(cor_data1,method = "square",type = "lower",tl.srt = 45,order = "AOE",diag = FALSE)

############8.3.5 三维散点图###########

# 用cloud()函数绘制三维散点图
library(lattice)
cloud(Height ~ Girth * Volume,
      data = trees, cex = .8,
      screen = list(z = 20, x = -70, y = 0),
      par.settings = list(axis.line = list(col = "transparent")))

# 用plot3d()函数绘制三维散点图
library(rgl)
plot3d(x = trees$Height,
       y = trees$Girth,
       z = trees$Volume,
       xlab = "Height",ylab = "Girth",zlab = "Volume",
       type = "s",size =1)




