###### 3.1.1 repeat循环#####

repeat ({
  message("hello word!")
})

repeat ({
  x <- sample(c(1:5), 1)
  message("x = ", x, ",hello word!")
  if (x == 2) {
    message("x = ", x, ",执行下一次repeat循环！")
    next
  }
  if (x == 1) {
    message("x = ", x, ",跳出repeat循环！")
    break
  }
})

# 使用break语句的repeat循环
repeat ({
  x <- sample(c(1:5), 1)
  message("x = ", x, ",hello word!")
  if (x == 1) {
    message("x = ", x, ",跳出repeat循环！")
    break
  }
})
## x = 2,hello word!
## x = 3,hello word!
## x = 1,hello word!
## x = 1,跳出repeat循环！
rm(x)

###### 3.1.2 while循环#####
# while循环
x <- sample(c(1:5), 1)
while (x != 1) {
  x <- sample(c(1:5), 1)
  message("x = ", x, ",hello word!")
}


i <- c(1:5)
for (x in i) {
  message("x = ", x, ",hello word!")
}

#####3.1.3 for循环#####

# 向量参数为字符串
name <- c("小明", "小华", "小刚", "R君")
for (i in name) {
  message(i, "非常厉害！")
}
## 小明非常厉害！
## 小华非常厉害！
## 小刚非常厉害！
## R君非常厉害！
# 向量参数为逻辑值
x <- c(TRUE, FALSE, NaN, NA)
for (i in x) {
  message("输出值为", i)
}
## 输出值为1
## 输出值为0
## 输出值为NaN
## 输出值为NA
# 向量参数为列表
x <- list(c(1:5), c("小明", "小华", "小刚", "R君"), c(TRUE, FALSE,
                                               NaN, NA))
for (i in x) {
  print(i)
}
## [1] 1 2 3 4 5
## [1] "小明" "小华" "小刚" "R君"
## [1]   1   0 NaN  NA

#####3.1.4 if和else语句#####
# if条件直接为TRUE
if (TRUE) {
  print("if条件为TRUE")
}
## 'if条件为TRUE'
# if条件长度超过1
if (c(TRUE, FALSE)) {
  print("if条件为TRUE和FALSE")
}
## Warning message:the condition has length > 1 and only the
## first element will be used if条件为TRUE和FALSE
# if条件为缺失值
if (NA) {
  print("if条件为NA")
}
## Error:Error in if (NA) { : missing value where TRUE/FALSE
## needed
# if条件为表达式
x = 10
if (x > 1) {
  print("if条件为表达式x>1")
}
## if条件为表达式x>1

# else放置正确
x<--10
if (x>1){
  print("X>1")
} else{
  print("x<1")
}
## x<1

# else放置错误
x<--10
if (x>1){
  print("X>1")
}
else{
  print("x<1")
}
## Error: unexpected 'else' in "else"

# 多个if...else用法
x <- -10
if (x > 1) {
  print("X>1")
} else if (x > 2) {
  print("x>2")
} else if (x > 0) {
  print("x>0")
} else if (x <- 2) {
  print("x<-2")
} else {
  print("x=0")
}
## [1] "x<-2"
# ifelse用法
x <- -10
y <- ifelse(x > 0, "X>0", "X<0")
print(x)
## [1] -10
print(y)
## [1] "X<0"


#####3.1.5 switch语句#####

# if...else用法
x <- "f"
if (x == "beta") {
  print("beta分布")
} else if (x == "gama") {
  print("gama分布")
} else if (x == "f") {
  print("f分布")
} else if (x == "t") {
  print("t分布")
} else {
  print("其他")
}
## [1] "f分布"
# switch用法
x <- "f"
switch(x, beta = "beta分布", gama = "gama分布", t = "t分布",
       f = "f分布", "其他")
## [1] "f分布"


#####3.2.1 函数格式#####
hello <- function() {
  out <- "hello world!"
  return(out)
}
hello()
## [1] "hello world!"

#####3.2.2 函数参数#####
hello <- function(name) {
  out <- paste("hello", name, "!")
  return(out)
}
hello(name = "R")
## [1] "hello R !"

hello()
## Error in paste("hello", name, "!"): 缺少参数"name",也没有缺省值

hello <- function(name = NULL) {
  out <- paste("hello", name, "!")
  return(out)
}
hello()
## [1] "hello  !"
hello(name = "R")
## [1] "hello R !"


# 调用hello函数，在name参数基础上，添加一个extra参数
hello(name = "R", extra = "users")
# Error in hello(name = 'R', extra = 'users') : unused
# argument (extra = 'users')
# 改编hello函数，新增额外参数...
hello <- function(name = NULL, ...) {
  out <- paste("hello", name, "!")
  return(out)
}
hello(name = "R", extra = "users")
## [1] "hello R !"
hello()
## [1] "hello  !"
# Error in hello(name = 'R', extra = 'users') : unused
# argument (extra = 'users')


#####3.2.3 返回值#####
# 最后一行代码返回，存在变量赋值情况
hello <- function(name = NULL, ...) {
  out <- paste("hello", name, "!")
}
hello(name = "R")
# 最后一行代码返回，不存在变量赋值情况
hello <- function(name = NULL, ...) {
  paste("hello", name, "!")
}
hello(name = "R")
## [1] "hello R !"
# 使用return返回
hello <- function(name = NULL, ...) {
  out <- paste("hello", name, "!")
  return(out)
}
hello(name = "R")
## [1] "hello R !"


#####3.2.4 函数调用#####
# 直接调用
hello(name = "R")
## [1] "hello R !"
# do.call方式调用
do.call(what = hello, args = list(name = "R"))
## [1] "hello R !"


#####3.3.1 文件操作#####
# 查看当前工作目录
getwd()
## [1] "M:/工作资料/20181117153123-RYuYanKeShiHua/code/ExampleScript/Chapter3"
# 查看当前目录或指定目录的子目录
list.dirs(path = getwd(), full.names = F)
## [1] ""      "image" "tmp1"
# 查看当前目录的子目录及文件
dir()
## [1] "Chapter3.docx" "Chapter3.Rmd"  "image"         "tmp1"
list.files()
## [1] "Chapter3.docx" "Chapter3.Rmd"  "image"         "tmp1"
# 查看当前目录的子目录及文件的详细信息
file.info(list.files(), extra_cols = FALSE)
##                 size isdir mode               mtime               ctime
## Chapter3.docx 714841 FALSE  666 2019-08-25 09:32:04 2019-02-12 18:18:24
## Chapter3.Rmd   55392 FALSE  666 2019-08-25 09:32:52 2019-02-12 18:18:24
## image              0  TRUE  777 2019-02-13 02:41:26 2019-02-13 02:41:25
## tmp1               0  TRUE  777 2019-08-25 09:32:02 2019-08-25 09:32:00
##                    atime
## Chapter3.docx 2019-08-25
## Chapter3.Rmd  2019-08-25
## image         2019-04-02
## tmp1          2019-08-25

# 查看当前目录及文件权限信息
file.mode(list.files())
## [1] "666" "666" "777" "777"
# 查看当前目录及文件最近一次修改信息
file.mtime(list.files())
## [1] "2019-08-25 09:32:04 CST" "2019-08-25 09:32:52 CST"
## [3] "2019-02-13 02:41:26 CST" "2019-08-25 09:32:02 CST"
# 查看当前目录及文件大小
file.size(list.files())
## [1] 714841  55392      0      0
# 通过系统命令查看目录结构
system("tree")
# 查看Chapter3/Chapter3.docx文件是否存在
file.exists("Chapter3/Chapter3.docx")
## [1] FALSE
# 查看imge和Chapter3.docxs是否是文件或目录
file_test(op = "-d", x = "image")
## [1] TRUE
file_test(op = "-f", x = "Chapter3.docx")

path.expand(path = "tmp")
## [1] "tmp"
normalizePath(path = "tmp")
## Warning in normalizePath(path.expand(path), winslash, mustWork):
## path[1]="tmp": 系统找不到指定的文件。
## [1] "M:\\工作资料\\20181117153123-RYuYanKeShiHua\\code\\ExampleScript\\Chapter3\\tmp"
# 创建空白文件tmp.R
file.create("tmp.R")
## [1] TRUE
# 创建空白目录tmp
dir.create(path = "tmp", recursive = T, mode = "0777")
# 修改tmp.R权限(注意：windows平台下该命令无效)
Sys.chmod(paths = "tmp.R", mode = "0777", use_umask = T)
file.mode("tmp.R")
## [1] "666"
# 设置系统默认的umask值(注意：windows平台下该命令无效)
Sys.umask(mode = NA)
## [1] "0"

# 复制tmp.R文件至tmp文件夹
file.copy(from = "tmp.R", to = "tmp", overwrite = T, recursive = T)
## [1] TRUE
# 将文件tmp.R重命名为tmp1.R
file.rename(from = "tmp.R", to = "tmp1.R")
## [1] TRUE
# 将目录tmp重命名为tmp1
file.rename(from = "tmp", to = "tmp1")
## [1] FALSE
# 将tmp1.R追加至tmp2.R中
file.append(file1 = "tmp.R", file2 = "tmp1.R")
## [1] TRUE

# 删除tmp1.R和tmp2.R
file.remove(c("tmp1.R", "tmp.R"))
## [1] TRUE TRUE
# 删除tmp文件夹及其子文件夹
unlink("tmp", recursive = T)


#####3.3.2 基础计算#####
# 定义x和y变量
x <- 12
x
## [1] 12
y <- 4
y
## [1] 4
# x和y的加减乘除计算
x + y
## [1] 16
x - y
## [1] 8
x * y
## [1] 48
x/y
## [1] 3
# 求余数
x%%y
## [1] 0
# 求绝对值
abs(-x)
## [1] 12


x <- 8
x
## [1] 8
y <- 2
y
## [1] 2
# 幂运算
x^y
## [1] 64
x^-y
## [1] 0.015625
x^(1/y)
## [1] 2.828427
# 自然常数e的幂
exp(1)
## [1] 2.718282
# 自定义底的对数
log(x, base = 2)
## [1] 3
# 平方根
sqrt(x)
## [1] 2.828427
sqrt(y)
## [1] 1.414214


# 定义x和y变量
x <- 8
x
## [1] 8
y <- 2
y
## [1] 2
# 判断等于和不等于
x == x
## [1] TRUE
x == y
## [1] FALSE
x != y
## [1] TRUE
# 判断大于、大于等于、小于和小于等于
x > y
## [1] TRUE
x >= y
## [1] TRUE
x < y
## [1] FALSE
x <= y
## [1] FALSE
# 判断是否为真
isTRUE(x == y)
## [1] FALSE
# 判断是否为假
isFALSE(x == y)
## [1] TRUE
# 定义x和y向量
x <- c(1, 0, 1)
y <- c(0, 1, 0)
# 向量的和条件比较
x & y
## [1] FALSE FALSE FALSE
# x和y向量的第一个分量的和条件比较
x && y
## [1] FALSE
# 或条件比较
xor(x, y)
## [1] TRUE TRUE TRUE
x | y
## [1] TRUE TRUE TRUE
#


# 定义x变量
x <- 6.88889
x
## [1] 6.88889
# 取整
trunc(x)
## [1] 6
# 向上取整
ceiling(x)
## [1] 7
# 向下取整
floor(x)
## [1] 6
# 四舍五入
round(x, digits = 3)
## [1] 6.889


x <- seq(from = 1, to = 10, by = 1)
x
##  [1]  1  2  3  4  5  6  7  8  9 10
# 计算向量x的求和、平均值、最大值、最小值、标准差、方差、全距
sum(x)
## [1] 55
mean(x)
## [1] 5.5
max(x)
## [1] 10
min(x)
## [1] 1
sd(x)
## [1] 3.02765
var(x)
## [1] 9.166667
range(x)
## [1]  1 10
# 计算向量x的连乘、累加、累乘
prod(x)
## [1] 3628800
cumsum(x)
##  [1]  1  3  6 10 15 21 28 36 45 55
cumprod(x)
##  [1]       1       2       6      24     120     720    5040   40320
##  [9]  362880 3628800

# 计算x向量的秩次、排序、中位数和分位数
rank(x)
##  [1]  1  2  3  4  5  6  7  8  9 10
order(x, decreasing = T)
##  [1] 10  9  8  7  6  5  4  3  2  1
sort(x, decreasing = T)
##  [1] 10  9  8  7  6  5  4  3  2  1
median(x)
## [1] 5.5
quantile(x)
##    0%   25%   50%   75%  100%
##  1.00  3.25  5.50  7.75 10.00

定义x和y变量
x <- seq(from = 1, to = 10, by = 1)
x
##  [1]  1  2  3  4  5  6  7  8  9 10
y <- seq(from = 1, to = 20, by = 2)
y
##  [1]  1  3  5  7  9 11 13 15 17 19
# 求x和y的交集、并集和差集
intersect(x, y)
## [1] 1 3 5 7 9
union(x, y)
##  [1]  1  2  3  4  5  6  7  8  9 10 11 13 15 17 19
setdiff(x, y)
## [1]  2  4  6  8 10
# 判断x和y是否相等
setequal(x, y)
## [1] FALSE
# 求取x的唯一值
unique(x)
##  [1]  1  2  3  4  5  6  7  8  9 10
# 查找x向量中大于4的元素的索引
which(x >= 4)
## [1]  4  5  6  7  8  9 10
# 查找x在y中存在的元素的索引
which(is.element(x, y))
## [1] 1 3 5 7 9


#####3.3.3 概率分布#####

# 生成20个平均数为0，标准差为1的正态分布随机数
x <- rnorm(n = 20, mean = 0, sd = 1)
x
##  [1] -0.07861527  0.19606825 -0.45986732 -0.81111317 -0.79371377
##  [6] -0.93180535  0.18395207  1.11766118 -0.06783424  1.68732170
## [11] -0.24100996 -0.75785804 -0.54269466  0.26896172  0.20099474
## [16] -0.37255934  1.08408829  2.05859069  0.16643952 -0.15028829
# 求正态向量x的概率密度函数值
dnorm(x, mean = 0, sd = 1)
##  [1] 0.39771138 0.39134729 0.35891219 0.28710972 0.29114632 0.25844584
##  [7] 0.39224928 0.21362742 0.39802547 0.09609041 0.38752247 0.29935865
## [13] 0.34431537 0.38477030 0.39096471 0.37219448 0.22167072 0.04793850
## [19] 0.39345460 0.39446226
# 求正态向量x的累积分布函数值
pnorm(x, mean = 0, sd = 1)
##  [1] 0.4686693 0.5777216 0.3228057 0.2086503 0.2136810 0.1757186 0.5729745
##  [8] 0.8681441 0.4729588 0.9542292 0.4047737 0.2242680 0.2936700 0.6060204
## [15] 0.5796487 0.3547382 0.8608372 0.9802333 0.5660945 0.4402686

# 生成20个介于0到10之间服从均匀分布的随机数
x <- runif(n = 20, min = 0, max = 10)
x
##  [1] 2.245649307 7.445555783 6.901446572 8.691643493 8.811735900
##  [6] 9.479316950 4.343840037 5.519000662 5.069841640 0.001625642
## [11] 8.291946410 6.011003035 7.430850356 8.517232367 6.155735073
## [16] 1.283098147 7.316052923 0.405191907 9.969611696 8.569339041
# 求服从均匀分布向量x的概率密度函数值
dunif(x, min = 0, max = 1)
##  [1] 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0
# 求服从均匀分布向量x的累积分布函数值
punif(x, min = 0, max = 1)
##  [1] 1.000000000 1.000000000 1.000000000 1.000000000 1.000000000
##  [6] 1.000000000 1.000000000 1.000000000 1.000000000 0.001625642
## [11] 1.000000000 1.000000000 1.000000000 1.000000000 1.000000000
## [16] 1.000000000 1.000000000 0.405191907 1.000000000 1.000000000

# 生成20个服从指数分布e(0.5)的随机数
x <- rexp(n = 20, rate = 0.5)
x
##  [1] 0.06612895 3.32194528 1.22505360 2.72949175 1.51328543 1.68729619
##  [7] 0.58971433 4.86064805 0.98450293 0.79425084 5.23259057 0.17612128
## [13] 3.14787329 8.38975707 3.97650442 0.93998877 2.89237890 0.17697924
## [19] 0.63903554 2.21451529
# 求服从指数分布e(0.5)向量x的概率密度函数值
dexp(x, rate = 0.5)
##  [1] 0.483738089 0.094977067 0.270989832 0.127722792 0.234619578
##  [6] 0.215069235 0.372318970 0.044004155 0.305624319 0.336124854
## [11] 0.036536538 0.457852673 0.103613896 0.007536287 0.068467275
## [16] 0.312502889 0.117732917 0.457656305 0.363249646 0.165231985
# 求服从指数分布e(0.5)向量x的累积分布函数值
pexp(x, rate = 0.5)
##  [1] 0.03252382 0.81004587 0.45802034 0.74455442 0.53076084 0.56986153
##  [7] 0.25536206 0.91199169 0.38875136 0.32775029 0.92692692 0.08429465
## [13] 0.79277221 0.98492743 0.86306545 0.37499422 0.76453417 0.08468739
## [19] 0.27350071 0.66953603

# 生成20个服从形状参数为3，尺度参数为2的gama分布的随机数
x <- rgamma(n = 20, shape = 3, scale = 2)
x
##  [1]  6.317386  5.042931  8.876513  7.227442  2.247599  8.883344  3.427692
##  [8]  2.436724 11.369552  4.018859  5.099779  6.740469  2.191306  5.221806
## [15]  2.940425  8.655702  3.614262  8.788494 10.616150  2.964972
# 求服从形状参数为3，尺度参数为2的gama分布向量x的概率密度函数值
dgamma(x, shape = 3, scale = 2)
##  [1] 0.10596243 0.12769900 0.05819082 0.08798936 0.10262607 0.05808171
##  [7] 0.13230301 0.10973995 0.02744732 0.13533228 0.12693454 0.09763061
## [13] 0.10033445 0.12520473 0.12422100 0.06179065 0.13399613 0.05960898
## [19] 0.03487759 0.12476297
# 求服从形状参数为3，尺度参数为2的gama分布向量x的累积分布函数值
pgamma(x, shape = 3, scale = 2)
##  [1] 0.61140874 0.46168121 0.81935710 0.69967514 0.10442280 0.81975418
##  [7] 0.24643622 0.12451899 0.92239521 0.32587582 0.46891898 0.65448323
## [13] 0.09870988 0.48430405 0.18371381 0.80611305 0.27128918 0.81417293
## [19] 0.89901070 0.18676977

# 生成20个服从形状参数分别为1的Beta分布的随机数
x <- rbeta(n = 20, shape1 = 1, shape2 = 1)
x
##  [1] 0.79660744 0.50467387 0.76645191 0.86073788 0.87875092 0.62002253
##  [7] 0.79601010 0.04240078 0.62118242 0.16087523 0.29956688 0.08761189
## [13] 0.47825123 0.62239782 0.13313218 0.49265633 0.12450115 0.44091870
## [19] 0.45921615 0.60026017
# 求从形状参数分别为1的Beta分布向量x的概率密度函数值
dbeta(x, shape1 = 1, shape2 = 1)
##  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# 求从形状参数分别为1的Beta分布向量x的累积分布函数值
pbeta(x, shape1 = 1, shape2 = 1)
##  [1] 0.79660744 0.50467387 0.76645191 0.86073788 0.87875092 0.62002253
##  [7] 0.79601010 0.04240078 0.62118242 0.16087523 0.29956688 0.08761189
## [13] 0.47825123 0.62239782 0.13313218 0.49265633 0.12450115 0.44091870
## [19] 0.45921615 0.60026017


# 生成20个服从自由度为5的t分布随机数
x <- rt(n = 20, df = 5)
x
##  [1]  0.680986422  1.751271185 -1.080884615  1.138006032 -0.103673831
##  [6] -0.869132136 -1.138006529 -2.659956665  0.022885669 -1.051619854
## [11] -0.204058414 -0.172098812 -0.778091287 -2.158430150  2.166753835
## [16]  1.221889504  0.001106759 -1.120960044 -0.616716720 -0.351029962
# 求服从自由度为5的t分布向量x的概率密度函数值
dt(x, df = 5)
##  [1] 0.29091975 0.09038901 0.20218315 0.19021498 0.37716911 0.24889688
##  [7] 0.19021488 0.02694900 0.37948742 0.20844615 0.37027843 0.37293991
## [13] 0.26941265 0.05265887 0.05207441 0.17334242 0.37960641 0.19374871
## [19] 0.30465957 0.35286967
# 求服从自由度为5的t分布向量x的累积分布函数值
pt(x, df = 5)
##  [1] 0.73693354 0.92985382 0.16455150 0.84665397 0.46072910 0.21226116
##  [7] 0.15334594 0.02244312 0.50868664 0.17055978 0.42317678 0.43505440
## [13] 0.23585560 0.04167607 0.95875981 0.86189598 0.50042013 0.15661851
## [19] 0.28220808 0.36993628

# 生成20个服从自由度分别为5和10的F分布随机数
x <- rf(n = 20, df1 = 5, df2 = 10)
x
##  [1] 8.5945893 1.6391361 0.6012522 0.1589287 0.8421210 3.3608535 0.4575666
##  [8] 1.0977853 1.8094855 1.0542537 5.9180639 0.8440257 1.3668641 0.2928560
## [15] 0.7292180 0.6838293 0.2017240 7.2167597 0.4960476 0.2107341
# 求服从自由度分别为5和10的F分布向量x的概率密度函数值
df(x, df1 = 5, df2 = 10)
##  [1] 0.0009697105 0.2442702791 0.6732120987 0.3702128390 0.5743516208
##  [6] 0.0392514032 0.6844269557 0.4480501412 0.2010344902 0.4688832582
## [11] 0.0049211015 0.5734129088 0.3332970343 0.5896451039 0.6272414068
## [16] 0.6459445462 0.4569305748 0.0021213471 0.6875810599 0.4731661640
# 求服从自由度分别为5和10的F分布向量x的累积分布函数值
pf(x, df1 = 5, df2 = 10)
##  [1] 0.99782377 0.76355861 0.29909079 0.02783817 0.45042453 0.95139777
##  [7] 0.20084186 0.58099387 0.80136458 0.56103796 0.99153289 0.45151760
## [13] 0.68553052 0.09380220 0.38253054 0.35362865 0.04559326 0.99581341
## [19] 0.22725746 0.04978388

# 生成20个服从自由度为5的卡方分布随机数
x <- rchisq(n = 20, df = 5)
x
##  [1]  1.7919100  4.1681860  1.8372459  0.9566576  5.2853037  0.9049066
##  [7]  7.3505200  0.8423011  5.5762829  5.2230705 11.8115579  2.5685044
## [13]  6.9647706  7.0754314  9.0261423 11.1611700  3.2784440  3.6156812
## [19]  5.0112084 10.1914430
# 求服从自由度为5的卡方分布向量x的概率密度函数值
dchisq(x, df = 5)
##  [1] 0.13021313 0.14079893 0.13215599 0.07712373 0.11500179 0.07281091
##  [7] 0.06716156 0.06746624 0.10775354 0.11654732 0.01470288 0.15155338
## [13] 0.07512220 0.07277929 0.03954032 0.01869546 0.15324468 0.14994736
## [19] 0.12176779 0.02649102
# 求服从自由度为5的卡方分布向量x的累积分布函数值
pchisq(x, df = 5)
##  [1] 0.12287675 0.47453570 0.12882447 0.03401466 0.61793755 0.03013460
##  [7] 0.80415066 0.02574285 0.65034633 0.61073251 0.96253688 0.23385533
## [13] 0.77672642 0.78490944 0.89197404 0.95172354 0.34285652 0.39403962
## [19] 0.58548617 0.93001100

#####3.3.4 字符处理#####

# 计算字符串长度
nchar("R语言数据可视化")
## [1] 8
# 拼接字符串
paste("R语言", "数据可视化", sep = "", collapse = "")
## [1] "R语言数据可视化"
paste0("R语言", "数据可视化", collapse = "")
## [1] "R语言数据可视化"
# 拆分字符串
strsplit(x = "A;B;C;D;E;F;G", split = ";", fixed = T)
## [[1]]
## [1] "A" "B" "C" "D" "E" "F" "G"

x = c("R语言数据分析与可视化", "可视化", "如何使用R语言", "编写R语言函数",
      "R软件", "我喜欢R语言", "R", "数据分析")
x
# 查找字符串向量x中包含'R语言'并显示出其标号
grep(pattern = "R语言", x = x, ignore.case = FALSE, perl = FALSE,
     value = FALSE, fixed = FALSE, useBytes = FALSE, invert = FALSE)
# 查找字符串向量x中包含'R语言'并显示其下标
grep(pattern = "R语言", x = x, ignore.case = FALSE, perl = FALSE,
     value = TRUE, fixed = FALSE, useBytes = FALSE, invert = FALSE)
# 查找字符串向量x中是否包含'R语言'并返回逻辑值
grepl(pattern = "R语言", x = x, ignore.case = FALSE, perl = FALSE,
      fixed = FALSE, useBytes = FALSE)
# 查找字符串向量x中'R语言'字符所在的位置及匹配字符长度
regexpr(pattern = "R语言", text = x, ignore.case = FALSE, perl = FALSE,
        fixed = FALSE, useBytes = FALSE)
gregexpr(pattern = "R语言", text = x, ignore.case = FALSE, perl = FALSE,
         fixed = FALSE, useBytes = FALSE)
regexec(pattern = "R语言", text = x, ignore.case = FALSE, perl = FALSE,
        fixed = FALSE, useBytes = FALSE)
# 抽取字符串向量x中第1个字符至第3个字符
substr(x = x, start = 1, stop = 3)
# 抽取字符串向量x中第2个字符以后的所有字符
substring(text = x, first = 2, last = 1000000L)
# 将字符串向量x中的'R语言'替换为'r语言'
sub(pattern = "R语言", replacement = "r语言", x = x, ignore.case = FALSE,
    perl = FALSE, fixed = FALSE, useBytes = FALSE)
gsub(pattern = "R语言", replacement = "r语言", x = x, ignore.case = FALSE,
     perl = FALSE, fixed = FALSE, useBytes = FALSE)


#####3.4.1 R包管理#####

# 通过CRAN仓库方式安装ggplot2扩展包
install.packages(pkgs = "ggplot2", lib = "D:/Program Files/R/R-3.5.0/library", repos = "https://cloud.r-project.org", type = "both")
# 通过本地压缩包方式安装ggplot2扩展包
install.packages(pkgs = "D:/ggplot2_3.0.0.tar.gz", lib = "D:/Program Files/R/R-3.5.0/library", repos = NULL, type = "source")
# 查看已安装的R包，并显示前六个包
head(installed.packages(lib = "D:/Program Files/R/R-3.5.0/library"))
# 更新当前库内的R包
update.packages(lib.loc = "D:/Program Files/R/R-3.5.0/library",
                ask = FALSE, repos = "https://cloud.r-project.org")
# 卸载R包
remove.packages(pkgs = "ggplot2", lib = "D:/Program Files/R/R-3.5.0/library")



#####3.4.2 R包加载#####

# 使用library方式加载ggplot2包（library中存在该包）
result1 <- library("ggplot2")
result1
# 使用library方式加载abc包（library中不存在该包）
result2 <- library("abc")
result2
# 使用require方式加载ggplot2包（library中存在该包）
result3 <- require("ggplot2")
result3
# 使用require方式加载abc包（library中不存在该包）
result4 <- require("abc")
result4

#####3.4.3 自定义R包#####
#' Calculate descriptive statistics for a set of data
#'
#' @description Calculate descriptive statistics for a set of data
#' @param data data frame or matrix, data to be calculated
#' @param na.rm logical,whether NA values should be stripped before the computation proceeds.
#' @return calculate result
#' @importFrom stats quantile
#' @importFrom stats sd
#' @export stat
#' @examples
#' stat(data = iris[,c(-5)], na.rm = T)
#'
#'
stat <- function(data, na.rm = TRUE) {
  out <- t(apply(data, 2, function(x, na.rm) {
    c(length(x), mean(x, na.rm = na.rm), sd(x, na.rm = na.rm),
      max(x, na.rm = na.rm), min(x, na.rm = na.rm), quantile(x,
                                                             probs = c(0.25, 0.5, 0.75), na.rm = na.rm))
  }, na.rm = na.rm))
  colnames(out) <- c("n", "mean", "sd", "max", "min", "25%",
                     "50%", "75%")
  return(out)
}


#####3.5.1 环境空间的种类#####
# 当前环境(全局环境)
environment()
# 内部环境
e <- new.env()
e1
# 环境e的父环境
parent.env(e)
# 空环境
emptyenv()
# 包环境
baseenv()

##### 3.5.2 环境空间的使用#####

# 查看mean函数所在的环境空间
environment(mean)
## <environment: namespace:base>
# 新建环境空间e
e <- new.env(hash = TRUE, parent = parent.frame(), size = 29L)
# 判断e是否为环境空间
is.environment(e)
## [1] TRUE
# 查看e的属性值
env.profile(e)
## $size
## [1] 29
##
## $nchains
## [1] 0
##
## $counts
##  [1] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# 设置环境空间的名称
attr(e, "name") <- "e"
# 查看环境空间e的名称
environmentName(e)
## [1] "e"
rm(list = ls())
e1 <- new.env(hash = TRUE, parent = parent.frame(), size = 29L)
# 给e1环境空间添加变量
e1$x <- c(1, 2, 3, 4, 5, 6)
e1$y <- function() {
  "hello, world!"
}
assign(x = "z", value = "hello, world!", envir = e1)
# 查看当前环境空间和e1空间中的变量
ls()
## [1] "e1"
# 查看e1环境空间中的变量
ls(e1)
## [1] "x" "y" "z"
# 判断e1环境变量中x变量是否存在
exists("y", envir = e1)
## [1] TRUE
# 取出e1环境变量中的x和y值
get("x", envir = e1)
## [1] 1 2 3 4 5 6
get("y", envir = e1)
## function() {
##     "hello, world!"
## }
# 给e1环境变量中的x重新赋值
assign(x = "x", value = c(66, 67, 69), envir = e1)
get("x", envir = e1)
## [1] 66 67 69
# 删除e1环境空间中的变量
rm(x, envir = e1)
ls(e1)
## [1] "y" "z"

rm(list = ls())
# 定义变量x并查看其内存地址
x <- "hello, world!"
data.table::address(x)
## [1] "000000001CA19050"
# 对变量x进行赋值并查看其内存地址
x <- 1000
data.table::address(x)
## [1] "000000001CA18FA8"

rm(list = ls())
# 创建环境空间变量e1
e1 <- new.env()
# 将环境空间变量e1赋值给e2
e2 <- e1
# 给e1环境空间变量赋值
e1$x <- "hello, R!"
# 查看新环境空间变量e2
e2$x
## [1] "hello, R!"
# 比较e1环境和e2环境是否相同
identical(e1, e2)
## [1] TRUE
# 查看e1和e2的环境地址是否相同
data.table::address(e1)
## [1] "000000001C426FE8"
data.table::address(e2)
## [1] "000000001C426FE8"

rm(list = ls())
# 创建环境空间e1
e1 <- new.env()
parent.find <- function(e) {
  print(e)
  if (is.environment(e) & !identical(emptyenv(), e)) {
    parent.find(parent.env(e))
  }
}
# 递归查找环境空间e1的父空间
parent.find(e1)
## <environment: 0x0000000016afb090>
## <environment: R_GlobalEnv>
## <environment: package:stats>
## attr(,"name")
## [1] "package:stats"
## attr(,"path")
## [1] "d:/Program Files/R/R-3.5.2/library/stats"
## <environment: package:graphics>
## attr(,"name")
## [1] "package:graphics"
## attr(,"path")
## [1] "d:/Program Files/R/R-3.5.2/library/graphics"
## <environment: package:grDevices>
## attr(,"name")
## [1] "package:grDevices"
## attr(,"path")
## [1] "d:/Program Files/R/R-3.5.2/library/grDevices"
## <environment: package:utils>
## attr(,"name")
## [1] "package:utils"
## attr(,"path")
## [1] "d:/Program Files/R/R-3.5.2/library/utils"
## <environment: package:datasets>
## attr(,"name")
## [1] "package:datasets"
## attr(,"path")
## [1] "d:/Program Files/R/R-3.5.2/library/datasets"
## <environment: package:methods>
## attr(,"name")
## [1] "package:methods"
## attr(,"path")
## [1] "d:/Program Files/R/R-3.5.2/library/methods"
## <environment: 0x00000000176f46e8>
## attr(,"name")
## [1] "Autoloads"
## <environment: base>
## <environment: R_EmptyEnv>

