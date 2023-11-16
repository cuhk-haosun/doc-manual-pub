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

stat <- function(data, na.rm = TRUE){
  out<-t(apply(data,2,function(x, na.rm){
    c(length(x),
      mean(x,na.rm = na.rm),
      sd(x,na.rm = na.rm),
      max(x,na.rm = na.rm),
      min(x,na.rm = na.rm),
      quantile(x,probs = c(0.25,0.5,0.75), na.rm = na.rm))

    }, na.rm = na.rm))
  colnames(out) <- c("n","mean","sd","max","min","25%","50%","75%")
  return(out)
}