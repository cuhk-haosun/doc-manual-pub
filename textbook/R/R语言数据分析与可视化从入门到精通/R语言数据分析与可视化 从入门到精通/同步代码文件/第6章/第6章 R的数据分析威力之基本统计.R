######第6章    R君的数据分析威力之基本统计#########
######6.1   描述性统计#########

########6.1.1 描述性统计量 ###########
head(airquality)
# 集中趋势
mean(airquality$Ozone,na.rm = TRUE)  
median(airquality$Ozone,na.rm = TRUE) #中位数

# 在R中没有直接求众数的方法，可以用以下代码来解决
which.max(table(airquality$Temp)) # 假设Temp为离散数据
Densit <- density(airquality$Temp) # 假设Temp为连续数据densit$x[which.max(densit$y)]

# 离散趋势
max(airquality$Ozone,na.rm = TRUE) –
  min(airquality$Ozone,na.rm = TRUE) # 极差
  Ozone.rm.na <- with(
    airquality,
    Ozone[is.na(Ozone) == FALSE]
  ) # 先选取Ozone中所有非空元素组成的子集  
sum(abs(Ozone.rm.na-mean(Ozone.rm.na)))/length(Ozone.rm.na) # 再求平均差
sd(airquality$Ozone,na.rm = TRUE)  # 标准差
var(airquality$Ozone,na.rm = TRUE) # 方差
with(
  airquality,
  sd(Ozone,na.rm = TRUE)/mean(Ozone,na.rm = TRUE) * 100
) # 变异系数

# 峰度和偏度(需要先安装moments扩展包：install.packages("monents")
library(moments)
skewness(airquality$Ozone,na.rm = TRUE) # 偏度
kurtosis(airquality$Ozone,na.rm = TRUE) # 峰度

# 百分位数
quantile(airquality$Ozone,probs = seq(0,1,by = 0.1),na.rm = TRUE)

# Turkey五数：最小值、25百分位数、中位数、75百分位数和最大值
fivenum(airquality$Ozone,na.rm = TRUE)

# 数量
length(airquality$Month)
table(airquality$Month)
# 算数截断平均数
mean(airquality$Ozone,na.rm = TRUE,trim = 0.1)  
######6.1.2 数量和列联表#####
library(vcd)
head(Arthritis) 
# 二维度列联表
table.2D <- table(Arthritis$Treatment,Arthritis$Sex)
table.2D

# 三维度列联表
table.3D <- table(Arthritis$Treatment,Arthritis$Sex,Arthritis$Improved)
table.3D

# 可以让tabel.3D更好看一些
library(plyr) 
library(dplyr)
adply(table.3D,.margins = 1:2) %>%
  setNames(c("Treatment","Sex","None","Some","Marked"))

# 紧凑的呈现方式
ftable(table.3D)
# 结果类似于tabel.2D
xtabs(~ Treatment + Sex,data = Arthritis)
# 结果类似于tabel.3D
xtabs(~ Treatment + Sex + Improved,data = Arthritis)
# 默认将所有数值相加作为分母
prop.table(table.2D)

# 按行计算频率
prop.table(table.2D,margin = 1)

# 按列计算频率
prop.table(table.2D,margin = 2)

# 按行求和
addmargins(table.2D,margin = 1)

# 按分别按照行和列
addmargins(table.2D,margin = 1:2)
mar_table(table.2D)

# 按列求平均
addmargins(table.2D,margin = 2,FUN = mean)

margin.table(table.2D,margin = 1)
margin.table(table.2D,margin = 2)

#######6.1.3 同时呈现多个统计量#######

library(ggplot2)
head(diamonds)

# 先创建一个自编函数
func1 <- function(x,...){
  library(moments) # 默认已经安装了moments扩展包
  Mx <- round(max(x,...),digits = 1)
  Mn <- round(min(x,...),digits = 1)
  M <- round(mean(x,...),digits = 1)
  Med <- round(median(x,...),digits = 1)
  Sd <- round(sd(x,...),digits = 1)
  Skew <- round(skewness(x,...),digits = 1)
  Kurt <- round(kurtosis(x,...),digits = 1)
  return(c(Mx = Mx,Mn = Mn,M = M,Med = Med,
           Sd=Sd,Skew = Skew,Kurt = Kurt))
}

# 使用apply函数族
sapply(diamonds[,"carat"],func1,na.rm = TRUE)
sapply(diamonds[,"price"],func1,na.rm = TRUE)

# 使用plyr扩展包中的adply()函数
adply(as.matrix(diamonds[,c("carat","price")]),
      .margins = 2,
      func1,na.rm = TRUE)
summary(diamonds)
library(Hmisc)
describe(diamonds)

library(psych)
describe(diamonds)
library(pastecs)
# 为了便于显示，将显示的小数点位数设置为3
options(digits = 3)
stat.desc(diamonds,basic = FALSE,desc = FALSE)
# 还原小数点显示位数默认值（7）
options(digits = 7)
###########6.2   计数数据的检验##########

#########6.2.1 在R中实现卡方检验##############
# 50名儿童对五种新开发的玩具的选择结果
toys <- c(8,9,6,20,7)
# 检验这五种玩具受欢迎程度是否相同
chisq.test(toys)
#  参数p中每个元素默认相同。
#  故设置p=rep(0.2,5)与默认情况完全一样
chisq.test(toys,p = rep(0.2,5))
# 基于前期研究确定理论比例
p <- c(0.12,0.19,0.14,0.36,0.19)
# 检验调查结果与前期研的数据是否吻合
chisq.test(toys,p = p)
# 设定随机种子数
set.seed(123)
norm <- rnorm(10000)

# 查看最大值和最小值
norm.max <- max(norm)
norm.max
norm.min <- min(norm)
norm.min

# 分组
norm.cut <- cut(norm,breaks = c(-4,-3,-2,-1,0,1,2,3,4))

# 计算各组数量
norm.table <- table(norm.cut)
norm.table

# 检验是否拟合正态分布
norm.p <- pnorm(c(-3,-2,-1,0,1,2,3,4),mean(norm),sd(norm))
p.norm <- c(norm.p[1],norm.p[2] - norm.p[1],
            norm.p[3] - norm.p[2],norm.p[4] - norm.p[3],
            norm.p[5] - norm.p[4],norm.p[6] - norm.p[5],
            norm.p[7] - norm.p[6],1 - norm.p[7])
chisq.test(x= norm.table,p = p.norm)
ks.test(norm,y = "pnorm")
# 当x是矩阵时
table1 <- table(Arthritis$Treatment,Arthritis$Sex)
table1

table2 <- table(Arthritis$Treatment,Arthritis$Improved)
table2

chisq.test(x = table1)
chisq.test(x = table2)

# 当x和y都是因子时
chisq.test(x = Arthritis$Treatment,y = Arthritis$Sex)
chisq.test(x = Arthritis$Treatment,y = Arthritis$Improved)

#########6.3   相关分析########
#########6.3.2 各种相关系数计算在R中的实现######

# 查看数据
head(USArrests)
# 计算两列变量间的皮尔逊相关系数、斯皮尔曼相关系数和肯德尔τ系数
cor(x = USArrests$Murder,y = USArrests$Assault,method = "pearson")
cor(x = USArrests$Murder,y = USArrests$Assault,method = "spearman")
cor(x = USArrests$Murder,y = USArrests$Assault,method = "kendall")
# 同时计算多个变量之间的两两相关
cor(x = USArrests,method = "pearson")
library(ggm)
pcor(c(1,2,3,4),cov(USArrests))
library(vegan)
x <- data.frame(col1 = c(4,1,2.5,6,2,5),
                col2 = c(5,1,2,5,3,5),
                col3 = c(3.5,1.5,1.5,5,3.5,6),
                col4 = c(5,2,2,4,2,6),
                col5 = c(4,1,2,5,3,6))
kendall.global(x)

library(ltm)
library(psych)
# 使用cor()函数计算总分值与第1题之间的点二列相关系数
cor(x = rowSums(x = LSAT),y = LSAT[[1]])

# 使用ltm::biserial.cor()函数计算总分值与第1题之间的点二列相关系数
biserial.cor(x = rowSums(LSAT), y = LSAT[[1]])

# 使用psych::biserial()函数计算总分值与第1题之间的二列相关系数
biserial(x = rowSums(LSAT),y = LSAT[[1]])

# 使用polycor::polyserial()函数计算总分值与第1题之间的二列相关系数
polyserial(x = rowSums(LSAT),y = LSAT[[1]])
# 改变ltm::biserial.cor()函数的level参数值，使其结果与cor()函数一致
biserial.cor(x = rowSums(LSAT), y = LSAT[[1]],level = 2)
x <- matrix(c(100,60,90,160),ncol = 2)
phi(x)
##########6.4   t检验###############

###############6.4.1 独立样本t检验#############

library(nutshell)
data(field.goals)
# 分别取室外射门得分的距离数据向量和室捏射门得分的距离数据向量
out.data <- field.goals$yards[field.goals$stadium.type == "Out"]
in.data <- field.goals$yards[field.goals$stadium.type == "In"]

# 独立样本t检验，假设两者之间无差异
t.test(in.data,out.data,alternative = "two.sided",var.equal = TRUE)
# 在field.goals数据集中筛选室外和室内射门得分距离数据
data1 <-dplyr::filter(field.goals,stadium.type %in% c("Out","In"))

# 独立样本t检验,假设两者之间无差异
t.test(yards ~ stadium.type,data1,
       alternative ="two.sided",var.equal = TRUE)
head(InsectSprays)
# 筛选数据
data2 <- dplyr::filter(InsectSprays,spray %in% c("C","D"))

# 独立样本t检验,假设使用杀虫剂C后的昆虫数目比使用杀虫剂D后的昆虫数目绍
t.test(count ~ spray,data2,alternative = "less",var.equal = TRUE)
########6.4.2 非独立样本t检验##########

head(sleep)
t.test(extra ~ group,data = sleep,paired = TRUE,alternative = "two.sided")

t.test(extra ~ group,data = sleep,paired = TRUE,alternative = "less")
#########6.4.3 对t检验的前提假设进行检验 ###########
library(car)
# 对两组射门得分距离数据进行方差齐性检验
var.test(yards ~ stadium.type,data1)
bartlett.test(yards ~ stadium.type,data1)

# 对使用两种杀虫剂后的昆虫数目数据进行方差齐性检验
var.test(count ~ spray,data2)
bartlett.test(count ~ spray,data2)
#########6.5   方差分析########
###########6.5.3 单因素非重复测量方差分析########
library(car)
# 查看数据
head(Prestige)

# 各组样本大小
table(Prestige$type)

# 各组均值
aggregate(prestige  ~ type,data = Prestige,FUN = mean)

# 各组标准差
aggregate(prestige  ~ type,data = Prestige,FUN = sd)

# 非重复测量方差分析
fit1 <- aov(prestige ~ type,data = Prestige)
summary(fit1)
# 绘制各组的均值和置信区间图
library(gplots)
plotmeans(prestige ~ type,data = Prestige,xlab = "type",
          ylab = "prestige",main = "Mean Plot with 95% CI")

library(asbio)
multicomp1 <- TukeyHSD(fit1)
multicomp1

multicomp2<- pairw.anova(Prestige$prestige,Prestige$type,method = "lsd")
multicomp2
########6.5.4 单因素协方差分析############

library(nlme)
# 选择数据
bdf.sub <- bdf [,c("IQ.verb","denomina","schoolSES")]
# 查看数据
head(bdf.sub)
# 查看各组两本量
table(bdf.sub$denomina)
# 计算各组均值
tapply(bdf.sub$IQ.verb,bdf.sub$denomina,mean)
# 计算各组标准差
tapply(bdf.sub$IQ.verb,bdf.sub$denomina,sd)
# 单因素协方差分析
fit2 <- aov(IQ.verb ~ schoolSES + denomina,data = bdf.sub)
summary(fit2)
library(effects) 
tapply(bdf.sub$IQ.verb,bdf.sub$denomina,mean)
contrast <- rbind("1 vs 2" = c(1,-1,0,0),
                  "1 vs 3" = c(1,0,-1,0),
                  "1 vs 4" = c(1,0,0,-1),
                  "2 vs 3" = c(0,1,-1,0),
                  "2 vs 4" = c(0,1,0,-1),
                  "3 vs 4" = c(0,0,0,-1))
summary(glht(fit2,linfct = mcp(denomina = contrast )))
library(HH)
# 先将bdf.sub$denomina变为因子
bdf.sub$denomina <-  factor(bdf.sub$denomina,ordered = F)  

ancova(IQ.verb ~ schoolSES + denomina,data = bdf.sub)

##########6.5.5 单因素重复测量方差分析###########3

library(reshape2)
# 研究数据
reading.comprehension <- data.frame(subject = paste0("sub",1:8),
                                    a1 = c(3,6,4,3,5,7,5,2),
                                    a2 = c(4,6,4,2,4,5,3,3),
                                    a3 = c(8,9,8,7,5,6,7,6),
                                    a4 = c(9,8,8,7,12,13,12,11))
head(reading.comprehension)
# 数据融合（变形）
reading.comprehension1 <- melt(reading.comprehension,
                               id.vars = "subject",
                               variable.name = "newword.density",
                               value.name = "score")
# 计算组均数
aggregate(score  ~ newword.density,data = reading.comprehension1,
          FUN = mean)
# 计算组标准差
aggregate(score  ~ newword.density,data = reading.comprehension1,
          FUN = sd)

#  单因素重复测量方差分析
fit3 <- aov(score  ~ newword.density + Error(subject/newword.density),
            data = reading.comprehension1)
summary(fit3)
###########6.5.6 两因素方差分析 ############
# 计算个处理组合的次数
table(warpbreaks$wool,warpbreaks$tension)

# 计算各处理组合均值和标准差  
library(dplyr)
group_by(warpbreaks,wool,tension) %>% summarise(breaks.mean = mean(breaks))
group_by(warpbreaks,wool,tension) %>% summarise(breaks.sd = sd(breaks))

#  两因素方差分析
fit4 <- aov(breaks ~ wool * tension,data = warpbreaks)
summary(fit4)
with(warpbreaks,
     interaction.plot(x.factor = tension,trace.factor = wool,
                      response = breaks,type = "b",
                      col = c("black","red"),pch = c(13,14),
                      main = "羊毛类型与张力大小间的交互作用"))
library(HH)
with(warpbreaks,
     interaction2wt(breaks ~ wool * tension))
########6.6   非参数检验#########

#########6.6.1 两总体比较#########

# 用Wilcox.test()函数进行独立样本的均值检验
wilcox.test(in.data,out.data)
# 用Wilcox.test()函数进行非独立样本的均值检验
wilcox.test(extra ~ group,data = sleep,paired = TRUE,alternative = "less")
############6.6.2 多于两总体比较 ##############
# Kruskal-Wallis检验
kruskal.test(prestige ~ type,data = Prestige)

# Friedman检验
reading.comprehension <- data.frame(subject = paste0("sub",1:8),
                                    a1 = c(3,6,4,3,5,7,5,2),
                                    a2 = c(4,6,4,2,4,5,3,3),
                                    a3 = c(8,9,8,7,5,6,7,6),
                                    a4 = c(9,8,8,7,12,13,12,11))
reading.comprehension1 <- reshape2::melt(reading.comprehension,
                                         id.vars= "subject",
                                         variable.name = "treatment",
                                         value.name = "A")
friedman.test(A ~ treatment | subject,data= reading.comprehension1)

######6.7   回归分析##########

######6.7.2 模型拟合########

# 简单线性模型拟合
fit <- lm(dist ~ speed,data = cars)

# 拟合的详细信息
summary(fit)

# 模型参数
coefficients(fit)

# 归回系数置信区间 
confint(fit)

# 模型预测值
fitted(fit)

# 模型残差
residuals(fit)
# 速度和停车距离的关系图
plot(cars)
lines(x = cars$speed,y = fitted(fit),col = "red")

fit <- lm(mpg ~ disp + hp + drat + wt,data = mtcars)
summary(fit)
######6.7.3 模型诊断#####

fit <- lm(mpg ~ disp + hp + drat + wt,data = mtcars)
# 将四种形组合成一张图
par(mfrow = c(2,2))
plot(fit)

library(car)
vif <- vif(fit)
vif 

# 查看哪些变量膨胀因子大于10
vif > 10

# 查看哪些变量膨胀因子的开方大于2
sqrt(vif) > 2
########6.7.4 模型改进 ###########
# 删除异常值
mtcars1 <- mtcars[which(!rownames(mtcars) %in% 
                          c("Toyota Corolla","Maserati Bora",
                            "Fiat 128","Chrysler Imperial",
                            "Lotus Europa")),]
# 模型拟合
fit1 <- lm(mpg ~ disp + hp + drat + wt,data = mtcars1)
summary(fit1)
# 将四种形组合成一张图
par(mfrow = c(2,2))
plot(fit1) 
library(car)
summary(powerTransform(mtcars$mpg))
# 使用car扩展包中的bcpower()函数得到mpg相应的Box-Cox变换值
mpg_trans <- bcPower(mtcars$mpg,lambda = 0.03)

# 重新拟合
fit2 <- lm(mpg_trans ~ disp + hp + drat + wt,data = mtcars)
summary(fit2)
# 将四种形组合成一张图
par(mfrow = c(2,2))
plot(fit2)

fit <- lm(mpg ~ disp + hp + drat + wt,data = mtcars)

# 向前向后回归
fit3 <- step(fit,direction = "both")
