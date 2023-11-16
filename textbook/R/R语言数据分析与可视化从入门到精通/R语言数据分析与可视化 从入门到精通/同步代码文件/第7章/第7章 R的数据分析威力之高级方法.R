#####第7章 R君的数据分析威力之高级方法#######

######7.1    判别分析########

#######7.1.2 判别分析在R中的实现###########

# 查看数据信息
head(iris)
str(iris)
library(psych)
describe(iris)
# 设定随机种子
set.seed(1)

# 随机抽取测试集
data <- cbind(rownames = rownames(iris),iris)
library(dplyr)
testdata <- data %>%
  group_by(Species) %>%
  sample_n(1)

# 得到训练集
traindata <- filter(data,!(rownames %in% testdata$rownames))
testdata <- testdata[,-1] %>% ungroup()
traindata <- traindata[,-1] %>% ungroup()
testdata
# 将数据框转化为矩阵
library(dplyr)
testdata1 <- mutate(testdata,Species = as.numeric(Species)) %>% 
  as.matrix()
traindata1 <- mutate(traindata,Species = as.numeric(Species)) %>%
  as.matrix()

# 进行马氏距离判别
library(WeDiBaDis)
fit1 <- WDBdisc(data = traindata1 , datatype = "m" ,  classcol = 5 , 
                distance = "Mahalanobis",method = "DB")
summary(fit1)
# 对测试集数据进行判别
fit2 <- WDBdisc(data = traindata1 ,new.ind = testdata1[,-5], 
                datatype = "m" ,  classcol = 5 , 
                distance = "Mahalanobis",method = "DB")
summary(fit2)

as.character(testdata1[,5]) == as.vector(fit2$pred)

# 对数据进行Fisher判别
library(MASS)
fit3<- lda(Species ~ . , data = traindata)
fit3
# 计算混淆矩阵
x<- table(traindata$Species,predict(fit3,traindata)$class)
x

# 计算正确判定正确率
sum(diag(prop.table(x)))
y <- predict(fit3,newdata = testdata)$class
y == testdata$Species
# 绘制两个线性判别函数空间中的观察值
plot(fit3)
# 绘制第一个线性判别维度上每组观察值的直方图和密度图
plot(fit3,dimen = 1,type = "both")
library(klaR)
# 建立先验概率相等的Bayes判别模型
fit4 <- NaiveBayes(Species ~.,data = traindata) 

# 建立先验概率不等的Bayes判别模型
fit5 <- NaiveBayes(Species ~.,data = traindata,prior =c(2/5,2/5,1/5)) 

# 查看fit4和fit5的结构
str(fit4)
str(fit5)

# 计算两个模型的混淆矩阵
x <- table(traindata$Species,predict(fit4,traindata)$class) 
y <- table(traindata$Species,predict(fit5,traindata)$class) 
x           
y

# 计算正确率            
sum(diag(prop.table(x)))
sum(diag(prop.table(y)))
a <- predict(fit4,newdata = testdata)$class
a == testdata$Species

b <- predict(fit5,newdata = testdata)$class
b == testdata$Species
########7.2    聚类分析###########

library(flexclust)
# 查看数据
data(milk)
milk

# 数据标准化
milk_scaled <- scale(milk,center = TRUE,scale = TRUE)

# 计算欧几里得距离
milk_dist <- dist(milk_scaled, method = "euclidean")

# 使用平均距离法进行层次聚类
fit_average <- hclust(milk_dist,method = "average")
# 结果可视化
plot(fit_average,hang = -1,cex = 1.2,main = "平均距离层次聚类")

library(NbClust)
NbClust(milk_scaled,distance = "euclidean",min.nc=2,max.nc=8,method ="average") 
# 使用flexclust扩展包中的cutree()函数将聚类结果分为3类
fit_average_3 <- cutree(fit_average,k = 3)   
图7-6是最终的可视化结果，具体代码如下：
# 最终结果可视化
plot(fit_average,hang = -1,cex = 1,main = "平均距离层次最终聚类")
rect.hclust(fit_average,k = 3)
# 去除分类信息
iris1 <- iris[,-5]

# 数据标准化
iris1_scaled <- scale(iris1,center = TRUE,scale = TRUE)
head(iris1_scaled)

# 确定聚类的个数
library(NbClust)
NbClust(iris1_scaled,distance = "euclidean",min.nc=2,max.nc=8,method ="kmeans")
# 设定随机种子
set.seed(1000)
# 进行K-均值聚类
fit_kmeans <- kmeans(iris1_scaled,centers = 3,iter.max = 100,nstart = 30) 
# K-均值聚类的可视化
library(ggfortify)
autoplot(fit_kmeans,data=iris1_scaled,label = TRUE,lable.size=2)


autoplot(fit_kmeans,data=iris1_scaled,label = TRUE,
         lable.size=2,frame = TRUE)

#####7.3    主成分分析########


# 上表7-1表中的数据存为数据框
data <- data.frame(
  x1 = c(149.5,162.5,162.7,162.2,156.5,156.1,172.0,173.2,159.5,157.7),
  x2 = c(69.5,77.0,78.5,87.5,74.5,74.5,76.5,81.5,74.5,79.0),
  x3 = c(38.5,55.5,50.8,65.5,49.0,45.5,51.0,59.5,43.5,53.5)
)

# 主成分分析
library(psych)
pca1 <- principal(data,nfactors = 3)
pca1
pca2 <- principal(data,nfactors = 2)
pca2

#######7.4    因子分析#########


# 读取HolzingerSwineford1939数据集
library(lavaan)
head(HolzingerSwineford1939)

# 取其中的9列测试分数
data <- HolzingerSwineford1939[,c("x1","x2","x3","x4",
                                  "x5","x6","x7","x8","x9")]

# 查看样本数
n <- nrow(data)
n

# 计算变量相关矩阵
cor.data<- cor(data)
cor.data
KMO(cor.data)
cortest.bartlett(cor.data,n = n)
fa.parallel(cor.data,n.obs = n,fm = "ml",fa = "fa",n.iter = 100)
fa1<- fa(r = cor.data,nfactors = 3,n.obs = n,
         n.iter = 100,rotate = "none",fm = "ml")
# 使用正交旋转，具体方法为“varimax”
fa2<- fa(r = cor.data,nfactors = 3,n.obs = n,
         n.iter = 100,rotate = "varimax",fm = "ml")
# 使用使用斜交旋转，具体方法为“promax”
fa3<- fa(r = cor.data,nfactors = 3,n.obs = nrow(data),
         n.iter = 100,rotate = "promax",fm = "ml")
# 排除x2和x9
data_new <- cor.data[c(1,3:9),c(1,3:9)]

# 重新计算KMO值和进行Bartlett球形检验
KMO(data_new)

cortest.bartlett(data_new,n = n)
fa4<- fa(r = data_new,nfactors = 3,n.obs = n,
         n.iter = 100,rotate = "promax",fm = "ml")
fa5<- fa(r = data[,-2],nfactors = 3,n.obs = nrow(data),
         n.iter = 100,rotate = "promax",fm = "ml",scores = TRUE)
# 学生的因子得分
head(fa5$scores)
fa.diagram(fa5)


