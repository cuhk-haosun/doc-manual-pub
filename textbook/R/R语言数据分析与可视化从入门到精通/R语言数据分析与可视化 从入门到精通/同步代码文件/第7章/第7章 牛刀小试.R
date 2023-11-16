#####牛刀小试：尝试实现层次聚类#######
library(flexclust)
data(nutrient)
nutrient_scaled <- scale(nutrient,center = TRUE,scale = TRUE)
library(NbClust)
NbClust(nutrient_scaled,distance = "euclidean",
        min.nc=2,max.nc=8,method ="average")
# 计算欧几里距离
nutrient_dist <- dist(nutrient_scaled, method = "euclidean")
# 使用平均距离法进行层次聚类
fit_average <- hclust(nutrient_dist,method = "average")
# 结果可视化
plot(fit_average,hang = -1,cex = 1,main = "平均距离层次聚类")
rect.hclust(fit_average,k = 3)
