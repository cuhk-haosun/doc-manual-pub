shinyServer(function(input, output, session) {
  main <- reactive({
   data<-rnorm(n = input$n,mean = input$mean,sd = input$sd)
   return(data)
  })
  output$plot_ggplot2<-renderPlot({
    data<-main()
    data<-data.frame(V1=as.numeric(data))
   ggplot(data, aes(x=V1)) + 
      geom_histogram( breaks=seq(min(data$V1),max(data$V1),width), 
                      colour="white",fill="#4F81BD")+
      labs(title="",x="X",y="count")+
      theme_bw()
  })
  
  output$plot_ggvis<-renderUI({
    data<-main()
    data<-data.frame(V1=as.numeric(as.matrix(data)))
    data%>%ggvis(x = ~V1) %>%layer_histograms(fill := "#4F81BD")%>%
      bind_shiny("plot_ggvis")
  })
  
  output$plot_plotly<-renderPlotly({
    data<-main()
    data<-data.frame(V1=as.numeric(data))
    axis = list( zeroline = TRUE,showline = TRUE,mirror = TRUE,
                gridcolor = toRGB("white"),gridwidth = 0.5,
                zerolinecolor = toRGB("black"),zerolinewidth = 4,
                linecolor = toRGB("black"),
                linewidth = 2,autotick =T,ticks = "outside",
                ticklen = 5,tickwidth = 2,tickcolor = toRGB("black"),
                showticklabels = TRUE,tickangle = 0)
    plot_ly()%>%
      add_histogram(x=data$V1,
                    marker = list(color = "#4F81BD",
                                  line = list(color = "white",width = 1.5)))%>%
      layout(xaxis = axis ,
             yaxis = axis ,
             showlegend = FALSE)
  })
})
