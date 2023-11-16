######牛刀小试：提取数据框子集，并对部分列做统计计算#########
mtcars.new <- mtcars[,c("mpg","disp","am")]
mtcars.new <- mtcars.new[mtcars.new$am == 1,]
mtcars.new
# mpg的均值
mean(mtcars.new$mpg)

# mpg的标准差
sd(mtcars.new$mpg)

# disp的均值
sum(mtcars.new$disp)
