#####牛刀小试#####
n_row<-seq(2000,2000*10,2000)
n_col<-seq(50,50*10,50)
file<-paste0("dataset",1:10)

for (i in 1:10){
  data<-matrix(c(rnorm(n_row[i]*n_col[i])),nrow = n_row[i])
  
  colnames(data)<-paste0("col",1:n_col[i])
  
  data_size<-format(object.size(data),units="Kb")
  
  time1<-system.time({
    write.table(x=data,
                file = paste0(file[i],".txt"),
                append = FALSE,
                row.names = FALSE,
                sep = ",",
                fileEncoding = "GBK")
  })
  
  time2<-system.time({
    tmp1<-read.table(file = paste0(file[i],".txt"),
                     sep = ",",
                     fileEncoding = "GBK")
  })
  
  time3<-system.time({
    openxlsx::write.xlsx(x = as.data.frame(data),
                         file = paste0(file[i],".xlsx"),
                         asTable = TRUE)
  })
  
  time4<-system.time({
    tmp2<-openxlsx::read.xlsx(xlsxFile = paste0(file[i],".xlsx"), sheet = 1 )
    
  })
  
  cat("数据集：",file[i],";大小：",data_size,";",nrow(data),"行",ncol(data),"列","\n")
  
  cat("write.table用时：",time1[3],"秒; write.xlsx用时：",time3[3],"秒","\n")
  
  cat("read.table用时：",time2[3],"秒; read.xlsx用时：",time4[3],"秒","\n")
}