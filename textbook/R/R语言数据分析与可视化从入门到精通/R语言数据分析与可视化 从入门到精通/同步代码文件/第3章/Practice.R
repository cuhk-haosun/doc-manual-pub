CumSum <- function(x) {
  out <- NULL
  for (i in 1:length(x)) {
    out <- c(out, sum(c(x[1:i])))
    print(out)
  }
  return(out)
}
# 测试CumSum函数
CumSum(x = c(1, 3, 4, 6, 7))
## [1] 1
## [1] 1 4
## [1] 1 4 8
## [1]  1  4  8 14
## [1]  1  4  8 14 21
## [1]  1  4  8 14 21

