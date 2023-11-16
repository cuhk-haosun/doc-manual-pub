library(shiny)
library(ggplot2)
library(ggvis)
library(plotly)
shinyUI(
  fluidPage(
    headerPanel("绘制直方图示例"),
    sidebarPanel(
      sliderInput(inputId = "n",label = "样本数：",min = 1000, 
                  max = 5000,value = 3000, step = 200),
      numericInput(inputId = "mean",label = "平均数:",value = 500, 
                   min = 300, max = 800, step = 100),
      numericInput(inputId = "sd", label = "标准差:", value = 100, 
                   min = 50, max = 150, step = 10)
    ),
    mainPanel(
      h3("ggplot2图形输出"),
      plotOutput(outputId = "plot_ggplot2"),
      h3("ggvis图形输出"),
      ggvisOutput("plot_ggvis"),
      h3("plotly图形输出"),
      plotlyOutput(outputId = "plot_plotly")
      )
    )
)