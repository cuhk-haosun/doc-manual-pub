#####11.1.1 输出为位图文件#####
library(ggplot2)
p<-ggplot(mtcars)+ 
  geom_point(aes(x = wt, 
                 y = mpg), 
             colour = "red")

jpeg(filename = "example1.jpg",
     width = 960,
     height = 540,
     units = "px", 
     pointsize = 96)

p
dev.off()

png(filename = "example1.png",
    width = 960,
    height = 540,
    units = "px", 
    pointsize = 96)

p
dev.off()

bmp(filename = "example1.bmp",
    width = 960,
    height = 540,
    units = "px",
    pointsize = 96)

p
dev.off()

tiff(filename = "example1.tiff",
     width = 960,
     height = 540,
     units = "px", 
     pointsize = 96)

p
dev.off()

jpeg(filename = "example2.jpg",
     width = 12,
     height = 10,
     units = "cm", 
     res = 512)
p
dev.off()

png(filename = "example2.png",
    width = 12,
    height = 10,
    units = "cm", 
    res = 512)
p
dev.off()

bmp(filename = "example2.bmp",
    width = 12,
    height = 10,
    units = "cm", 
    res = 512)
p
dev.off()

tiff(filename = "example2.tiff",
     width = 12,
     height = 10,
     units = "cm", 
     res = 512)
p
dev.off()
#####11.1.2 输出为PDF文件#####

pdf(file = "example1.pdf",
    width = 7,
    height = 5,
    pointsize = 12
)
p
dev.off()

#####11.1.3 输出为矢量图#####
svg(filename = "example.svg",
    width = 7,
    height = 5,
    family = "sans",
    pointsize = 12
)
p
dev.off()

cairo_pdf(filename = "example2.pdf",
          width = 7,
          height = 5,
          pointsize = 12)
p
dev.off()
