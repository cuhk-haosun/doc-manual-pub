library(shiny)
ui <- fluidPage(
  fluidRow(
    column(width = 4),
    column(width = 4,
           h1("shiny控件示例")),
    column(width = 4)
  ),
  br(),
  hr(),

  fluidRow(
    column(width=3,
           h2("按钮控件"),
           br(),
           actionButton(inputId = "actionButton",
                        label = "动作按钮"),
           br(),
           br(),
           submitButton(text = "提交按钮")

    ),
    column(width=3,
           h2("单个复选框"),
           br(),
           checkboxInput(inputId = "checkboxInput",
                         label = "是否同意")


    ),
    column(width=3,
           h2("整组复选框"),
           br(),
           checkboxGroupInput(inputId = "checkboxGroupInput",
                              label = "请选择：",
                              choices = c("选择1"="1",
                                          "选择2"="2",
                                          "选择3"="3"))


    ),
    column(width=3,
           h2("单选按钮"),
           br(),
           radioButtons(inputId = "radioButtons",
                        label = "请选择：",
                        choices = c("选择1"="1",
                                    "选择2"="2",
                                    "选择3"="3"))


    )
  ),
  hr(),
  fluidRow(
    column(width = 3,
           h2("日期输入框"),
           dateInput(inputId = "dateInput",
                     label = "选择日期：",
                     value = "2019-02-20",
                     min = "2019-1-1",
                     max = "2019-12-31",
                     format = "yyyy-mm-dd",
                     language = "zh-CN")

    ),
    column(width = 3,
           h2("日期跨度输入框"),
           dateRangeInput(inputId = "dateRangeInput",
                          label = "选择日期跨度：",
                          start = "2019-1-1",
                          end = "2019-12-31",
                          format = "yyyy-mm-dd",
                          language = "zh-CN")

    ),
    column(width = 3,
           h2("文件输入"),
           fileInput(inputId = "fileInput",
                     label = "请选择文件：",
                     accept = c(
                       "text/csv",
                       "text/comma-separated-values,
                       text/plain",
                       ".csv"))

    ),
    column(width = 3,
           h2("帮助文字"),
           helpText("注: 这是帮助文字")
    )
  ),
  hr(),
  fluidRow(
    column(width = 3,
           h2("数值输入框"),
           numericInput(inputId = "numericInput",
                        label = "输入一个数：",
                        value = 5,
                        min = 0,
                        max = 10,
                        step = 1)

    ),
    column(width = 3,
           h2("下拉框"),
           selectInput(inputId = "selectInput",
                       label = "下拉选择：",
                       choices = c("选择1"="1",
                                   "选择2"="2",
                                   "选择3"="3"),
                       multiple = T,
                       selected = "2"

           )

    ),
    column(width = 3,
           h2("滑动条"),
           sliderInput(inputId = "sliderInput",
                       label = "滑动选择一个数：",
                       value = 5,
                       min = 0,
                       max = 10,
                       step = 1)

    ),
    column(width = 3,
           h2("文字输入"),
           textInput(inputId = "textInput",
                     label = "请输入文字：",
                     value = "文字"),
           br(),
           br(),
           textAreaInput(inputId = "textInput",
                         label = "请输入文字：",
                         value = "一段文字")

    )

  )
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)

