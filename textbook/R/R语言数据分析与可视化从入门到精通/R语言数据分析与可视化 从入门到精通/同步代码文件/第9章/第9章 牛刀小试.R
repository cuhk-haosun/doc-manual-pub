######牛刀小试:使用网格系统组合图形#########
p1 <- ggplot(iris,aes(x = Sepal.Length,y = ..density..)) + 
  geom_histogram(col = "black",fill = "white") +
  xlab(label  = NULL ) +
  ylab(label  = NULL )
p2 <- ggplot(iris,aes(x = Species,y = Sepal.Length)) + 
  geom_boxplot() +
  xlab(label  = NULL ) +
  ylab(label  = NULL )
p3 <- ggplot(iris,aes(x = Sepal.Length,y = ..density..)) + 
  geom_density() +
  xlim(3,9) +
  xlab(label  = NULL ) +
  ylab(label  = NULL )
p4 <- ggplot(iris,aes(x = Sepal.Length,y = Sepal.Width)) + 
  geom_point()

grid.newpage()
vp <-  viewport(layout = grid.layout(3,3,
                                     widths = c(3,1,3),
                                     heights = c(3,1,3)))
pushViewport(vp)
print(p1,vp = viewport(layout.pos.col = 1,layout.pos.row = 1))
print(p2,vp = viewport(layout.pos.col = 1,layout.pos.row = 3))
print(p3,vp = viewport(layout.pos.col = 3,layout.pos.row = 1))
print(p4,vp = viewport(layout.pos.col = 3,layout.pos.row = 3))
