########牛刀小试：独立样本均值差异检验########
data <- data.frame(`男` = c(67,73,74,70,70,75,73,68,69,75,70,67,77,73),
                   `女` = c(69,63,67,64,61,66,60,63,63,70,64,65,61,68))
# 正态性检验
# 由于数据中有重复值，所以用jitter()函数做了一些轻微扰动
ks.test(x = jitter(data$`男`), y = 'pnorm') 
ks.test(x = jitter(data$`女`), y = 'pnorm') 
# 方差齐性检验
var.test(x = data$`男`,y = data$`女`) 
# 用Wilcox.test()函数进行独立样本的均值检验；
# 同理用jitter()函数做了一些轻微扰动
wilcox.test(jitter(data$`男`),jitter(data$`女`)) # 
