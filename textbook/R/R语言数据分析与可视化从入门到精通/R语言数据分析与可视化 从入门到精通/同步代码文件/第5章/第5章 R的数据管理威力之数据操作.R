######第5章 R君的数据管理威力之数据操作######

#####5.1  R内置数据操作函数########
#########5.1.1 查看和编辑数据 ########
x <- data.frame(a = 1:10,b = 11:20)

# 将数据直接答应打印到屏幕
x
x <- data.frame(`我的名字特别长` = 1:10,
                `我的名字也不短` = 11:20,
                `我是第三列` = 21:30 )
x
# 加载扩展包
library(reshape2)

# 使用View()函数查看数据集
View(tips)
# 查看前6条数据
head(tips)

# 查看后10条数据
tail(tips,n = 10)
fix(tips)
####5.1.2 筛选 #######
# 用第2章的方法进行筛选
tips[tips$total_bill > 20 & 
       tips$tip > 5 & 
       tips$sex == "Male" & 
       tips$smoker == "No"&
       tips$day == "Sun",
     c("total_bill","tip","sex","smoker","day")]

# 用subset()函数进行筛选
subset(tips,
       subset = total_bill > 20 & 
         tip > 5 & 
         sex == "Male" & 
         smoker == "No"&
         day == "Sun",
       select = c("total_bill","tip","sex","smoker","day")
)
# 第一种方法的简便形式
with(tips,
     tips[total_bill > 20 & 
            tip > 5 & 
            sex == "Male" & 
            smoker == "No"&
            day == "Sun",
          c("total_bill","tip","sex","smoker","day")]) 
x <- letters
sample(x,size = 10)

y <- array(LETTERS[1:24],dim = c(3,4,2))
sample(y,size = 10)
# 对列表随机抽样
x <- list(a = c(1,3,4),b = letters,c= 3:12,d = month.abb)
sample(x,size = 2)

# 对数据框的行随机抽样
tips[sample(1:nrow(tips),5),]
########5.1.3 合并 #######
# 按列合并的例子
x <- tips[,c(1,2)]
y <- tips[,c(6,7)] # 构造两个数据框
z <- cbind(x,y)
head(z)

# 按行合并的例子
a <- tips[sample(1:nrow(tips),100),]
b <- tips[sample(1:nrow(tips),50),][,7:1] # 构造另外两个数据框，b的列名称顺序与a相反
c <- rbind(a,b)
head(c)
# 构建作者信息表
authors <- data.frame(
  name = I(c("Tukey", "Venables", "Tierney", "Ripley", "McNeil")),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  deceased = c("yes", rep("no", 4)))
authors
authors.new <- within(authors, # wintin()与with()函数类似，将在5.1.6 介绍
                      { surname <- name; rm(name) }) 
authors.new  

# 构建著作信息表
books <- data.frame(
  name = I(c("Tukey", "Venables", "Tierney",
             "Ripley", "Ripley", "McNeil", "R Core")),
  other.author = c(NA, "Ripley", NA, NA, NA, NA,"Venables & Smith"),
  title = c("Exploratory Data Analysis",
            "Modern Applied Statistics with S-PLUS",
            "LISP-STAT",
            "Spatial Statistics", 
            "Stochastic Simulation",
            "Interactive Data Analysis",
            "An Introduction to R"),
  publishers = c("Addison-Wesley","Springer","Wiley-Interscience",
                 "Springer","Wiley-Interscience",
                 "Wiley","Samurai Media Limited"),
  year = c(1977,1994,1990,1988,2006,1992,2015))
books

# 合并有相同列名的数据框
merge(authors,books,by = "name")
# 合并没有相同列名的数据框
merge(authors.new,books,by.x = "surname",by.y = "name")
#####5.1.4 分组和汇总#######
x <- rnorm(20,10,5)
# 按c(min(x),5,10,15,max(x))区间将x分成4个区间（组）
# include.lowest表示第一组是否包含最小值
cut(x,breaks = c(min(x),5,10,15,max(x)),include.lowest = T)

# 可以为每一个组赋予标签
cut(x,breaks = c(min(x),5,10,15,max(x)),
    labels = c("第一组","第二组","第三组","第四组"),
    include.lowest = T)

# 实际应用中往往是在数据框中生成新列
a <- data.frame(x = x)
a$y <- cut(a$x,breaks = c(min(a$x),5,10,15,max(a$x)),
           labels = c("第一组","第二组","第三组","第四组"),
           include.lowest = T)
head(a)
b <- split(a$x,a$y)
str(b)
# 若要将分组结果还原，可使用unsplit()函数
c <- unsplit(b,a$y)
c
rowsum(a$x,group = a$y)
table(a$y)
# xtabs与table结果一样，只是需要使用公式
xtabs(~ y,a)
# 按sex、smoker计算tips数据集中tatal_bill和tip的平均值
aggregate(tips[,c("total_bill","tip")],list(tips$sex,tips$smoker),mean)

# 也可以使用公式
aggregate(cbind(total_bill,tip) ~ sex + smoker,data = tips,mean)
######5.1.5 排序#########
x <- c(9,4,4,5,8,6,NA)
y <- factor(rep(c("东","南","西","北"),3),levels = c("东","南","西","北"))
sort(x)
sort(y)
# 通过设置na.last = TRUE，将NA置于向量的后面；降序排序
sort(x,na.last = TRUE,decreasing = TRUE)

# 通过设置na.last = FALSE，将NA置于向量的前面；降序排序
sort(x,na.last = FALSE,decreasing = TRUE)
x <- c(10.23,10.56,11.03,11.25,10.88,10.88,12.8)
rank(x,ties.method = "average")
rank(x,ties.method = "first")
rank(x,ties.method = "max")
x <- c(7,3,10,5)
x
y <- sort(x)
y
z <- order(x)
z
grades<- data.frame(name = c("Abel","Baron","Charles","David",
                             "Edward","Frank","Gabriel"),
                    time = c(10.23,10.56,11.03,11.25,10.88,10.88,12.8))

# 通过time对grades数据框排序
grades.ordered <- grades[order(grades$time),]
grades.ordered$rank <- rank(grades.ordered$time,ties.method = "min")
grades.ordered
tips.new <- tips

# 为了方便排序，先将tips$day和tips$time变为因子，并指定因子水平。
tips.new$day <- factor(tips.new$day,levels = c("Thur","Fri","Sat","Sun"))
tips.new$time <- factor(tips.new$time,levels = c("Lunch","Dinner"))

# 对tips排序
tips.ordered <- with(
  tips.new,
  tips.new[order(day,time,size,decreasing = T),]
)
head(tips.ordered,10)
#########5.1.6 转换###### 
tips1 <- tips 
# 使用with()函数在tips1中增加一个新列cost，即总花费
tips1$cost <- with(tips1,total_bill + tip)
head(tips1)

# 结果与使用”$“符号完全一样,但避免了一些重复
tips1$cost <- tips1$total_bill + tips1$tip
tips2 <- tips
# 使用within()函数在tips2中增加两列：cost和avg.cost(人均消费)
tips2 <- within(tips2,
                {
                  cost = total_bill + tip
                  avg.cost = cost/size
                })
head(tips2)
tips3 <- tips

# 使用transform()函数在tips3中增加两列：cost和avg.cost(人均消费)
tips3 <- transform(tips3,cost = total_bill + tip ,avg.cost = cost/size)
# 调整tranform中的表达式，将avg.cost = cost/size 变为avg.cost = (total_bill + tip)/size
tips3 <- transform(tips3,cost = total_bill + tip ,avg.cost = (total_bill + tip)/size)
head(tips3)
########5.2  数据重塑#######

library(reshape2)
head(airquality)  # airquality为R内置datasets中的关于空气质量的数据集
airquality.melt <- melt(data = airquality, 
                        id.vars = c("Month","Day"),
                        measure.vars = c("Ozone","Solar.R","Wind","Temp"),
                        variable.name = "index",
                        value.name = "value")
head(airquality.melt)
nrow(airquality.melt)/nrow(airquality)
airquality.dcast <- dcast(data = airquality.melt,
                          Month + Day ~ index,
                          value.var = "value")
head(airquality.dcast)
tips.dcast <- dcast(data = tips,
                    sex + smoker + day + size ~ time,
                    value.var = "total_bill")
head(tips.dcast)
tips.dcast <- dcast(data = tips,
                    sex + smoker + day + size ~ time,
                    value.var = "total_bill",
                    fun.aggregate = mean)
head(tips.dcast)
######5.3  apply函数族##### 
#####5.3.1 apply()函数#######
x <- matrix(1:24,4,6)
x

# 计算每一行的最大值
apply(X = x,MARGIN = 1,FUN = max)

# 计算每一列的平均值
apply(X = x,MARGIN = 2,FUN = min)

# 将x中的一个元素改变为NA,并计算每一行的最大值
x[1,2] <- NA
apply(X = x,MARGIN = 1,FUN = max)

# 加入max()函数中处理缺失值的参数
apply(X = x,MARGIN = 1,FUN = max,na.rm = TRUE)
x <- array(1:24,dim = c(3,4,2))
x
apply(x,MARGIN = 3,FUN = mean )
apply(x,MARGIN = c(1,3),FUN = mean )
apply(x,MARGIN = c(1,3),FUN = paste,collapse = "-" )
apply(x,MARGIN = 3, 
      FUN = function(x){
        list(range = range(x),mean =mean(x))
      } )
######5.3.2 lapply()函数######## 
# 输入为向量时
x <- 1:5
lapply(x,function(x){x^3})

# 输入为矩阵时
y <- matrix(1:4,2,2)
lapply(x,max)

# 输入为列表时
z <- list(x)
lapply(x,function(x){x^3})

# 输入为数据框时
d <- data.frame(x = 1:5,y = 6:10)
lapply(d,max)
########5.3.3 sapply()函数######## 
# simlify和USE.NAMES默认为TRUE
sapply(d,max)

# 当输入为字符串且USE.NAMES为TRUE时
sapply(LETTERS[1:5],function(x)paste(x,'-',x))

# simlify和USE.NAMES为TRUE时，与lapply()函数结果一样
sapply(d,max,simplify = FALSE,USE.NAMES = FALSE)
########5.3.4 vapply()函数##########
x <- list(a = 1:4,b = 5:8,c = 9:13)
sapply(x,function(x){x +10})
vapply(x,function(x){x +10},FUN.VALUE = numeric(4))
########5.3.5 mapply()函数###########
mapply(FUN = function(x,y) c(x + y, x * y), 2:8, 4:10)
#############5.4  plyr扩展包 ###########
library(plyr)
iris.set <- iris
iris3.set <- iris3
class(iris)
class(iris3)

# 不指定.fun,进行数据结构的转换
iris.set1 <- dlply(iris.set,.variables = "Species")
str(iris.set1)
str(iris3.set1)
model1 <- function(df){
  lm(Petal.Length ~ Petal.Width + 1,data = df)
}
iris.lm <- dlply(iris.set,.variables = "Species",.fun = model1,.progress = "text") 
iris.lm

model2 <- function(df){
  lm(`Petal L.` ~ `Petal W.` + 1,data = as.data.frame(df))
}
iris3.lm <- alply(iris3.set,.margins = 3,.fun = model2) 
iris3.lm

######5.5  用sqldf函数实现数据框的SQL风格查询#######
library(sqldf)
head(sqldf("select * from tips where day = 'Sun'"))
head(sqldf("select total_bill from tips"))
head(sqldf("select *,total_bill + tip as cost from tips"))
head(sqldf("select * from tips order by total_bill,tip"))
sqldf("select sex,time,
      count() as count ,
      avg(total_bill) as bill_avg,
      stdev(total_bill) as bill_stdev 
      from tips group by sex,time")
#######5.6  dplyr扩展包########

library(nycflights13)
# 查看flights数据集
flights
library(dplyr)
# 使用select()函数选择（列）变量
head(select(flights,year,flight,dest))
# 选取以“d”为首字母的变量
head(select(flights,starts_with("d")))

# 选取包含有“lay”的变量
head(select(flights,contains("lay")))

# 选取最后单词为“time”的变量
head(select(flights,matches(".time")))
# 选取在3月15日起飞，并且飞行距离大于1000的AS或者HA航空公司的航班信息
filter(flights,month == 3 , day == 15,
       distance > 1000, 
       carrier == "AS"| carrier == "HA")

# 对比5.1.2节介绍的行筛选方法
with(flights,
     flights[month == 3 & day == 15 & distance > 1000 & (carrier == "AS"| carrier == "HA"),])
# 依次按month、day、carrier、origin和dest这几个列对flights排序
head(arrange(flights,-month,-day,carrier,origin,dest))
# 计算节约时间和平均每小时飞行时间所节约时间
flights1<- mutate(flights,
                  gain = arr_delay - dep_delay,
                  gain_per_hour = gain / (air_time / 60)
)
head(flights1$gain)
head(flights1$gain_per_hour)
# 按航空公司进行进行分组
flights2 <- group_by(flights,carrier)
group_vars(flights2) # 查看分组变量
group_size(flights2) # 查看各组的行数

# 对各航空公司数据进行汇总
flights3 <- summarise(flights2,
                      dep_delay_mean = mean(dep_delay,na.rm = TRUE),
                      arr_delay_mean = mean(arr_delay,na.rm = TRUE),
                      distance_sd = sd(distance,na.rm = TRUE))
flights3
authors <- data.frame(
  name = I(c("Tukey", "Venables", "Tierney", "Ripley", "McNeil")),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  deceased = c("yes", rep("no", 4)))
books <- data.frame(
  name = I(c("Tukey", "Venables", "Tierney",
             "Ripley", "Ripley", "McNeil", "R Core")),
  other.author = c(NA, "Ripley", NA, NA, NA, NA,"Venables & Smith"),
  title = c("Exploratory Data Analysis",
            "Modern Applied Statistics with S-PLUS",
            "LISP-STAT",
            "Spatial Statistics", 
            "Stochastic Simulation",
            "Interactive Data Analysis",
            "An Introduction to R"),
  publishers = c("Addison-Wesley","Springer","Wiley-Interscience",
                 "Springer","Wiley-Interscience",
                 "Wiley","Samurai Media Limited"),
  year = c(1977,1994,1990,1988,2006,1992,2015))
inner_join(authors,books,by = "name")
sample_n(flights,size = 10)

sample_frac(flights,size = 0.05)
flights4 <- flights  %>%
  sample_frac(size = 0.1) %>%
  select(one_of("carrier","month","day",
                "dep_delay","arr_delay",
                "air_time","distance")) %>%
  mutate(gain = arr_delay - dep_delay,
         gain_per_hour = gain / (air_time / 60)) %>%
  group_by(carrier,month) %>%
  summarise(gain = mean(gain,na.rm = TRUE),distance = mean(distance,na.rm =TRUE))
flights4
