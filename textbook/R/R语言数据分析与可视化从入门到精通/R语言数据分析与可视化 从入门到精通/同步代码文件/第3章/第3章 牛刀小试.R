#####牛刀小试#####
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
