#####牛刀小试#####
library(plotly)
x=rnorm(1000)
tmp<-hist(x,breaks=seq(min(x),max(x),diff(range(x))/30),
          plot =F)

plot_data<-data.frame(x=tmp$mids,
                      counts=tmp$counts,
                      density=dnorm(tmp$mids,mean(x),sd(x))*diff(range(x))/30*length(x))

p1<-plot_ly(data = plot_data)%>%
  add_bars(x = ~x,
           y = ~counts,
           marker = list(
             color = "rgb(158,202,225)",
             line = list(
               color = "rgb(8,48,107)",
               width = 1.5)),
           width=0.2,
           name=NULL)%>%
  add_lines(x = ~x,
            y = ~density,
            name=NULL)%>%
  layout(showlegend = FALSE)

p2<-plot_ly(x = ~x,
            type ="box")%>%
  layout(showlegend = FALSE)
subplot(p1, p2,
        nrows = 2,
        widths = 1,
        heights = c(0.8,0.2),
        margin = 0,
        shareX = T,
        shareY = F,
        titleX = T,
        titleY = T)