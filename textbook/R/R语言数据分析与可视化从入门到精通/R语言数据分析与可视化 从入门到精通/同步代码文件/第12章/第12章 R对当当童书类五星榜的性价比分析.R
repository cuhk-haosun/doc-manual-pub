#####12.1.2 编写爬虫程序#####
library(rvest)
## Loading required package: xml2
library(stringi)
url = "http://bang.dangdang.com/books/fivestars/01.41.70.00.00.00-all-0-0-1-1"
x <- read_html(x = url,encoding = "GBK")
total_page<-max(as.numeric(html_nodes(x,"div.paginating")%>%
                             html_nodes("li")%>%html_nodes("a")%>%
                             html_text()),na.rm = T)
total_page
## [1] 25

url_2<-paste0(stri_replace_all_fixed(url,"0-0-1-1","0-0-1-"),2)
url_2
## [1] "http://bang.dangdang.com/books/fivestars/01.41.70.00.00.00-all-0-0-1-2"

# 获取页面数据并抽取ul和li标签数据
x <- read_html(x = url_2,encoding = "GBK")
ul <- html_nodes(x,"ul.bang_list")
li <- html_nodes(ul,"li")

# 图书编号
book_number<-html_nodes(li,"div.list_num")%>%html_text()

# 图书名称
book_title<-html_nodes(li,"div.name")%>%html_nodes("a")%>%
  html_text("title")

# 图书介绍链接
book_link<-html_nodes(li,"div.name")%>%html_nodes("a")%>%
  stringi::stri_extract( regex = '(?<=href=\").*?(?=\")')

# 推荐指数
book_tuijian<-html_nodes(li,"div.star")%>%
  html_nodes("span.tuijian")%>%html_text()%>%
  stringi::stri_replace_all(replacement = "",regex = "推荐")

# 评论链接
tuijian_link<-html_nodes(li,"div.star")%>%
  html_nodes("a")%>%
  stringi::stri_extract( regex = '(?<=href=\").*?(?=\")')

# 评论人数
tuijian_count<-html_nodes(li,"div.star")%>%
  html_nodes("a")%>%html_text()%>%
  stringi::stri_replace_all(replacement = "",regex = "条评论")

# 五星推荐人数
tuijian_five_star<-html_nodes(li,"div.biaosheng")%>%
  html_text()%>%
  stringi::stri_replace_all(replacement = "",regex = "五星评分：")%>%
  stringi::stri_replace_all(replacement = "",regex = "次")

# 图书作者
book_author<-as.matrix(html_nodes(li,"div.publisher_info")%>%
                         html_text(trim=T))[c(seq(1,40,2))]

# 出版社及出版日期
book_publisher<-as.matrix(html_nodes(li,"div.publisher_info")%>%
                            html_text(trim=T))[c(seq(0,40,2))]

# 现价
book_price_now<-apply(as.matrix(1:length(html_nodes(li,"div.price"))),1,
                      function(x){
                        out<-html_nodes(html_nodes(li,"div.price")[x],"span.price_n")%>%
                          html_text()
                        return(out[1])
                      })
# 原价
book_price_old<-apply(as.matrix(1:length(html_nodes(li,"div.price"))),1,
                      function(x){
                        out<-html_nodes(html_nodes(li,"div.price")[x],"span.price_r")%>%
                          html_text()
                        return(out[1])
                      })

# 折扣
book_price_cutoff<-apply(as.matrix(1:length(html_nodes(li,"div.price"))),1,
                         function(x){
                           tmp<-html_nodes(html_nodes(li,"div.price")[x],"span.price_s")%>%
                             html_text()
                           out<-stringi::stri_replace_all(str=tmp[1],
                                                          replacement = "",regex = "折")
                           return(out)
                         })

data<-data.frame(book_number,book_title,
                 book_link,book_author,
                 book_publisher,
                 book_price_now,
                 book_price_old,
                 book_price_cutoff,
                 book_tuijian,tuijian_link,
                 tuijian_count,tuijian_five_star)
head(data,3)
##   book_number               book_title
## 1         21. 14只老鼠（第1辑，全6册）
## 2         22.       我不敢说，我怕被骂
## 3         23.                       人
##                                   book_link
## 1 http://product.dangdang.com/20817211.html
## 2 http://product.dangdang.com/24144615.html
## 3 http://product.dangdang.com/20179351.html
##                                           book_author
## 1                        （日）岩村和朗　著，彭懿　译
## 2 文：〔荷兰〕皮姆?范?赫斯特  图：〔荷兰〕妮可?塔斯马
## 3                          （美）史比尔　著，李威　译
##                       book_publisher book_price_now book_price_old
## 1       2010-03-01<U+00A0>接力出版社        ￥62.90        ￥82.80
## 2 2016-09-01<U+00A0>北京联合出版公司        ￥34.10        ￥34.80
## 3   2008-04-01<U+00A0>贵州人民出版社         ￥7.20        ￥18.00
##   book_price_cutoff book_tuijian
## 1               7.6        99.1%
## 2               9.8         100%
## 3               4.0        98.7%
##                                                    tuijian_link
## 1 http://product.dangdang.com/20817211.html?point=comment_point
## 2 http://product.dangdang.com/24144615.html?point=comment_point
## 3 http://product.dangdang.com/20179351.html?point=comment_point
##   tuijian_count tuijian_five_star
## 1         20438                 2
## 2        276749              6017
## 3         20676                 0


GetBookInfor<-function(url){
  # 获取页面数据并抽取ul和li标签数据
  x <- read_html(x = url,encoding = "GBK")
  ul <- html_nodes(x,"ul.bang_list")
  li <- html_nodes(ul,"li")
  
  # 图书编号
  book_number<-html_nodes(li,"div.list_num")%>%html_text()
  
  # 图书名称
  book_title<-html_nodes(li,"div.name")%>%html_nodes("a")%>%
    html_text("title")
  
  # 图书介绍链接
  book_link<-html_nodes(li,"div.name")%>%html_nodes("a")%>%
    stringi::stri_extract( regex = '(?<=href=\").*?(?=\")')
  
  # 推荐指数
  book_tuijian<-html_nodes(li,"div.star")%>%
    html_nodes("span.tuijian")%>%html_text()%>%
    stringi::stri_replace_all(replacement = "",regex = "推荐")
  
  # 评论链接
  tuijian_link<-html_nodes(li,"div.star")%>%
    html_nodes("a")%>%
    stringi::stri_extract( regex = '(?<=href=\").*?(?=\")')
  
  # 评论人数
  tuijian_count<-html_nodes(li,"div.star")%>%
    html_nodes("a")%>%html_text()%>%
    stringi::stri_replace_all(replacement = "",regex = "条评论")
  
  # 五星推荐人数
  tuijian_five_star<-html_nodes(li,"div.biaosheng")%>%
    html_text()%>%
    stringi::stri_replace_all(replacement = "",regex = "五星评分：")%>%
    stringi::stri_replace_all(replacement = "",regex = "次")
  
  # 图书作者
  book_author<-as.matrix(html_nodes(li,"div.publisher_info")%>%
                           html_text(trim=T))[c(seq(1,40,2))]
  
  # 出版社及出版日期
  book_publisher<-as.matrix(html_nodes(li,"div.publisher_info")%>%
                              html_text(trim=T))[c(seq(0,40,2))]
  
  # 现价
  book_price_now<-apply(as.matrix(1:length(html_nodes(li,"div.price"))),1,
                        function(x){
                          out<-html_nodes(html_nodes(li,"div.price")[x],"span.price_n")%>%
                            html_text()
                          return(out[1])
                        })
  # 原价
  book_price_old<-apply(as.matrix(1:length(html_nodes(li,"div.price"))),1,
                        function(x){
                          out<-html_nodes(html_nodes(li,"div.price")[x],"span.price_r")%>%
                            html_text()
                          return(out[1])
                        })
  
  # 折扣
  book_price_cutoff<-apply(as.matrix(1:length(html_nodes(li,"div.price"))),1,
                           function(x){
                             tmp<-html_nodes(html_nodes(li,"div.price")[x],"span.price_s")%>%
                               html_text()
                             out<-stringi::stri_replace_all(str=tmp[1],
                                                            replacement = "",regex = "折")
                             return(out)
                           })
  
  out<-data.frame(book_number,book_title,
                  book_link,book_author,
                  book_publisher,
                  book_price_now,
                  book_price_old,
                  book_price_cutoff,
                  book_tuijian,tuijian_link,
                  tuijian_count,tuijian_five_star)
  return(out)
}
# 函数测试
GetBookInfor(url="http://bang.dangdang.com/books/fivestars/01.41.70.00.00.00-all-0-0-1-2")[c(1:3),] 

GetFiveStarBook<-function(PageList){
  PageList<-as.matrix(PageList)
  data<-log<-NULL
  start_time<-Sys.time()
  # 图书类别循环
  for ( i in 1:nrow(PageList)){
    
    # 获取该类别的网页数量
    url<- PageList[i,2]
    x <- read_html(x = url,encoding = "GBK")
    total_page<-max(as.numeric(html_nodes(x,"div.paginating")%>%html_nodes("li")%>%html_nodes("a")%>%html_text()),na.rm = T)
    url_tmp<-stri_replace_all_fixed(url,"0-0-1-1","0-0-1-")
    
    data_tmp<-NULL
    # 页面循环
    for (j in 1:total_page){
      cat("正在抓取【",PageList[i,1],"】第",j,"页","\n")
      
      go<-try({
        # 调用先前封装的GetBookInfor函数抓取每个页面的数据
        tmp<-GetBookInfor(url=paste0(url_tmp,j))
      })
      
      used_time<- as.numeric(difftime(Sys.time(),start_time,units = "secs"))
      
      if ("try-error"%in%class(go)){
        status=0
        message=paste0("页面抓取失败，详细请参考【",go[1],"】")
        cat(message,"\n")
        next
      }else{
        status=1
        message=paste0("页面抓取成功，累计用时：",used_time,"秒！")
        data_tmp<-rbind(data_tmp,
                        cbind(PageList[i,1],tmp))
        cat(message,"\n")
      }
      
      log<-rbind(log,
                 c(PageList[i,],j,status,message))
      
      
      
    }
    data<-rbind(data,
                data_tmp)
    
  }
  colnames(data)[1]<-c("book_category")
  colnames(log)<-c("category","url","page_number","status","message")
  out<-list(data=data,
            log=log)
  return(out)
}

# 函数测试
PageList<-matrix(c("绘本/图画书",
                   "http://bang.dangdang.com/books/fivestars/01.41.70.00.00.00-all-0-0-1-1"),ncol=2)
tmp<-GetFiveStarBook(PageList=PageList)
head(tmp$log[c(1:3),])
head(tmp$data[c(1:3),])

#####12.1.3 抓取数据并保存#####
PageList<-read.csv(file = "当当童书五星榜单访问地址.csv")
res_book_infor<-GetFiveStarBook(PageList=PageList)

dim(res_book_infor$data)

saveRDS(res_book_infor$data,
        file = "当当童书五星榜单数据.rds")


#####12.2.1 变量（字符）拆分与抽取#####
data_raw<-readRDS(file =  "当当童书五星榜单数据.rds")
data_raw<-as.matrix(data_raw)
library(stringi)
VaribleSplit<-function(x){
  out_tmp<-unlist(stri_split_charclass(str=x,
                                       pattern="\\p{WHITE_SPACE}",
                                       n=2,
                                       omit_empty=T))
  if (length(out_tmp)==2){
    return(out_tmp)
  }else{if (length(out_tmp)==1){
    if(stri_detect(str=out_tmp,regex = "[0-9]")){
      return(c(out_tmp,NA))
    }else{
      return(c(NA,out_tmp))
    }
  }else{
    return(c(NA,NA))
  }}
}

# 拆分book_publisher字段为publish_date和publisher
data_clean<-cbind(data_raw,
                  t(apply(as.matrix(data_raw[,"book_publisher"]),1,VaribleSplit)))
colnames(data_clean)[c(ncol(data_clean)-1,ncol(data_clean))]=c("publish_date","publisher")

# 拆分book_author字段
book_author<- data.frame(book_author=c(unlist(strsplit(data_clean[,"book_author"],"，",fixed=T))))

# 将book_number字段中的“.”去掉
data_clean[,"book_number"]=stri_replace_all(str = data_clean[,"book_number"],
                                            replacement = "",regex = "[.]")
# 将book_price_now、book_price_old字段中的“￥”字符去掉
data_clean[,"book_price_now"]=substr(x = data_clean[,"book_price_now"],
                                     start = 2,
                                     stop = nchar(data_clean[,"book_price_now"]))

data_clean[,"book_price_old"]=substr(x = data_clean[,"book_price_old"],
                                     start = 2,
                                     stop = nchar(data_clean[,"book_price_old"]))

# 将book_tuijian字段中的“%”字符去掉
data_clean[,"book_tuijian"]=substr(x = data_clean[,"book_tuijian"],
                                   start = 1,
                                   stop = nchar(data_clean[,"book_tuijian"])-1)
head(data_clean,3)
##      book_category book_number
## [1,] "绘本/图画书" "1"        
## [2,] "绘本/图画书" "2"        
## [3,] "绘本/图画书" "3"        
##      book_title                                                      
## [1,] "不一样的卡梅拉（第二辑   全三册）"                             
## [2,] "学会爱自己（勇敢表达篇 ） 自我认可，拒绝霸凌！学会大声说“不..."
## [3,] "不一样的卡梅拉第11册----我不是胆小鬼"                          
##      book_link                                  
## [1,] "http://product.dangdang.com/20531735.html"
## [2,] "http://product.dangdang.com/23170830.html"
## [3,] "http://product.dangdang.com/22522677.html"
##      book_author                                       
## [1,] "（法）约里波瓦 著，（法）艾利施 图，郑迪蔚 译"   
## [2,] "（美）史蒂芬柯洛"                                
## [3,] "（法）约里波瓦　著，（法）艾利施　图，郑迪蔚　译"
##      book_publisher                                  book_price_now
## [1,] "2009-04-01<U+00A0>二十一世纪出版社集团有限公司发行部" "17.60"       
## [2,] "2013-01-01<U+00A0>青岛出版社"                  "49.30"       
## [3,] "2011-10-01<U+00A0>２１世纪出版社"              "5.80"        
##      book_price_old book_price_cutoff book_tuijian
## [1,] "26.40"        "6.7"             "99.2"      
## [2,] "58.00"        "8.5"             "99.8"      
## [3,] "8.80"         "6.6"             "99.5"      
##      tuijian_link                                                   
## [1,] "http://product.dangdang.com/20531735.html?point=comment_point"
## [2,] "http://product.dangdang.com/23170830.html?point=comment_point"
## [3,] "http://product.dangdang.com/22522677.html?point=comment_point"
##      tuijian_count tuijian_five_star publish_date
## [1,] "145477"      "0"               "2009-04-01"
## [2,] "131147"      "1719"            "2013-01-01"
## [3,] "81841"       "0"               "2011-10-01"
##      publisher                           
## [1,] "二十一世纪出版社集团有限公司发行部"
## [2,] "青岛出版社"                        
## [3,] "２１世纪出版社"

#####12.2.2 检测数据缺失与重复值#####
FindMissingAndReplicate<-function(x){
  x[which(x=="")]=NA
  out<-c(
    length(x),
    length(which(is.na(x)==F)),
    length(which(is.na(x)==T)),
    length(unique(x)),
    length(which(table(x)==1)),
    length(which(table(x)>1))
  )
  names(out)<-c("样本总数","有效样本数",
                "缺失样本数","变量水平数",
                "变量水平非重复数","变量水平重复数")
  return(out)
}
data_check<-t(apply(data_clean, 2, FindMissingAndReplicate)) 
data_check
##                   样本总数 有效样本数 缺失样本数 变量水平数
## book_category         6560       6560          0         14
## book_number           6560       6560          0        500
## book_title            6560       6560          0       6531
## book_link             6560       6560          0       6560
## book_author           6560       6462         98       4338
## book_publisher        6560       6553          7       3378
## book_price_now        6560       6560          0       1403
## book_price_old        6560       6060        500        601
## book_price_cutoff     6560       6060        500         90
## book_tuijian          6560       6560          0         75
## tuijian_link          6560       6560          0       6560
## tuijian_count         6560       6560          0       4291
## tuijian_five_star     6560       6560          0        869
## publish_date          6560       6435        125        640
## publisher             6560       6259        301        406
##                   变量水平非重复数 变量水平重复数
## book_category                    0             14
## book_number                      0            500
## book_title                    6505             26
## book_link                     6560              0
## book_author                   3620            717
## book_publisher                2240           1137
## book_price_now                 639            764
## book_price_old                 247            353
## book_price_cutoff               10             79
## book_tuijian                    17             58
## tuijian_link                  6560              0
## tuijian_count                 2997           1294
## tuijian_five_star              547            322
## publish_date                   368            271
## publisher                      143            262
# 清理publisher字段中的错误表述
data_clean[which(data_clean[,c("publisher")]%in%c("其他",".")),c("publisher")]=NA
data_clean[which(data_clean[,c("publisher")]%in%c("２１世纪出版社")),c("publisher")]="二十一世纪出版社"

#####12.2.3 变量类型转化与重命名#####
data_clean<-as.data.frame(data_clean,
                          stringsAsFactors = F)
data_clean$book_number<-as.numeric(data_clean$book_number)
data_clean$book_price_now<-as.numeric(data_clean$book_price_now)
data_clean$book_price_old<-as.numeric(data_clean$book_price_old)
data_clean$book_price_cutoff<-as.numeric(data_clean$book_price_cutoff)
data_clean$book_tuijian<-as.numeric(data_clean$book_tuijian)
data_clean$tuijian_count<-as.numeric(data_clean$tuijian_count)
data_clean$tuijian_five_star<-as.numeric(data_clean$tuijian_five_star)
data_clean$publish_date<-as.Date(data_clean$publish_date)
str(data_clean) 
## 'data.frame':    6560 obs. of  15 variables:
##  $ book_category    : chr  "绘本/图画书" "绘本/图画书" "绘本/图画书" "绘本/图画书" ...
##  $ book_number      : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ book_title       : chr  "不一样的卡梅拉（第二辑   全三册）" "学会爱自己（勇敢表达篇 ） 自我认可，拒绝霸凌！学会大声说“不..." "不一样的卡梅拉第11册----我不是胆小鬼" "不一样的卡梅拉第10册-我要救出贝里奥" ...
##  $ book_link        : chr  "http://product.dangdang.com/20531735.html" "http://product.dangdang.com/23170830.html" "http://product.dangdang.com/22522677.html" "http://product.dangdang.com/20838132.html" ...
##  $ book_author      : chr  "（法）约里波瓦 著，（法）艾利施 图，郑迪蔚 译" "（美）史蒂芬柯洛" "（法）约里波瓦　著，（法）艾利施　图，郑迪蔚　译" "（法）克利斯提昂•约里波瓦　文，（法）克利斯提昂•艾利施　图，郑迪蔚　译" ...
##  $ book_publisher   : chr  "2009-04-01<U+00A0>二十一世纪出版社集团有限公司发行部" "2013-01-01<U+00A0>青岛出版社" "2011-10-01<U+00A0>２１世纪出版社" "2010-04-01<U+00A0>２１世纪出版社" ...
##  $ book_price_now   : num  17.6 49.3 5.8 7 56.5 23 23 25.8 23 23 ...
##  $ book_price_old   : num  26.4 58 8.8 8.8 84.8 29.8 29.8 45 29.8 29.8 ...
##  $ book_price_cutoff: num  6.7 8.5 6.6 8 6.7 7.7 7.7 5.7 7.7 7.7 ...
##  $ book_tuijian     : num  99.2 99.8 99.5 99.6 99.5 98.7 99 100 99 99.4 ...
##  $ tuijian_link     : chr  "http://product.dangdang.com/20531735.html?point=comment_point" "http://product.dangdang.com/23170830.html?point=comment_point" "http://product.dangdang.com/22522677.html?point=comment_point" "http://product.dangdang.com/20838132.html?point=comment_point" ...
##  $ tuijian_count    : num  145477 131147 81841 82613 94720 ...
##  $ tuijian_five_star: num  0 1719 0 0 2 ...
##  $ publish_date     : Date, format: "2009-04-01" "2013-01-01" ...
##  $ publisher        : chr  "二十一世纪出版社集团有限公司发行部" "青岛出版社" "二十一世纪出版社" "二十一世纪出版社" ...

library(dplyr)
## Warning: package 'dplyr' was built under R version 3.5.3
## 
## Attaching package: 'dplyr'
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
# 规范变量命名及对特定字段变量排序
data_clean<-rename(data_clean,
                   pulish_infor=book_publisher,
                   price_now=book_price_now,
                   price_old=book_price_old,
                   price_cutoff = book_price_cutoff,
                   tuijian_index=book_tuijian,
                   tuijian_fivestar=tuijian_five_star,
                   publisher_name = publisher)%>%
  mutate(tuijian_index_rank = min_rank(desc(tuijian_index)),
         tuijian_count_rank = min_rank(desc(tuijian_count)),
         tuijian_fivestar_rank = min_rank(desc(tuijian_fivestar)),
         price_now_rank = min_rank(desc(price_now)),
         price_old_rank = min_rank(desc(price_old)),
         price_cutoff_rank = min_rank(desc(price_cutoff)),
         book_id = seq(1,nrow(data_clean),1))
head(data_clean,3)
##   book_category book_number
## 1   绘本/图画书           1
## 2   绘本/图画书           2
## 3   绘本/图画书           3
##                                                       book_title
## 1                              不一样的卡梅拉（第二辑   全三册）
## 2 学会爱自己（勇敢表达篇 ） 自我认可，拒绝霸凌！学会大声说“不...
## 3                           不一样的卡梅拉第11册----我不是胆小鬼
##                                   book_link
## 1 http://product.dangdang.com/20531735.html
## 2 http://product.dangdang.com/23170830.html
## 3 http://product.dangdang.com/22522677.html
##                                        book_author
## 1    （法）约里波瓦 著，（法）艾利施 图，郑迪蔚 译
## 2                                 （美）史蒂芬柯洛
## 3 （法）约里波瓦　著，（法）艾利施　图，郑迪蔚　译
##                                           pulish_infor price_now price_old
## 1 2009-04-01<U+00A0>二十一世纪出版社集团有限公司发行部      17.6      26.4
## 2                         2013-01-01<U+00A0>青岛出版社      49.3      58.0
## 3                     2011-10-01<U+00A0>２１世纪出版社       5.8       8.8
##   price_cutoff tuijian_index
## 1          6.7          99.2
## 2          8.5          99.8
## 3          6.6          99.5
##                                                    tuijian_link
## 1 http://product.dangdang.com/20531735.html?point=comment_point
## 2 http://product.dangdang.com/23170830.html?point=comment_point
## 3 http://product.dangdang.com/22522677.html?point=comment_point
##   tuijian_count tuijian_fivestar publish_date
## 1        145477                0   2009-04-01
## 2        131147             1719   2013-01-01
## 3         81841                0   2011-10-01
##                       publisher_name tuijian_index_rank tuijian_count_rank
## 1 二十一世纪出版社集团有限公司发行部               3737                 78
## 2                         青岛出版社               1764                 93
## 3                   二十一世纪出版社               2762                144
##   tuijian_fivestar_rank price_now_rank price_old_rank price_cutoff_rank
## 1                  2961           3917           3354              3666
## 2                   169           1668           2097               220
## 3                  2961           6127           5733              4027
##   book_id
## 1       1
## 2       2
## 3       3

#####12.3.1 探索性数据分析#####

library(plotly)
library(dplyr)
# 各类别图书数量统计
explor_book_category<-group_by(data_clean,book_category)%>%
  summarise(count=n(),
            percent = n()/nrow(data_clean)*100)%>%
  arrange(desc(count))
p1 <-plot_ly(data = explor_book_category,
             labels = ~book_category,
             values = ~count,
             name = "图书类别构成") %>%
  add_pie(hole = 0.5)
p1

# 各类图书出版社数量统计
explor_book_publisher<-group_by(data_clean,publisher_name)%>%
  summarise(count=n(),
            percent = n()/nrow(data_clean)*100)%>%
  arrange(desc(count))
dim(explor_book_publisher)

explor_book_publisher<-na.omit(explor_book_publisher)[1:10,]
axis = list( zeroline = F,showline = TRUE,mirror = TRUE,
             gridcolor = toRGB("white"),gridwidth = 0.5,
             zerolinecolor = toRGB("black"),zerolinewidth = 4,
             linecolor = toRGB("black"),
             linewidth = 2,autotick =T,ticks = "outside",
             ticklen = 5,tickwidth = 2,tickcolor = toRGB("black"),
             showticklabels = TRUE,tickangle = 0)
p2<-plot_ly(data = explor_book_publisher,
            y = ~publisher_name,
            x = ~count,
            type = "bar")%>%
  layout(yaxis = axis,
         xaxis = axis)%>%
  layout(yaxis = list(title = "出版社",
                      ticktext = c(explor_book_publisher$publisher_name)),
         xaxis = list(title = "图书数量"))
p2

# 获取出版年份数据
publish_date<-data.frame(publish_date=substr(data_clean$publish_date,1,4))

# 统计各出版年份图书数量和占比情况
explor_publish_date <- group_by(publish_date,publish_date)%>%
  summarise(count=n(),
            percent = n()/nrow(data_clean)*100)%>%
  arrange(desc(publish_date))

dim(explor_publish_date)

p3<-plot_ly(data = explor_publish_date[1:10,],
            x = ~publish_date,
            y = ~count,
            type = "scatter",
            mode = "lines+markers",
            marker = list(symbol = "200",
                          size = 15))%>%
  layout(yaxis = axis,
         xaxis = axis)%>%
  layout(xaxis = list(title = "出版年份"),
         yaxis = list(title = "图书数量"))
p3

ExplorStat<-function(x){
  require(moments)
  x<-as.numeric(x)
  out<-c(length(x),length(na.omit(x)),
         mean(x,na.rm = T),
         sd(x,na.rm = T),
         sd(x,na.rm = T)/mean(x,na.rm = T),
         range(x,na.rm = T),
         quantile(x,probs = c(0.25,0.5,0.75),na.rm = T),
         kurtosis(x,na.rm = T),
         skewness(x,na.rm = T),
         unlist(shapiro.test(sample(x=na.omit(x),size = 5000,replace = F)))[1:2],
         unlist(agostino.test(na.omit(x)))[2:3])
  out<-round(as.numeric(out),3)
  names(out)<-c("样本量","有效样本量","平均数","标准差",
                "离散系数","最小值","最大值","第25百分位",
                "中位数","第75百分位","峰度","偏度",
                "Shapiro正态性检验(w)","Shapiro正态性检验(p)",
                "Agostino偏度检验(z)","Agostino偏度检验(p)")
  return(out)
}

# 图书价格指标的描述统计分析
explor_book_price<-apply(data_clean[,c("price_now",
                                       "price_old",
                                       "price_cutoff")],
                         2,ExplorStat)

ExplorHistogramPlot<-function(data,titleX=NULL,titleY=NULL){
  axis = list(zeroline = F,showline = TRUE,mirror = TRUE,
              gridcolor = toRGB("white"),gridwidth = 0.5,
              zerolinecolor = toRGB("black"),zerolinewidth = 4,
              linecolor = toRGB("black"),
              linewidth = 2,autotick =T,ticks = "outside",
              ticklen = 5,tickwidth = 2,tickcolor = toRGB("black"),
              showticklabels = TRUE,tickangle = 0)
  p<-plot_ly(x = ~data,
             type = "histogram",
             marker = list(
               color = "rgb(158,202,225)",
               line = list(
                 color = "rgb(8,48,107)",
                 width = 1.5)),
             histnorm = "count",
             name = "直方图")%>%
    # layout(xaxis = axis,
    #        yaxis = axis)%>%
    layout(xaxis = list(title=titleX),
           yaxis = list(title=titleY))
  return(p)
}

ExplorBoxPlot<-function(data,titleX=NULL,titleY=NULL){
  axis = list(zeroline = F,showline = TRUE,mirror = TRUE,
              gridcolor = toRGB("white"),gridwidth = 0.5,
              zerolinecolor = toRGB("black"),zerolinewidth = 4,
              linecolor = toRGB("black"),
              linewidth = 2,autotick =T,ticks = "outside",
              ticklen = 5,tickwidth = 2,tickcolor = toRGB("black"),
              showticklabels = TRUE,tickangle = 0)
  p<-plot_ly(x = ~data,
             type = "box",
             name = "箱型图")%>%
    # layout(xaxis = axis,
    #        yaxis = axis)%>%
    layout(xaxis = list(title=titleX),
           yaxis = list(title=titleY))
  return(p)
}

#图书现价分布图
p3_1<-ExplorHistogramPlot(data=data_clean$price_now,titleY = "频次")
p3_2<-ExplorBoxPlot(data=data_clean$price_now,titleY = "",titleX = "图书现价")

p3<-subplot(p3_1, p3_2,
            nrows = 2,
            widths = 1,
            heights = c(0.8,0.2),
            margin = 0,
            shareX = T,
            shareY = F,
            titleX = T,
            titleY = T)
p3

#图书原价分布图
p4_1<-ExplorHistogramPlot(data=data_clean$price_old,titleY = "频次")
p4_2<-ExplorBoxPlot(data=data_clean$price_old,titleY = "",titleX = "图书原价")
p4<-subplot(p4_1, p4_2,
            nrows = 2,
            widths = 1,
            heights = c(0.8,0.2),
            margin = 0,
            shareX = T,
            shareY = F,
            titleX = T,
            titleY = T)
p4

#图书折扣分布图
p5_1<-ExplorHistogramPlot(data=data_clean$price_cutoff,titleY = "频次")
p5_2<-ExplorBoxPlot(data=data_clean$price_cutoff,titleY = "",titleX = "图书折扣")
p5<-subplot(p5_1, p5_2,
            nrows = 2,
            widths = 1,
            heights = c(0.8,0.2),
            margin = 0,
            shareX = T,
            shareY = F,
            titleX = T,
            titleY = T)
p5

explor_book_pinglun<-apply(data_clean[,c("tuijian_index",
                                         "tuijian_count",
                                         "tuijian_fivestar")],
                           2,ExplorStat)
#图书推荐指数分布图
p6_1<-ExplorHistogramPlot(data=data_clean$tuijian_index,titleY = "频次")
p6_2<-ExplorBoxPlot(data=data_clean$tuijian_index,titleY = "",titleX = "推荐指数")

p6<-subplot(p6_1, p6_2,
            nrows = 2,
            widths = 1,
            heights = c(0.8,0.2),
            margin = 0,
            shareX = T,
            shareY = F,
            titleX = T,
            titleY = T)
p6

#图书评论数量分布图
p7_1<-ExplorHistogramPlot(data=data_clean$tuijian_count,titleY = "频次")
p7_2<-ExplorBoxPlot(data=data_clean$tuijian_count,titleY = "",titleX = "评论数量")
p7<-subplot(p7_1, p7_2,
            nrows = 2,
            widths = 1,
            heights = c(0.8,0.2),
            margin = 0,
            shareX = T,
            shareY = F,
            titleX = T,
            titleY = T)
p7

#图书五星推荐数量分布图
p8_1<-ExplorHistogramPlot(data=data_clean$tuijian_fivestar,titleY = "频次")
p8_2<-ExplorBoxPlot(data=data_clean$tuijian_fivestar,titleY = "",titleX = "五星推荐数量")
p8<-subplot(p8_1, p8_2,
            nrows = 2,
            widths = 1,
            heights = c(0.8,0.2),
            margin = 0,
            shareX = T,
            shareY = F,
            titleX = T,
            titleY = T)
p8

corrplot::corrplot(cor(na.omit(data_clean[,c("price_now",
                                             "price_old",
                                             "price_cutoff","tuijian_index",
                                             "tuijian_count",
                                             "tuijian_fivestar")])),
                   method = "number",
                   type = "upper",
                   tl.srt = 45) 


######12.3.2 图书价格和评论指标的聚类分析######
data_cluser<-apply(data_clean[,c("price_now","price_old","price_cutoff","tuijian_index","tuijian_count","tuijian_fivestar")],
                   2,scale,center = T,scale = T)
rownames(data_cluser)<-data_clean$book_id
colnames(data_cluser)<-c("price_now_z","price_old_z","price_cutoff_z","tuijian_index_z","tuijian_count_z","tuijian_fivestar_z")
data_cluser<-na.omit(data_cluser)

library(ggfortify)
## Warning: package 'ggfortify' was built under R version 3.5.3
## Loading required package: ggplot2
## Warning: package 'ggplot2' was built under R version 3.5.3
set.seed(1000)
advance_book_cluser<-kmeans(x = na.omit(data_cluser),
                            centers = 3,
                            iter.max = 100,
                            nstart = 30)

advance_book_cluser$size
## [1]  675   50 5335
advance_book_cluser$centers
##   price_now_z price_old_z price_cutoff_z tuijian_index_z tuijian_count_z
## 1   1.8893762   2.0121517     0.37759173      0.47573050       0.1594486
## 2   0.7916975   0.7067284     0.56372996      0.87691547       8.1886317
## 3  -0.2768694  -0.2612069    -0.05305734     -0.09753685      -0.0789219
##   tuijian_fivestar_z
## 1         0.07700257
## 2         6.38250682
## 3        -0.05897891
p9<-autoplot(advance_book_cluser,data=na.omit(data_cluser),label = F,lable.size=2,frame = TRUE)+
  theme_bw()



data_cluser<-data.frame(data_cluser,
                        book_cluser=advance_book_cluser$cluster,
                        book_id=rownames(data_cluser),
                        stringsAsFactors = F)
FTest<-function(x,group){
  data=na.omit(data.frame(x,group))
  
  out<-c(tapply(data$x,data$group,mean),c(unlist(oneway.test(x~ group, data = data)))[c(1:4)])
  out<-round(as.numeric(out),3)
  names(out)<-c("类别1均值","类别2均值","类别3均值","F值","分子自由度","分母自由度","显著性")
  
  return(out)
}

test_cluser<-t(apply(data_cluser[,c("price_now_z","price_old_z",
                                    "price_cutoff_z","tuijian_index_z",
                                    "tuijian_count_z","tuijian_fivestar_z")],
                     2,FTest,group = data_cluser$book_cluser)) 
# 聚类结果汇总
data_clean<-merge(data_clean,
                  data_cluser,
                  by="book_id",
                  all=T)
data_clean$book_cluser<-factor(data_clean$book_cluser,
                               levels =c(1,2,3),
                               labels = c("性价比适中","性价比高","性价比低"),
                               ordered = T)


#####12.3.3 图书性价比分析#####
library(moments)
CompareStat<-function(x,group){
  data<-na.omit(data.frame(x,group))
  tmp<-tapply(data$x,data$group,function(x){
    out<-c(mean(x,na.rm = T),
           sd(x,na.rm = T),
           sd(x,na.rm = T)/mean(x,na.rm = T),
           range(x,na.rm = T),
           max(x,na.rm = T)-min(x,na.rm = T),
           quantile(x,probs = c(0.25,0.5,0.75),na.rm = T),
           kurtosis(x,na.rm = T),
           skewness(x,na.rm = T))
    out<-round(as.numeric(out),3)
    names(out)<-c( "平均数","标准差", "离散系数","最小值",
                   "最大值","全距","第25百分位","中位数",
                   "第75百分位","峰度","偏度")
    return(out)
  })
  
  out<-cbind(c(names(tmp)),
             matrix(c(unlist(tmp)),
                    nrow=length(tmp),
                    byrow = T))
  colnames(out)<-c("类别名称",names(tmp[[1]]))
  return(out)
}

ComPareBoxPlot<-function(x,group,titleX=NULL,titleY=NULL){
  require(plotly)
  axis = list( zeroline = F,showline = TRUE,mirror = F,
               gridcolor = toRGB("grey95"),gridwidth = 0.5,
               zerolinecolor = toRGB("black"),zerolinewidth = 4,
               linecolor = toRGB("black"),
               linewidth = 2,autotick =T,ticks = "outside",
               ticklen = 5,tickwidth = 2,tickcolor = toRGB("black"),
               showticklabels = TRUE,tickangle = 0)
  data<-data.frame(x,
                   group)
  data<-na.omit(data)
  
  p<-plot_ly(data = data,
             x = ~x,
             color = ~group,
             type = "box",
             showlegend = FALSE) %>%
    layout(xaxis=axis,yaxis=axis)%>%
    layout(xaxis = list(title=titleX),
           yaxis = list(title=titleY))
  return(p)
}

advance_book_price<-rbind(
  cbind("price_now",
        CompareStat(x = data_clean$price_now,
                    group = data_clean$book_cluser)),
  cbind("price_old",
        CompareStat(x = data_clean$price_old,
                    group = data_clean$book_cluser)),
  cbind("price_cutoff",
        CompareStat(x = data_clean$price_cutoff,
                    group = data_clean$book_cluser))
)
colnames(advance_book_price)[1]="价格指标"

p10_1<-ComPareBoxPlot(x=data_clean$price_now,
                      group = data_clean$book_cluser,
                      titleX = "图书现价")

p10_2<-ComPareBoxPlot(x=data_clean$price_old,
                      group = data_clean$book_cluser,
                      titleX = "图书原价")

p10_3<-ComPareBoxPlot(x=data_clean$price_cutoff,
                      group = data_clean$book_cluser,
                      titleX = "图书折扣")



p10<-subplot(p10_1, p10_2,p10_3,
             nrows = 1,
             widths = c(0.33,0.33,0.33),
             heights = 1,
             margin = 0.05,
             shareX = F,
             shareY = T,
             titleX = T,
             titleY = T)


advance_book_pinglun<-rbind(
  cbind("tuijian_index",
        CompareStat(x = data_clean$tuijian_index,
                    group = data_clean$book_cluser)),
  cbind("tuijian_count",
        CompareStat(x = data_clean$tuijian_count,
                    group = data_clean$book_cluser)),
  cbind("tuijian_fivestar",
        CompareStat(x = data_clean$tuijian_fivestar,
                    group = data_clean$book_cluser))
)
colnames(advance_book_pinglun)[1]="评论指标"

p11_1<-ComPareBoxPlot(x=data_clean$tuijian_index,
                      group = data_clean$book_cluser,
                      titleX = "推荐指数")

p11_2<-ComPareBoxPlot(x=data_clean$tuijian_count,
                      group = data_clean$book_cluser,
                      titleX = "评论数量")

p11_3<-ComPareBoxPlot(x=data_clean$tuijian_fivestar,
                      group = data_clean$book_cluser,
                      titleX = "五星推荐数量")



p11<-subplot(p11_1, p11_2,p11_3,
             nrows = 1,
             widths = c(0.33,0.33,0.33),
             heights = 1,
             margin = 0.05,
             shareX = F,
             shareY = T,
             titleX = T,
             titleY = T)
advance_book_tuijiancount<-filter(data_clean,
                                  tuijian_count_rank<=10)[,c("book_category","book_title","price_now",
                                                             "publisher_name","tuijian_index","tuijian_count",
                                                             "tuijian_fivestar","book_cluser")]

advance_book_fivestarcount<-filter(data_clean,
                                   tuijian_fivestar_rank<=10)[,c("book_category","book_title","price_now",
                                                                 "publisher_name","tuijian_index","tuijian_count",
                                                                 "tuijian_fivestar","book_cluser")]


axis = list(zeroline = F,showline = TRUE,mirror = TRUE,
            gridcolor = toRGB("white"),gridwidth = 0.5,
            zerolinecolor = toRGB("black"),zerolinewidth = 4,
            linecolor = toRGB("black"),
            linewidth = 2,autotick =T,ticks = "outside",
            ticklen = 5,tickwidth = 2,tickcolor = toRGB("black"),
            showticklabels = TRUE,tickangle = 0)
p12_1<-plot_ly(data=data_clean,
               x = ~price_now,
               y = ~tuijian_count,
               color = ~book_cluser,
               size = ~price_cutoff,
               text = ~book_title,
               type = "scatter",
               showlegend = FALSE)%>%
  layout(xaxis=axis,
         yaxis=axis)%>%
  layout(yaxis=list(title= "评论数量"))

p12_2<-plot_ly(data=data_clean,
               x = ~price_now,
               y = ~tuijian_fivestar,
               color = ~book_cluser,
               size = ~price_cutoff,
               text = ~book_title,
               type = "scatter")%>%
  layout(xaxis=axis,
         yaxis=axis)%>%
  layout(xaxis=list(title= "图书价格"),
         yaxis=list(title= "五星推荐数量"))


p12<-subplot(p12_1, p12_2,
             nrows = 2,
             widths = 1,
             heights = c(0.5,0.5),
             margin = 0,
             shareX = F,
             shareY = F,
             titleX = T,
             titleY = T) 
