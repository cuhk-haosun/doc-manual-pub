######第9章 R君的可视化威力之图形优化########
#######9.1 添加图形元素#####
########9.1.1 坐标轴#########

# 默认坐标轴范围的散点图
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point()

# 改变了x轴范围的散点图
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  xlim(0,4)

# 改变了y轴范围的散点图
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  ylim(10,25)

# 获取MathAchieve数据集
library(nlme)
head(MathAchieve)

# 将学生按其SES大小分组
data1 <- MathAchieve
data1$SES1 <- cut(data1$SES,
                  breaks = c(min(data1$SES),-1,0,1,max(data1$SES)),
                  labels = c("SES(低于-1)","SES(-1~0)",
                             "SES(0~1)","SES(高于1)"),
                  include.lowest = TRUE,right = TRUE)

# 绘制默认坐标轴范围的分组箱线图
ggplot(data1,aes(x = SES1 ,y = MathAch,fill =SES1)) + 
  geom_boxplot() +
  guides(fill = FALSE)  # 移除图例，见9.1.2节

# 用修改标度的方法修改y轴的范围
ggplot(data1,aes(x = SES1 ,y = MathAch,fill =SES1)) + 
  geom_boxplot() +
  guides(fill = FALSE) +
  ylim(15,20) 

# 用坐标变换的方法修改y轴的范围
ggplot(data1,aes(x = SES1 ,y = MathAch,fill =SES1)) + 
  geom_boxplot() +
  guides(fill = FALSE) +
  coord_cartesian(ylim = c(15,25))

# 移除刻度线
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  theme(axis.ticks = element_blank())

# 移除刻度线标签
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  theme(axis.text = element_blank())

# 修改刻度线
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() + 
  scale_y_continuous(breaks = c(15,20,25)) 

# 修改刻度线标签格式
windowsFonts(myFont = windowsFont("华文楷体")) 
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() + 
  scale_y_continuous(breaks = c(15,20,25),
                     labels = c("低","中","高")) +
  theme(axis.text.y = element_text(family = "myFont",
                                   face = "bold",
                                   color = "red",
                                   size = rel(2),
                                   angle = 45))


# 移除坐标轴标签
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  theme(axis.title = element_blank())

# 修改坐标轴标签
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  xlab("WT") +
  ylab("MPG")

# 修改坐标轴标签格式
windowsFonts(myFont = windowsFont("华文楷体")) 
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() + 
  theme(axis.title = element_text(family = "myFont",
                                  face = "bold",
                                  color = "red",
                                  size = rel(2)))


########9.1.2 图例#######

# 通过guide()移除图例
ggplot(data1,aes(x = SES1 ,y = MathAch,color = SES1)) + 
  geom_boxplot() +
  guides(color = FALSE)

# 通过scale_fill_discrete()移除图例
ggplot(data1,aes(x = SES1 ,y = MathAch,fill = SES1)) + 
  geom_boxplot() +
  scale_fill_discrete(guide = FALSE)

# 使用car扩展包中的Salaries数据集
library(car)

# 不同职称和性别教员的平均工资
data <- Salaries %>% 
  group_by(rank,sex) %>% 
  summarise_at(.vars = "salary",.funs = mean)

# 将图例放在坐标系统外的顶部
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  theme(legend.position = "top")

# 将图例放在坐标系统外的底部
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  theme(legend.position = "bottom")

# 将图例放在坐标系统内的左上部分
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  theme(legend.position = c(0.2,0.9))

# 将图例放在坐标系统内的左上部分并进一步将图例背景和边框颜色设为透明
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  theme(legend.position = c(0.2,0.8),
        legend.background = element_blank(),
        legend.key = element_blank())
# 移除图例标题
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  guides(fill = guide_legend(title = NULL))

# 改变图例标题
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  guides(fill = guide_legend(title = "Gender"))

# 改变图例标签
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  scale_fill_discrete(labels = c("Women","Men"))

#######9.1.3 文本注解#########

# 为了使用汇总函数
library(dplyr)
data <- mtcars %>% 
  group_by(carb) %>% 
  summarize_at(.vars = "mpg",.funs = mean) 

# 用geom_text()函数添加文本注释
ggplot(data,aes(x = carb,y = mpg,label = round(mpg,digits = 1))) +
  geom_line() +
  geom_text(vjust = -0.5,size = 5)

# 用annotate()函数添加文本注释
ggplot(data,aes(x = carb,y = mpg)) +
  geom_line() +
  geom_text(x = 5,y = 20,label = "拥有不同数量化油器\n汽车的平均油耗",
            vjust = -0.5,size = 5)

# 添加标准正态累积分布函数表达式
ggplot(data.frame(x = c(-3,3)),aes(x = x)) + 
  stat_function(fun = pnorm) +  # 绘制标准正态累积分布曲线
  annotate("text",x = 1.5,y = 0.5,
           parse = TRUE,
           label = "integral(frac(1,sqrt(2 * pi))* 
           e ^ {frac(-x ^ 2 , 2)},-infinity,a)",
           size = 10)

########9.1.4 标题#########

# 为了使用car扩展包中的Salaries数据集
library(car)

# 为了使用分组汇总函数
library(dplyr)
data <- Salaries %>% 
  group_by(rank,sex) %>% 
  summarise_at(.vars = "salary",.funs = mean)

# 用ggtitle()添加图形标题
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  ggtitle("不同职称和性别教员的平均工资")

# 用添加文本注释的方法添加图形标题
ggplot(data,aes(x = rank,y = salary,fill = sex)) +
  geom_bar(stat = "identity",position = "dodge") +
  annotate("text",x = 2,y = Inf,
           label = "不同职称和性别教员的平均工资",
           vjust = 1)


#########9.1.5 参考线 ######
# 绘制分组散点图
ggplot(mtcars,aes(x = wt ,y = mpg,color = factor(am))) +
  geom_point()

# 添加穿过平均值的横纵参考线
data <- mtcars
data$am <- factor(data$am)
means1<- data.frame(wt = mean(data$wt),mpg = mean(data$mpg))
ggplot(data,aes(x = wt ,y = mpg,color = am)) +
  geom_point() +
  geom_vline(xintercept = means1$wt,color = "red") +
  geom_hline(yintercept = means1$mpg,color = "red")

# 添加穿过分组平均值的横纵参考线
library(dplyr) # 为了使用分组和汇总函数
means2 <- data %>%
  group_by(am) %>% 
  summarize_at(.vars = c("wt","mpg"),.funs = mean)
ggplot(data,aes(x = wt ,y = mpg,color = am)) +
  geom_point() +
  geom_vline(data = means2,aes(xintercept = wt,color = am,
                               linetype = am)) +
  geom_hline(data = means2,aes(yintercept = mpg,color = am,
                               linetype = am))

# 添加一条有角度的参考线
fit <- lm(mpg ~ wt,data = data) # 线性回归
ggplot(data,aes(x = wt ,y = mpg,color = am)) +
  geom_point() +
  geom_abline(intercept = fit$coefficients[1],slope = fit$coefficients[2])


##########9.1.6 线段和带箭头的线段#######

# 获取MathAchieve数据集
library(nlme)

# 为了使用arrow()函数和unit()函数
library(grid)

# 添加线段和带箭头的线段
five_num <- fivenum(MathAchieve$MathAch)
ggplot(MathAchieve,aes(x = 0,y = MathAch)) + 
  geom_boxplot(width=0.5) + 
  xlim(-1,1) + 
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank()) +
  annotate("segment",x = -0.3,xend = -0.3,
           y = five_num[2],yend = five_num[4]) +
  annotate("text",x = -0.5,y = five_num[3],
           label = "这是\n四分位差") +
  annotate("segment",x = 0.3,xend = 0.3,
           y = five_num[2],yend = five_num[4],
           arrow = arrow(ends = "both",angle = 90,
                         length = unit(0.2,"cm"))) +
  annotate("text",x = 0.5,y = five_num[3],
           label = "这也是\n四分位差",color = "red") +
  annotate("segment",x = 0.6,xend = 0.05,
           y = 20,yend = max(MathAchieve$MathAch),
           arrow = arrow(ends = "last",length = unit(0.2,"cm")),
           color = "blue",size = 1) + 
  annotate("text",x = 0.7,y = 19,label = "上边缘值",
           color = "purple4") +
  annotate("segment",x = 0.6,xend = 0.05,
           y = 2.5,yend = min(MathAchieve$MathAch),
           arrow = arrow(ends = "last",length = unit(0.2,"cm")),
           color = "skyblue4",size = 1) + 
  annotate("text",x = 0.7,y = 3.5,
           label = "下边缘值",color = "lightsteelblue") 


########9.1.7 矩形阴影#########

ggplot(data.frame(x = c(-3,3)),aes(x = x)) + 
  stat_function(fun = dnorm,
                size = 2,
                alpha = 0.1) +  # 绘制标准正态分布密度曲线
  scale_x_continuous(breaks = seq(-3,3,by = 1)) +
  annotate("rect",xmin = -1,xmax = 1,
           ymin = -Inf,ymax = Inf,
           fill = "orange",alpha = 0.2)

#######9.2 控制图形外观########

############9.2.1 整体外观##########

# 带有灰色背景和白色网格线的默认主题
# 与theme_grey()或theme_gray()一样
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point()

# 经典暗光主题
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  theme_bw()

# 白色背景上只有各种宽度的黑色线条的主题
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  theme_linedraw()

# 只有x轴和y轴的主题
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() +
  theme_classic()

theme_get()$line
theme_get()$axis.title.x
# 保存当前主题以便还原
old_theme <- theme_get()

# 设计主题1
theme_set(theme_classic())
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point()

# 设计主题2
theme_update(axis.ticks = element_blank(),
             axis.text = element_text(color = "red"),
             axis.title = element_text(color = "blue"),
             line = element_line(linetype = "dashed"))
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point()

# 还原主题
theme_set(old_theme)


#####9.2.3 文本#######

mtcars1 <- mtcars
mtcars1$am <- factor(mtcars1$am)
# 使用电脑中安装的字体
windowsFonts(myFont = windowsFont("微软雅黑")) 

# 绘制基本图形
ggplot(mtcars1,aes(x = wt,y = mpg, col = am)) + 
  geom_point() +
  stat_smooth(method ="lm",level=0.95 ) +
  ggtitle("油耗指数对车重的回归")

# 控制基本图形中的文本元素 
ggplot(mtcars1,aes(x = wt,y = mpg, col = am)) + 
  geom_point() +
  stat_smooth(method ="lm",level=0.95 ) +
  ggtitle("油耗指数对车重的回归") +
  theme(plot.title = element_text(size = rel(2),color = "red",
                                  family = "myFont",
                                  face = "italic",
                                  hjust = 0.5,vjust = 0.2),
        legend.title = element_text(face ="bold"),
        axis.title.x = element_text(size = rel(1.5),color = "green",
                                    family = "serif",
                                    face = "bold"),
        axis.title.y = element_text(size = rel(1.5),color = "orange",
                                    family = "sans",
                                    face = "bold"))


########9.2.4 矩形#######

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +
  theme(panel.background = element_rect(fill = "grey30"),
        plot.margin = margin(1, 1, 1 , 1, "cm"),
        plot.background = element_rect(fill = "grey90",
                                       colour = "black", 
                                       size = 10))


####9.3 图形配色与布局#######
#######9.3.1 颜色与调色板########

# 已命名颜色的数量
length(colors())
# 查看已命名颜色的前20种颜色
colors()[1:20]
rgb(red = 0 ,green = 0,blue = 255,maxColorValue = 255)
col2rgb("blue")
hsv(0,1,1)
rgb2hsv(245,56,87)

grey(0.56)
convertColor(color = c(255,0,0),from = "sRGB",to = "Luv")
# 彩虹色渐进变化 
rainbow(n = 10)
# “白-橙-红”渐进变化
heat.colors(n = 6)

# “白-棕-绿”渐进变化
terrain.colors(n = 8)
# “白-棕-绿-蓝”渐进变化
topo.colors(n = 7)
# “浅蓝-白-浅红”渐进变化
cm.colors(n = 9)
# 灰度渐进变化
gray.colors(n = 4)
# 查看当前调色板
palette() # 一般为默认调色板

#  改变调色板
palette(rainbow(n = 7))
palette()

# 使用调色板颜色
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point(col = 7)

# 还原默认调色板
palette("default")
library(RColorBrewer)
# 查看RColorBrewer扩展包的所有调色板
display.brewer.all()

mtcars1 <- mtcars
mtcars1$gear <- factor(mtcars1$gear)
# 使用scale_color_hue()调色板
ggplot(data = mtcars1,aes(x = wt,y = mpg,color = gear)) + 
  geom_point() + 
  scale_color_hue() +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_hue()调色板")

# 使用scale_color_grey()调色板
ggplot(data = mtcars1,aes(x = wt,y = mpg,color = gear)) + 
  geom_point() + 
  scale_color_grey() +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_grey()调色板")

# 使用scale_color_brewer()调色板
ggplot(data = mtcars1,aes(x = wt,y = mpg,color = gear)) + 
  geom_point() + 
  scale_color_brewer(palette = "Accent") +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_brewer()调色板")

# 使用scale_color_manual()调色板
ggplot(data = mtcars1,aes(x = wt,y = mpg,color = gear)) + 
  geom_point() + 
  scale_color_manual(values =  c("#CC6666","#7777DD","#88FF88")) +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_namual()调色板")

# 使用默认调色板
ggplot(data = mtcars,aes(x = wt,y = mpg,color = carb)) + 
  geom_point() + 
  annotate("text",x = 4,y = 30,size = 5,
           label = "默认调色板")

# 使用scale_color_gradient()调色板
ggplot(data = mtcars,aes(x = wt,y = mpg,color = carb)) + 
  geom_point() + 
  scale_color_gradient(low = "black",high = "white") +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_gradient()调色板")

# 使用scale_color_gradient2()调色板
ggplot(data = mtcars,aes(x = wt,y = mpg,color = carb)) +
  geom_point() + 
  scale_color_gradient2(low = "red",mid = "white",high = "blue") +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_gradient2()调色板")

# 使用scale_color_gradientn()调色板
ggplot(data = mtcars,aes(x = wt,y = mpg,color = carb)) +
  geom_point() + 
  scale_color_gradientn(colours = c("black","orange","red","white")) +
  annotate("text",x = 4,y = 30,size = 5,
           label = "scale_color_gradientn()调色板")


########9.3.2 面板和分面#####

library(lattice)
xyplot(mpg ~ wt | factor(am), data = mtcars,
       layout = c(2,1),aspect = 1) 

# 按am分面
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() + 
  facet_grid(am ~ .)

# 按am（纵向）和cyl（航向）分面
ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() + 
  facet_grid(am ~ cyl,margins = TRUE)

ggplot(data = mtcars,aes(x = wt,y = mpg)) + 
  geom_point() + 
  facet_wrap(~am + cyl,nrow = 2)


######9.3.3 图形组合#########

# par()设置页面布局
par(mfrow= c(2,2))

# 绘制子图
hist(iris$Sepal.Length,main = NA,
     xlab = "Sepal.Length",ylab = NA)
plot(density(iris$Sepal.Length),main = NA,
     xlab = "Sepal.Length",ylab = NA)
boxplot(Sepal.Length ~ Species,data = iris,
        names = c("se","ve","vi"))
plot(iris$Sepal.Length,iris$Sepal.Width,
     xlab = "Sepal.Length",ylab = "Sepal.Width")

# layout()设置页面布局
layout(mat = matrix(1:4,nrow = 2),
       heights = c(3,2),widths = c(3,2))

# 绘制子图
hist(iris$Sepal.Length,main = NA,
     xlab = "Sepal.Length",ylab = NA)
boxplot(Sepal.Length ~ Species,data = iris,
        names = c("se","ve","vi"))
plot(density(iris$Sepal.Length),main = NA,
     xlab = "Sepal.Length",ylab = NA)
plot(iris$Sepal.Length,iris$Sepal.Width,
     xlab = "Sepal.Length",ylab = "Sepal.Width")

# 绘制子图
p1 <- ggplot(iris,aes(x = Sepal.Length,y = ..density..)) + 
  geom_histogram(col = "black",fill = "white") +
  xlab(label  = NULL ) +
  ylab(label  = NULL )
p2 <- ggplot(iris,aes(x = Species,y = Sepal.Length)) + 
  geom_boxplot() +
  xlab(label  = NULL ) +
  ylab(label  = NULL )
p3 <- ggplot(iris,aes(x = Sepal.Length,y = ..density..)) + 
  geom_density() +
  xlim(3,9) +
  xlab(label  = NULL ) +
  ylab(label  = NULL )
p4 <- ggplot(iris,aes(x = Sepal.Length,y = Sepal.Width)) + 
  geom_point()

# 开启一个新页面
library(grid)
grid.newpage()

# 创建一个已经分割好的视图
vp <-  viewport(layout = grid.layout(2,2,
                                     widths = c(3,2),
                                     heights = c(3,2)))
# 使用视图
pushViewport(vp)

# 将图形添加到各个区域
print(p1,vp = viewport(layout.pos.col = 1,layout.pos.row = 1))
print(p2,vp = viewport(layout.pos.col = 1,layout.pos.row = 2))
print(p3,vp = viewport(layout.pos.col = 2,layout.pos.row = 1))
print(p4,vp = viewport(layout.pos.col = 2,layout.pos.row = 2))



