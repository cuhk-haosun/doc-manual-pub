#####10.1.1 ggivs与ggplot2对比#####
library(ggplot2)
library(ggvis)
library(dplyr)
# ggplot2包绘制散点图
ggplot(mtcars)+ 
  geom_point(aes(x = wt, 
                 y = mpg), 
             colour = "red")

# ggvis包绘制散点图
ggvis(mtcars) %>%
  #重新计算mpg变量值
  mutate(mpg = mpg * 5) %>% 
  layer_points(x = ~wt, 
               y = ~mpg, 
               fill := "red")
#####10.1.2 绘图语法#####

# 将disp变量映射为x轴，mpg变量映射为y轴（见图10-3）
ggvis(mtcars) %>%
  layer_points(x = ~wt, 
               y = ~mpg)

# 将散点大小设置为300（像素）、边框为红色，填充颜色为蓝色，透明度90，形状为方形（见图10-4）
ggvis(mtcars) %>%
  layer_points(x = ~wt,
               y = ~mpg, 
               size := 300,
               stroke := "blue",
               fill := "red", 
               opacity := 75,
               shape := "circle")

# 使用vs变量对散点大小参数进行分组（见图10-5）
mtcars %>%
  ggvis(x = ~wt, 
        y = ~mpg, 
        size = ~vs) %>%
  layer_points()

# 使用vs变量对散点形状参数进行分组（见图10-6）
mtcars %>%
  ggvis(x = ~wt, 
        y = ~mpg, 
        shape = ~factor(vs)) %>%
  layer_points()

# 使用vs变量对散点大小参数进行分组（见图10-5）
mtcars %>%
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points(stroke := "black",
               fill := input_radiobuttons(
                 choices = c("红色" = "red",
                             "黄色" = "yellow",
                             "蓝色" = "blue"),
                 label = "颜色设置",
                 selected = "red"),
               opacity := input_slider(
                 min = 0.2,
                 max = 1,
                 step = 0.1,
                 label = "透明度设置"),
               size := input_slider(
                 min = 100,
                 max = 500,
                 step = 20,
                 label = "大小设置"),
               shape := input_select(
                 choices = c("圆形" = "circle",
                             "正方形" = "square",
                             "十字" = "cross",
                             "菱形" = "diamond",
                             "上三角形" = "triangle-up",
                             "下三角形" = "triangle-down"),
                 label = "形状设置",
                 selected = "circle") )

######10.1.3 图层######
# 散点图
mtcars %>% ggvis(x = ~wt, 
                 y = ~mpg) %>%
  layer_points()

# 折线图（图10-8）
df <- data.frame(x = 1:20, 
                 y = runif(20))
df %>% ggvis(x = ~x,
             y = ~y) %>% 
  layer_lines()

df %>% ggvis(x = ~x, 
             y = ~y) %>% 
  layer_paths()

# 面积图（图10-9）
df %>% ggvis(x = ~x,
             y = ~y, 
             y2 = 0) %>% 
  layer_ribbons(fill := "red")

# 条形图（图10-10）
pressure %>%
  ggvis(x = ~temperature, 
        y = ~pressure) %>%
  layer_bars(width = 10)

# 直方图（图10-11）
x=rnorm(10000)
df<- data.frame(x=x,
                y=dnorm(x))
df %>%
  ggvis(x = ~x) %>%
  layer_histograms()

# 概率密度图（图10-12）
df %>%
  ggvis(x = ~x) %>%
  layer_densities()

# 平滑曲线图（图10-13）
mtcars %>%
  ggvis(x = ~wt, 
        y = ~mpg) %>%
  layer_smooths(span = 1, 
                se = T)

# 箱型图（图10-14）
mtcars %>% ggvis(x = ~cyl,
                 y = ~mpg) %>%
  layer_boxplots(width = 0.5)

# 矩形图（图10-15）
df <- data.frame(x1 = runif(5), 
                 x2 = runif(5), 
                 y1 = runif(5), 
                 y2 = runif(5))
df %>% 
  ggvis(x1 = ~x1, 
        y1 = ~y1,
        x2 = ~x2, 
        y2 = ~y2, 
        fillOpacity := 0.1) %>% 
  layer_rects()

# 文字标签图（图10-16）
df <- data.frame(x = 3:1,
                 y = c(1, 3, 2), 
                 label = c("a", "b", "c"))
df %>% 
  ggvis(x = ~x, 
        y = ~y, 
        text := ~label) %>%
  layer_text(fontSize := 50)
# 给散点图添加趋势线
p<-mtcars %>% 
  ggvis(~wt, ~mpg) %>%
  layer_lines(strokeWidth := 2)%>%
  layer_points(fill := "white",
               stroke := "black",
               size := 100,
               shape := "circle")%>%
  layer_smooths(span = 1,
                strokeWidth := 5,
                stroke := "red",
                se = T)

#####10.1.4 图形修饰#####
mtcars %>% 
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points() %>%
  add_axis(type = "x",
           title = "Weight",
           title_offset = 60,
           ticks = 7,
           tick_size_major = 10,
           tick_size_minor = 5,
           tick_size_end = 15,
           tick_padding = 10,
           orient = "top",
           properties = axis_props(
             labels = list(
               fill = "steelblue",
               angle = 0,
               fontSize = 14,
               align = "middle",
               baseline = "middle",
               dx = 10),
             title = list(
               fontSize = 30),
             ticks = list(
               stroke = "red"),
           )) %>%
  add_axis(type = "x",
           title = "Weight",
           title_offset = 40,
           ticks = 7,
           tick_size_major = 10,
           tick_size_minor = 5,
           tick_size_end = 15,
           tick_padding = 10,
           orient = "bottom") %>%
  add_axis("y",
           title = "Miles per gallon", 
           title_offset = 50,
           orient = "left")
# 数值型坐标轴（图10-19）
mtcars %>%
  ggvis(x= ~wt, y = ~mpg) %>%
  layer_points()%>%
  scale_numeric(property = "x", 
                domain = c(1,6) , 
                label = "横坐标", 
                nice = FALSE) %>%
  scale_numeric(property = "y", 
                domain = c(5, 40), 
                label = "纵坐标",
                nice = FALSE)

# 名义型标度（图10-20）
mtcars %>%
  group_by(vs)%>%
  ggvis(x = ~wt, y = ~mpg, 
        fill = ~factor(vs)) %>%
  layer_points() %>%
  scale_nominal(property = "fill", 
                range = c("red","black"),
                label = "Engine")

# 时间型标度（图10-21）
df <- data.frame(
  time = as.Date("2019-05-01") + 0:9,
  value = seq(1, 10, 
              length.out = 10) + rnorm(10)
)
df %>% ggvis(x = ~time, 
             y = ~value) %>%
  layer_points() %>%
  scale_datetime(property = "x",
                 nice = "day",
                 label = "日期")
mtcars %>%
  ggvis(x= ~wt, 
        y = ~mpg, 
        fill = ~factor(vs)) %>%
  layer_points() %>%
  add_legend(scales = "fill",
             title = "Engine",
             orient = "right",
             values = c("1","0"))
data_labels <- function(x) {
  if(is.null(x)) 
    return(NULL)
  paste0(names(x), 
         ": ", format(x), 
         collapse = "<br />")
}
mtcars %>% 
  ggvis(x= ~wt, 
        y = ~mpg, 
        fill = ~factor(vs)) %>%
  layer_points(size := 200)%>%
  add_tooltip(html = data_labels,
              on = "hover")

#####10.2.1 对ggplot2的扩展#####
library(plotly)
library(ggplot2)
# 使用iris数据集创建ggplot绘图对象（图10-24）
p <- ggplot(data = iris, 
            aes(x = Sepal.Length,
                y = Sepal.Width,
                colour = Species)) +
  geom_point()
p

# 使用ggplotly函数将ggplot对象转换为plotly对象（图10-25）
ggplotly(p)


#####10.2.2 绘图语法#####
p <- plot_ly(data = iris, 
             x = ~Sepal.Length, 
             y = ~Petal.Length,
             type = "scatter") %>%
  layout(title = 'Styled Scatter',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p


# 重塑数据集
setosa_Sepal <- iris$Sepal.Length[which(iris$Species=="setosa")]
setosa_Petal <- iris$Petal.Length[which(iris$Species=="setosa")]
versicolor_Sepal <- iris$Sepal.Length[which(iris$Species=="versicolor")]
versicolor_Petal <- iris$Petal.Length[which(iris$Species=="versicolor")]
virginica_Sepal <- iris$Sepal.Length[which(iris$Species=="virginica")]
virginica_Petal <- iris$Petal.Length[which(iris$Species=="virginica")]

# 定义形状参数
setosa = list(
  type = 'circle',
  xref ='x', yref='y',
  x0=min(setosa_Sepal), 
  y0=min(setosa_Petal),
  x1=max(setosa_Sepal),
  y1=max(setosa_Petal),
  opacity=0.25,
  line = list(color="#835AF1"),
  fillcolor="#835AF1")

versicolor = list(
  type = 'circle',
  xref ='x', yref='y',
  x0=min(versicolor_Sepal), 
  y0=min(versicolor_Petal),
  x1=max(versicolor_Sepal), 
  y1=max(versicolor_Petal),
  opacity=0.25,
  line = list(color="#835AF1"),
  fillcolor="#835AF1")

virginica = list(
  type = 'circle',
  xref ='x', yref='y',
  x0=min(virginica_Sepal), 
  y0=min(virginica_Petal),
  x1=max(virginica_Sepal), 
  y1=max(virginica_Petal),
  opacity=0.25,
  line = list(color="#835AF1"),
  fillcolor="#835AF1")

# 创建按钮控件
buttons <- list(
  list(
    active = -1,
    type = 'buttons',
    buttons = list(
      
      list(
        label = "None",
        method = "relayout",
        args = list(list(
          shapes = c()))),
      
      list(
        label = "setosa",
        method = "relayout",
        args = list(list(
          shapes = list(setosa, c(), c())))),
      
      list(
        label = "versicolor",
        method = "relayout",
        args = list(list(
          shapes = list(c(), versicolor, c())))),
      
      list(
        label = "virginica",
        method = "relayout",
        args = list(list(
          shapes = list(c(), c(), virginica)))),
      
      list(
        label = "All",
        method = "relayout",
        args = list(list(
          shapes = list(setosa,versicolor,
                        virginica))))
    )
  )
)


# 创建按钮控件交互
p1 <- plot_ly(type = 'scatter',
              mode='markers') %>%
  add_trace(x=setosa_Sepal, 
            y=setosa_Petal, 
            mode='markers', 
            marker=list(
              color='#835AF1')) %>%
  add_trace(x=versicolor_Sepal, 
            y=versicolor_Petal, 
            mode='markers', 
            marker=list(
              color='#7FA6EE')) %>%
  add_trace(x=virginica_Sepal, 
            y=virginica_Petal, 
            mode='markers', 
            marker=list(
              color='#B8F7D4')) %>%
  layout(title = "Highlight Species(Buttons in R)",
         showlegend = FALSE,
         updatemenus = buttons)
p1

# 创建下拉框控件
dropdown <- list(
  list(
    type = 'dropdown',
    buttons = list(
      list(
        label = "None",
        method = "relayout",
        args = list(
          list(shapes = c()))),
      
      list(
        label = "setosa",
        method = "relayout",
        args = list(list(
          shapes = list(
            setosa, c(), c())))),
      
      list(
        label = "versicolor",
        method = "relayout",
        args = list(list(
          shapes = list(
            c(), versicolor, c())))),
      
      list(
        label = "virginica",
        method = "relayout",
        args = list(list(
          shapes = list(
            c(), c(), virginica)))),
      
      list(
        label = "All",
        method = "relayout",
        args = list(list(
          shapes = list(
            setosa,versicolor,
            virginica))))
    )
  )
)
# 创建下拉框控件交互
p2 <- plot_ly(type = 'scatter',
              mode='markers') %>%
  add_trace(x=setosa_Sepal, 
            y=setosa_Petal, 
            mode='markers', 
            marker=list(
              color='#835AF1')) %>%
  add_trace(x=versicolor_Sepal,
            y=versicolor_Petal,
            mode='markers', 
            marker=list(
              color='#7FA6EE')) %>%
  add_trace(x=virginica_Sepal,
            y=virginica_Petal,
            mode='markers',
            marker=list(
              color='#B8F7D4')) %>%
  layout(title = "Highlight Species(Dropdown Events in R)",
         showlegend = FALSE,
         updatemenus = dropdown)
p2

# 创建滑动条控件
slider <- list(
  list(
    active = 1,
    currentvalue = list(
      prefix = "Species: "),
    steps = list(
      list(
        label = "None",
        value = "1",
        method = "relayout",
        args = list(
          list(shapes = c()))),
      
      list(
        label = "setosa",
        method = "relayout",
        value = "2",
        args = list(list(
          shapes = list(
            setosa, c(), c())))),
      
      list(
        label = "versicolor",
        method = "relayout",
        value = "3",
        args = list(list(
          shapes = list(
            c(),versicolor, c())))),
      
      list(
        label = "virginica",
        method = "relayout",
        value = "4",
        args = list(list(
          shapes = list(
            c(), c(), virginica)))),
      
      list(
        label = "All",
        method = "relayout",
        value = "5",
        args = list(list(
          shapes = list(
            setosa,versicolor,
            virginica))))
    )
  )
)

# 创建滑动条控件交互
p3 <- plot_ly(type = 'scatter', 
              mode='markers') %>%
  add_trace(x=setosa_Sepal, 
            y=setosa_Petal, 
            mode='markers', 
            marker=list(
              color='#835AF1')) %>%
  add_trace(x=versicolor_Sepal,
            y=versicolor_Petal, 
            mode='markers', 
            marker=list(
              color='#7FA6EE')) %>%
  add_trace(x=virginica_Sepal, 
            y=virginica_Petal, 
            mode='markers', 
            marker=list(
              color='#B8F7D4')) %>%
  layout(title = "Highlight Species(Sliders in R)",
         showlegend = FALSE,
         sliders = slider)
p3

p <- plot_ly(data = iris, 
             x = ~Sepal.Length, 
             y = ~Petal.Length,
             color = ~ Species,
             symbol = ~Species,
             symbols = c('circle','x','o'),
             marker = list(size = 10),
             type = 'scatter',
             mode = "makers") %>%
  layout(title = 'Highlight Species(Tooltip)',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))
p

#####10.2.3 绘图示例#####
# 以iris数据集为例创建绘图数据
data<-data.frame(
  Species=names(tapply(iris$Sepal.Length,
                       iris$Species,mean)),
  Sepal.Length=c(tapply(iris$Sepal.Length,
                        iris$Species,mean)),
  Petal.Length=c(tapply(iris$Petal.Length,
                        iris$Species,mean)))

# 绘制单组条形图（图10-32）
p1_1 <- plot_ly(data = data,
                x = ~Species,
                y = ~Sepal.Length,
                name = "Sepal.Length",
                type = "bar")
p1_1

# 绘多组条形图（图10-33）
p1_2 <- p1_1 %>%
  add_bars(y = ~Petal.Length,
           name = "Petal.Length") %>%
  layout(yaxis = list(title = 'Length'),
         barmode = 'group')
p1_2

# 绘制堆积条形图（图10-34）
p1_3 <- p1_1 %>%
  add_bars(y = ~Petal.Length,
           name = "Petal.Length") %>%
  layout(yaxis = list(title = 'Length'),
         barmode = 'stack')
p1_3


trace_0 <- rnorm(100, mean = 15)
trace_1 <- rnorm(100, mean = 10)
trace_2 <- rnorm(100, mean = 5)
x <- c(1:100)

data <- data.frame(x, 
                   trace_0,
                   trace_1, 
                   trace_2)

p2 <- plot_ly(data, x = ~x, 
              y = ~trace_0, 
              name = "lines",
              type = "scatter", 
              mode = "lines") %>%
  add_trace(y = ~trace_1, 
            name = "lines+points",
            mode = "lines+markers") %>%
  add_trace(y = ~trace_2,
            name = "points", 
            mode = "markers")
p2

x = seq(from = -4,to = 4,by = 0.1)
norm1 <- data.frame(x = x,
                    y = dnorm(x, 
                              mean = 0,
                              sd = 1))

norm2 <- data.frame(x = x,
                    y = dnorm(x, 
                              mean = 0,
                              sd = 0.5))

p3 <- plot_ly(x = ~norm1$x,
              y = ~norm1$y,
              type = "area",
              mode = "area",
              name = "norm1", 
              fill = "tozeroy") %>%
  add_trace(x = ~norm2$x,
            y = ~norm2$y,
            mode = "area",
            name = "norm2", 
            fill = "tozeroy") %>%
  layout(xaxis = list(title = "x"),
         yaxis = list(title = "y"))
p3

# 构建绘图数据集
data<-data.frame(Category = c("类别1","类别2",
                              "类别3","类别4",
                              "类别5"),
                 values = c(0.35,0.25,
                            0.20,0.15,0.05),
                 stringsAsFactors = T)

# 绘制饼图（图10-37）
p4_1 <- plot_ly(data = data,
                labels = ~Category,
                values = ~values) %>%
  add_pie()

p4_1

# 绘制圆环图（图10-38）
p4_2 <- plot_ly(data = data,
                labels = ~Category,
                values = ~values) %>%
  add_pie(hole = 0.5)
p4_2

p5 <- plot_ly(x = ~iris$Sepal.Length,
              name = "Sepal Length",
              type ="box") %>%
  add_trace(x = ~iris$Sepal.Width,
            mode = "box",
            name = "Sepal Width") %>%
  add_trace(x = ~iris$Petal.Length,
            mode = "box",
            name = "Petal Length") %>%
  add_trace(x = ~iris$Petal.Width,
            mode = "box",
            name = "Petal Width") %>%
  layout(xaxis = list(title = ""))
p5

# 方式1
p6_1 <- plot_ly(x = rnorm(1000),
                type = "histogram",
                marker = list(
                  color = "rgb(158,202,225)",
                  line = list(
                    color = "rgb(8,48,107)",
                    width = 1.5)),
                histnorm = "probability")
p6_1

# 方式2
p6_2 <- plot_ly(x = rnorm(1000))%>%
  add_histogram(marker = list(color = "rgb(158,202,225)",
                              line = list(
                                color = "rgb(8,48,107)",
                                width = 1.5)),
                histnorm = "probability")
p6_2

# 构建数据集
data <- data.frame(x = c("A","B","C",
                         "D","E","F"),
                   trace1 = c(40,50,60,
                              30,50,40),
                   trace2 = c(70,60,70,
                              35,25,70),
                   stringsAsFactors = F)

p7 <- plot_ly(
  type = "scatterpolar",
  mode = "makers",
  fill = "toself") %>%
  add_trace(
    r = c(data$trace1,data$trace1[1]),
    theta = c(data$x,data$x[1]),
    name = "类别1") %>%
  add_trace(
    r = c(data$trace2,data$trace2[1]),
    theta = c(data$x,data$x[1]),
    name = "类别2") %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,100)
      )
    ),
    showlegend = T
  )
p7

library(plotly)
library(quantmod)

# 获取百度股票的交易数据
getSymbols("BIDU",src = 'yahoo')
data <- data.frame(Date = index(BIDU),
                   coredata(BIDU))

# 绘制时间序列图（图10-42）
p8_1 <- plot_ly(data = data,
                x = ~Date,
                mode = 'lines',
                text = paste("距今",
                             Sys.Date() -
                               data$Date,"天")) %>%
  add_trace(
    y = ~BIDU.Volume,
    name = "成交量") %>%
  layout(xaxis = list(title = "日期"),
         yaxis = list(title = "成交量"))
p8_1

#  绘制K线图（图10-43）
p8_2 <- plot_ly(data = data,
                x = ~Date,
                type="candlestick",
                open = ~BIDU.Open, 
                close = ~BIDU.Close,
                high = ~BIDU.High, 
                low = ~BIDU.Low,
                name = "k线") %>%
  add_lines(x = ~Date, 
            y = ~BIDU.Adjusted, 
            name = "ADJ",
            line = list(color = "black", 
                        width = 1), 
            inherit = F) %>%
  layout(showlegend = T,
         xaxis = list(
           title = "日期"),
         yaxis = list(
           title = "价格(美元)"))
p8_2

library(gapminder)
# 获取世界各地预期寿命与人均GDP数据集gapminder
p9 <- gapminder %>%
  plot_ly(
    x = ~gdpPercap, 
    y = ~lifeExp, 
    size = ~pop,
    color = ~continent,
    frame = ~year, 
    text = ~country, 
    hoverinfo = "text",
    type = 'scatter',
    mode = 'markers'
  ) %>%
  
  layout(
    xaxis = list(
      title = "人均GDP",
      type = "log"),
    yaxis = list(
      title = "预期寿命")) %>%
  animation_slider(
    currentvalue = list(
      prefix = "当前年度 ", 
      font = list(color = "red"))) %>%
  animation_button(label = "播放") %>%
  animation_opts(1000, 
                 easing = "elastic", 
                 redraw = T)
p9

data <- iris[,c("Species",
                "Sepal.Length",
                "Sepal.Width",
                "Petal.Length",
                "Petal.Width")]
header = list(
  values = c(colnames(data)),
  align = c(rep("center",
                ncol(data))),
  height =20,
  line = list(width = 1, 
              color = "grey90"),
  fill = list(color = "blue"),
  font = list(family = "Arial",
              color = 'white', 
              size = 14)
)

cells = list(
  values = t(data),
  align = c(rep("center",
                ncol(data))),
  height =20,
  line = list(width = 1, 
              color = "grey"),
  fill = list(color = "grey90"),
  font = list(family = "Arial",
              color = 'black', 
              size = 12)
)
p10<- plot_ly(
  type = 'table',
  header = header,
  cells = cells)
p10

#####10.2.4 图形修饰#####
# 同一张图形插入子图（图10-46）
library(plotly)
library(quantmod)
getSymbols("BIDU",src = 'yahoo')
data <- data.frame(Date = index(BIDU),
                   coredata(BIDU))
data1 <- tail(data,10)
data2 <- tail(data,5)
p1_1 <- plot_ly() %>%
  add_trace(x = data1$Date,
            y = data1$BIDU.Volume,
            name = "近10日成交量",
            mode = "makers") %>%
  add_trace(x = data2$Date,
            y = data2$BIDU.Volume,
            xaxis = "x2",
            yaxis = "y2",
            name = "近五日成交量",
            mode = "makers") %>%
  layout(xaxis2 = list(
    domain = c(0.05, 0.4), 
    anchor = "y2"),
    yaxis2 = list(
      domain = c(0.6, 0.95),
      anchor = "x2"))
p1_1

# 多个图形拼接（图10-47）
p1_2 <- subplot(p8_1, p8_2,
                nrows = 2,
                widths = 1,
                heights = c(0.4,0.6),
                margin = 0.05,
                shareX = T,
                shareY = F,
                titleX = T,
                titleY = T)
p1_2

# 字体样式设置
font1 <- list(
  family = "Arial, sans-serif",
  size = 18,
  color = "grey")

font2 <- list(
  family = "Arial, sans-serif",
  size = 20,
  color = "black")

xaxis <- list(
  #坐标轴标题设置
  title = "横坐标",
  titlefont = font2,
  
  # 轴线样式设置
  zeroline = TRUE,
  showline = TRUE,
  mirror = TRUE,
  gridcolor = toRGB("white"),
  gridwidth = 0.5,
  zerolinecolor = toRGB("red"),
  zerolinewidth = 4,
  linecolor = toRGB("black"),
  linewidth = 2,
  outer = FALSE,
  
  # 轴须样式设置
  autotick = FALSE,
  ticks = "outside",
  tick0 = 0,
  dtick = 10,
  ticklen = 5,
  tickwidth = 2,
  tickcolor = toRGB("black"),
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = font1,
  
  # 标度
  range = c(0,101))

yaxis <- list(
  #坐标轴标题设置
  title = "纵坐标",
  titlefont = font2,
  
  # 轴线样式设置
  zeroline = TRUE,
  showline = TRUE,
  mirror = TRUE,
  gridcolor = toRGB("white"),
  gridwidth = 0.5,
  zerolinecolor = toRGB("red"),
  zerolinewidth = 4,
  linecolor = toRGB("black"),
  linewidth = 2,
  outer = FALSE,
  
  # 轴须样式设置
  autotick = FALSE,
  ticks = "outside",
  tick0 = 0,
  dtick = 5,
  ticklen = 5,
  tickwidth = 2,
  tickcolor = toRGB("black"),
  showticklabels = TRUE,
  tickangle = 0,
  tickfont = font1,
  
  # 标度
  range = c(0,22))
p2 <- p2 %>%
  layout(xaxis = xaxis,
         yaxis = yaxis)
font3 <- list(
  family = "Arial, sans-serif",
  size = 14,
  color = "black")
legend = list(orientation = "h",
              x = 0.5,
              y = 0.95,
              xanchor = "center",
              yanchor = "middle",
              itemclick = "toggle",
              itemdoubleclick ="toggleothers",
              font = font3,
              bgcolor = toRGB("white"),
              bordercolor = toRGB("white"),
              borderwidth = 0.5)

p2 <- p2 %>%
  layout(legend = legend,
         title = "折线与散点图示例",
         font = font2)
margins<- list(
  l = 10,  #左边界
  r = 10,  #右边界
  b = 50,  #上边界
  t = 50,  #下边界
  pad = 2) #绘图区域和坐标轴间的间距
p2 <- layout(p2,
             autosize = F,
             width = 1000,
             height = 500,
             margin = margins)
p2





