
####### 4.1.2导入带有分隔符的文本数据######
data <- read.table(file = "airquality.txt", header = T, sep = ",",  stringsAsFactor = F, fileEncoding = "UTF-8")
head(data)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6

#####4.1.3 导入Excel数据#####
if (!require("openxlsx")){
  install.packages("openxlsx")
}
## Loading required package: openxlsx
## Warning: package 'openxlsx' was built under R version 3.5.3
sheet_name <- openxlsx::getSheetNames(file = "airquality.xlsx");sheet_name
## [1] "airquality"
data <- openxlsx::read.xlsx(xlsxFile = "airquality.xlsx", sheet = sheet_name[1] )
# head(data)
data <- openxlsx::read.xlsx(xlsxFile = "airquality.xlsx", sheet = 1 )
head(data)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6

if (!require("xlsx")){
  install.packages("xlsx")
}
## Loading required package: xlsx
## Warning: package 'xlsx' was built under R version 3.5.3
##
## Attaching package: 'xlsx'
## The following objects are masked from 'package:openxlsx':
##
##     createWorkbook, loadWorkbook, read.xlsx, saveWorkbook,
##     write.xlsx
# 方式1：指定工作簿序号
data <- xlsx::read.xlsx(file = "airquality.xlsx", sheetIndex = 1 ,sheetName = NULL)
head(data)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6
# 方式2：指定工作簿名称
data <- xlsx::read.xlsx(file = "airquality.xlsx", sheetIndex = NULL ,sheetName = "airquality")
head(data)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6

if (!require("XLConnect")){
  install.packages("XLConnect")
}
library("XLConnect")

# 方式1：加载工作薄方式读取
wb <- XLConnect::loadWorkbook(filename = "airquality.xlsx", create = T)
sheet_index <- XLConnect::getSheets(wb)

data <- XLConnect::readWorksheet(wb, sheet = sheet_index[1])
head(data)
# 方式2：直接读取Excel文件
data <- XLConnect::readWorksheetFromFile(file="airquality.xlsx",sheet = 1)
head(data)

if (!require("readxl")){
  install.packages("readxl")
}
## Loading required package: readxl
## Warning: package 'readxl' was built under R version 3.5.3
data <- readxl::read_excel(path = "airquality.xlsx", sheet = 1, range = NULL, col_names = TRUE,col_types = NULL,na = "", trim_ws = TRUE)
head(data)
## # A tibble: 6 x 6
##   Ozone Solar.R  Wind  Temp Month   Day
##   <chr> <chr>   <dbl> <dbl> <dbl> <dbl>
## 1 41    190       7.4    67     5     1
## 2 36    118       8      72     5     2
## 3 12    149      12.6    74     5     3
## 4 18    313      11.5    62     5     4
## 5 NA    NA       14.3    56     5     5
## 6 28    NA       14.9    66     5     6

#####4.1.4 读取数据库数据#####
library("RODBC")

# 连接SQLServer
SQLServer<- RODBC::odbcConnect(dsn = 'RToSQLServer',uid = 'liuy',pwd = 'Ly123456')
head(RODBC::sqlTables(SQLServer))
##   TABLE_CAT        TABLE_SCHEM          TABLE_NAME TABLE_TYPE REMARKS
## 1   example                dbo          airquality      TABLE    <NA>
## 2   example                dbo                iris      TABLE    <NA>
## 3   example                dbo            lkzh2019      TABLE    <NA>
## 4   example                sys trace_xe_action_map      TABLE    <NA>
## 5   example                sys  trace_xe_event_map      TABLE    <NA>
## 6   example INFORMATION_SCHEMA   CHECK_CONSTRAINTS       VIEW    <NA>
# 连接MySQL
MySQL<- RODBC::odbcConnect(dsn = 'RToMySQL',uid = 'liuy',pwd = 'liuyadmin123456')
head(RODBC::sqlTables(MySQL))
##   TABLE_CAT TABLE_SCHEM TABLE_NAME TABLE_TYPE REMARKS
## 1   example             airquality      TABLE
## 2   example                   iris      TABLE
# 连接PostgreSQL
PostgreSQL<- RODBC::odbcConnect(dsn = 'RToPostgreSQL',uid = 'liuy',pwd = 'liuyadmin123456')
head(RODBC::sqlTables(PostgreSQL))
##   TABLE_CAT TABLE_SCHEM TABLE_NAME TABLE_TYPE REMARKS
## 1   example      public airquality      TABLE
## 2   example      public       iris      TABLE
RODBC::odbcCloseAll()

if (!require("RPostgreSQL")){
  install.packages("RPostgreSQL")
}

library("RPostgreSQL")
drv = dbDriver("PostgreSQL")
con <- RPostgreSQL::dbConnect(drv,
                              dbname = "example",
                              host = "192.168.1.111",
                              port = 5432,
                              user = "liuy",
                              password = "liuyadmin123456")
RPostgreSQL::dbListTables(con)
RPostgreSQL::dbDisconnect(con)

library("RMySQL")
## Warning: package 'RMySQL' was built under R version 3.5.3
## Loading required package: DBI
if (!require("RMySQL")){
  install.packages("RMySQL")
}

con <- RMySQL::dbConnect(drv = RMySQL::MySQL(),
                         dbname = "example",
                         host = "192.168.1.179",
                         port = 3306,
                         username = "liuy",
                         password = "liuyadmin123456")
RMySQL::dbListTables(con)

library("RODBC")

SQLServer<- RODBC::odbcConnect('RToSQLServer',uid='liuy',pwd='Ly123456')

data<-RODBC::sqlQuery(channel = SQLServer,
                      query = "select * from airquality")
head(data)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6
RODBC::odbcClose(SQLServer)    #关闭数据库连接
library("RMySQL")
if (!require("RMySQL")){
  install.packages("RMySQL")
}

con <- RMySQL::dbConnect(drv=RMySQL::MySQL(),
                         dbname = "example",
                         host = "192.168.1.179",
                         port = 3306,
                         username = "liuy",
                         password = "liuyadmin123456")
RMySQL::dbListTables(con)
## [1] "airquality" "iris"
data1 <- RMySQL::dbReadTable(conn = con,
                             name = "airquality")
head(data1)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118    8   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6
res <- RMySQL::dbSendQuery(conn = con,
                           statement = "select * from airquality")
data2 <- RMySQL::dbFetch(res = res)
head(data2)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118    8   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6
RMySQL::dbDisconnect(con)
## Warning: Closing open result sets
## [1] TRUE

library("RPostgreSQL")
drv = dbDriver("PostgreSQL")
con <- RPostgreSQL::dbConnect(drv = drv,
                              dbname = "example",
                              host = "192.168.1.111",
                              port = 5432,
                              user = "liuy",
                              password = "liuyadmin123456")
RPostgreSQL::dbListTables(con)

data1 <- RPostgreSQL::dbReadTable(conn = con,
                                  name = "airquality")
head(data1)

data2 <- RPostgreSQL::dbGetQuery(conn = con,
                                 statement = "select * from airquality")
head(data2)
RPostgreSQL::dbDisconnect(con)

#####4.1.5 导入其他统计工具的数据#####
# foreign包读取electric.sav数据集
library("foreign")
file<-system.file("files", "electric.sav", package = "foreign")
data<-foreign::read.spss(file = file, use.value.labels = TRUE, to.data.frame = TRUE, use.missings = TRUE)
str(data)
## 'data.frame':    240 obs. of  13 variables:
##  $ CASEID  : num  13 30 53 84 89 102 117 132 151 153 ...
##  $ FIRSTCHD: Factor w/ 5 levels "NO CHD","SUDDEN  DEATH",..: 3 3 2 3 2 3 3 3 2 2 ...
##  $ AGE     : num  40 49 43 50 43 50 45 47 53 49 ...
##  $ DBP58   : num  70 87 89 105 110 88 70 79 102 99 ...
##  $ EDUYR   : num  16 11 12 8 NA 8 NA 9 12 14 ...
##  $ CHOL58  : num  321 246 262 275 301 261 212 372 216 251 ...
##  $ CGT58   : num  0 60 0 15 25 30 0 30 0 10 ...
##  $ HT58    : num  68.8 72.2 69 62.5 68 68 66.5 67 67 64.3 ...
##  $ WT58    : num  190 204 162 152 148 142 196 193 172 162 ...
##  $ DAYOFWK : Factor w/ 7 levels "SUNDAY","MONDAY",..: NA 5 7 4 2 1 NA 1 3 5 ...
##  $ VITAL10 : Factor w/ 2 levels "ALIVE","DEAD": 1 1 2 1 2 2 1 1 2 2 ...
##  $ FAMHXCVR: Factor w/ 2 levels "NO","YES": 2 1 1 2 1 1 1 1 1 2 ...
##  $ CHD     : num  1 1 1 1 1 1 1 1 1 1 ...
##  - attr(*, "variable.labels")= Named chr  "CASE IDENTIFICATION NUMBER" "FIRST CHD EVENT" "AGE AT ENTRY" "AVERAGE DIAST BLOOD PRESSURE 58" ...
##   ..- attr(*, "names")= chr  "CASEID" "FIRSTCHD" "AGE" "DBP58" ...
head(data)
##   CASEID      FIRSTCHD AGE DBP58 EDUYR CHOL58 CGT58 HT58 WT58  DAYOFWK
## 1     13    NONFATALMI  40    70    16    321     0 68.8  190     <NA>
## 2     30    NONFATALMI  49    87    11    246    60 72.2  204 THURSDAY
## 3     53 SUDDEN  DEATH  43    89    12    262     0 69.0  162 SATURDAY
## 4     84    NONFATALMI  50   105     8    275    15 62.5  152 WEDNSDAY
## 5     89 SUDDEN  DEATH  43   110    NA    301    25 68.0  148   MONDAY
## 6    102    NONFATALMI  50    88     8    261    30 68.0  142   SUNDAY
##   VITAL10 FAMHXCVR CHD
## 1   ALIVE      YES   1
## 2   ALIVE       NO   1
## 3    DEAD       NO   1
## 4   ALIVE      YES   1
## 5    DEAD       NO   1
## 6    DEAD       NO   1
dim(data)
## [1] 240  13

# haven包读取electric.sav数据集
library("haven")
## Warning: package 'haven' was built under R version 3.5.3
file<-system.file("files", "electric.sav", package = "foreign")
data<-haven::read_sav(file = file, encoding = NULL, user_na = T)
str(data)
## Classes 'tbl_df', 'tbl' and 'data.frame':    240 obs. of  13 variables:
##  $ CASEID  : num  13 30 53 84 89 102 117 132 151 153 ...
##   ..- attr(*, "label")= chr "CASE IDENTIFICATION NUMBER"
##   ..- attr(*, "format.spss")= chr "F4.0"
##   ..- attr(*, "display_width")= int 0
##  $ FIRSTCHD: 'haven_labelled' num  3 3 2 3 2 3 3 3 2 2 ...
##   ..- attr(*, "label")= chr "FIRST CHD EVENT"
##   ..- attr(*, "format.spss")= chr "F1.0"
##   ..- attr(*, "display_width")= int 0
##   ..- attr(*, "labels")= Named num  1 2 3 5 6
##   .. ..- attr(*, "names")= chr  "NO CHD" "SUDDEN  DEATH" "NONFATALMI" "FATAL   MI" ...
##  $ AGE     : num  40 49 43 50 43 50 45 47 53 49 ...
##   ..- attr(*, "label")= chr "AGE AT ENTRY"
##   ..- attr(*, "format.spss")= chr "F2.0"
##   ..- attr(*, "display_width")= int 0
##  $ DBP58   : num  70 87 89 105 110 88 70 79 102 99 ...
##   ..- attr(*, "label")= chr "AVERAGE DIAST BLOOD PRESSURE 58"
##   ..- attr(*, "format.spss")= chr "F3.0"
##   ..- attr(*, "display_width")= int 0
##  $ EDUYR   : num  16 11 12 8 NA 8 NA 9 12 14 ...
##   ..- attr(*, "label")= chr "YEARS OF EDUCATION"
##   ..- attr(*, "format.spss")= chr "F2.0"
##   ..- attr(*, "display_width")= int 0
##  $ CHOL58  : num  321 246 262 275 301 261 212 372 216 251 ...
##   ..- attr(*, "label")= chr "SERUM CHOLESTEROL 58 -- MG PER DL"
##   ..- attr(*, "format.spss")= chr "F3.0"
##   ..- attr(*, "display_width")= int 0
##  $ CGT58   : num  0 60 0 15 25 30 0 30 0 10 ...
##   ..- attr(*, "label")= chr "NO OF CIGARETTES PER DAY IN 1958"
##   ..- attr(*, "format.spss")= chr "F2.0"
##   ..- attr(*, "display_width")= int 0
##  $ HT58    : num  68.8 72.2 69 62.5 68 68 66.5 67 67 64.3 ...
##   ..- attr(*, "label")= chr "STATURE, 1958 -- TO NEAREST 0.1 INCH"
##   ..- attr(*, "format.spss")= chr "F5.1"
##   ..- attr(*, "display_width")= int 0
##  $ WT58    : num  190 204 162 152 148 142 196 193 172 162 ...
##   ..- attr(*, "label")= chr "BODY WEIGHT, 1958 -- LBS"
##   ..- attr(*, "format.spss")= chr "F3.0"
##   ..- attr(*, "display_width")= int 0
##  $ DAYOFWK : 'haven_labelled_spss' num  9 5 7 4 2 1 9 1 3 5 ...
##   ..- attr(*, "label")= chr "DAY OF DEATH"
##   ..- attr(*, "na_values")= num 9
##   ..- attr(*, "format.spss")= chr "F1.0"
##   ..- attr(*, "display_width")= int 0
##   ..- attr(*, "labels")= Named num  1 2 3 4 5 6 7 9
##   .. ..- attr(*, "names")= chr  "SUNDAY" "MONDAY" "TUESDAY" "WEDNSDAY" ...
##  $ VITAL10 : 'haven_labelled' num  0 0 1 0 1 1 0 0 1 1 ...
##   ..- attr(*, "label")= chr "STATUS AT TEN YEARS"
##   ..- attr(*, "format.spss")= chr "F1.0"
##   ..- attr(*, "display_width")= int 0
##   ..- attr(*, "labels")= Named num  0 1
##   .. ..- attr(*, "names")= chr  "ALIVE" "DEAD"
##  $ FAMHXCVR: 'haven_labelled' chr  "Y" "N" "N" "Y" ...
##   ..- attr(*, "label")= chr "FAMILY HISTORY OF CHD"
##   ..- attr(*, "format.spss")= chr "A1"
##   ..- attr(*, "display_width")= int 0
##   ..- attr(*, "labels")= Named chr  "Y" "N"
##   .. ..- attr(*, "names")= chr  "YES" "NO"
##  $ CHD     : num  1 1 1 1 1 1 1 1 1 1 ...
##   ..- attr(*, "label")= chr "INCIDENCE OF CORONARY HEART DISEASE"
##   ..- attr(*, "format.spss")= chr "F1.0"
##   ..- attr(*, "display_width")= int 0
##  - attr(*, "label")= chr "                       SPSS/PC+"
head(data)
## # A tibble: 6 x 13
##   CASEID FIRSTCHD   AGE DBP58 EDUYR CHOL58 CGT58  HT58  WT58     DAYOFWK
##    <dbl> <dbl+lb> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl>   <dbl+lbl>
## 1     13 3 [NONF~    40    70    16    321     0  68.8   190 9 (NA) [MI~
## 2     30 3 [NONF~    49    87    11    246    60  72.2   204 5 [THURSDA~
## 3     53 2 [SUDD~    43    89    12    262     0  69     162 7 [SATURDA~
## 4     84 3 [NONF~    50   105     8    275    15  62.5   152 4 [WEDNSDA~
## 5     89 2 [SUDD~    43   110    NA    301    25  68     148 2 [MONDAY]
## 6    102 3 [NONF~    50    88     8    261    30  68     142 1 [SUNDAY]
## # ... with 3 more variables: VITAL10 <dbl+lbl>, FAMHXCVR <chr+lbl>,
## #   CHD <dbl>
dim(data)
## [1] 240  13

data<- foreign::read.ssd(libname = system.file("examples",package = "haven"),
                         sectionnames = "iris",
                         sascmd = "D:/Program Files/SASHome/SASFoundation/9.4/sas.exe")
str(data)
head(data)
dim(data)


# 使用haven包读取iris.sas7dbat数据集
file <- system.file("examples", "iris.sas7bdat", package = "haven")
data <- haven::read_sas(data_file = file,
                        encoding = NULL,
                        cols_only = NULL)
str(data)
## Classes 'tbl_df', 'tbl' and 'data.frame':    150 obs. of  5 variables:
##  $ Sepal_Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##   ..- attr(*, "format.sas")= chr "BEST"
##  $ Sepal_Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##   ..- attr(*, "format.sas")= chr "BEST"
##  $ Petal_Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##   ..- attr(*, "format.sas")= chr "BEST"
##  $ Petal_Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##   ..- attr(*, "format.sas")= chr "BEST"
##  $ Species     : chr  "setosa" "setosa" "setosa" "setosa" ...
##   ..- attr(*, "format.sas")= chr "$"
##  - attr(*, "label")= chr "IRIS"
head(data)
## # A tibble: 6 x 5
##   Sepal_Length Sepal_Width Petal_Length Petal_Width Species
##          <dbl>       <dbl>        <dbl>       <dbl> <chr>
## 1          5.1         3.5          1.4         0.2 setosa
## 2          4.9         3            1.4         0.2 setosa
## 3          4.7         3.2          1.3         0.2 setosa
## 4          4.6         3.1          1.5         0.2 setosa
## 5          5           3.6          1.4         0.2 setosa
## 6          5.4         3.9          1.7         0.4 setosa
dim(data)
## [1] 150   5


# foreign包的read.dta函数读取iris.dta数据集
file <- system.file("examples", "iris.dta", package = "haven")
data <- foreign::read.dta(file = file,
                          convert.dates = TRUE,
                          convert.factors = TRUE)
str(data)
## 'data.frame':    150 obs. of  5 variables:
##  $ sepallength: num  5.1 4.9 4.7 4.6 5 ...
##  $ sepalwidth : num  3.5 3 3.2 3.1 3.6 ...
##  $ petallength: num  1.4 1.4 1.3 1.5 1.4 ...
##  $ petalwidth : num  0.2 0.2 0.2 0.2 0.2 ...
##  $ species    : chr  "setosa" "setosa" "setosa" "setosa" ...
##  - attr(*, "datalabel")= chr ""
##  - attr(*, "time.stamp")= chr "26 Feb 2015 15:39"
##  - attr(*, "formats")= chr  "%9.0g" "%9.0g" "%9.0g" "%9.0g" ...
##  - attr(*, "types")= int  255 255 255 255 10
##  - attr(*, "val.labels")= chr  "" "" "" "" ...
##  - attr(*, "var.labels")= chr  "Sepal.Length" "Sepal.Width" "Petal.Length" "Petal.Width" ...
##  - attr(*, "version")= int 12
head(data)
##   sepallength sepalwidth petallength petalwidth species
## 1         5.1        3.5         1.4        0.2  setosa
## 2         4.9        3.0         1.4        0.2  setosa
## 3         4.7        3.2         1.3        0.2  setosa
## 4         4.6        3.1         1.5        0.2  setosa
## 5         5.0        3.6         1.4        0.2  setosa
## 6         5.4        3.9         1.7        0.4  setosa
dim(data)
## [1] 150   5


# haven包的read_dta函数读取iris.dta数据集
file <- system.file("examples", "iris.dta", package = "haven")
data<-haven::read_dta(file = file,
                      encoding = NULL)
str(data)
## Classes 'tbl_df', 'tbl' and 'data.frame':    150 obs. of  5 variables:
##  $ sepallength: num  5.1 4.9 4.7 4.6 5 ...
##   ..- attr(*, "label")= chr "Sepal.Length"
##   ..- attr(*, "format.stata")= chr "%9.0g"
##  $ sepalwidth : num  3.5 3 3.2 3.1 3.6 ...
##   ..- attr(*, "label")= chr "Sepal.Width"
##   ..- attr(*, "format.stata")= chr "%9.0g"
##  $ petallength: num  1.4 1.4 1.3 1.5 1.4 ...
##   ..- attr(*, "label")= chr "Petal.Length"
##   ..- attr(*, "format.stata")= chr "%9.0g"
##  $ petalwidth : num  0.2 0.2 0.2 0.2 0.2 ...
##   ..- attr(*, "label")= chr "Petal.Width"
##   ..- attr(*, "format.stata")= chr "%9.0g"
##  $ species    : chr  "setosa" "setosa" "setosa" "setosa" ...
##   ..- attr(*, "label")= chr "Species"
##   ..- attr(*, "format.stata")= chr "%10s"
head(data)
## # A tibble: 6 x 5
##   sepallength sepalwidth petallength petalwidth species
##         <dbl>      <dbl>       <dbl>      <dbl> <chr>
## 1        5.10       3.5         1.40      0.200 setosa
## 2        4.90       3           1.40      0.200 setosa
## 3        4.70       3.20        1.30      0.200 setosa
## 4        4.60       3.10        1.5       0.200 setosa
## 5        5          3.60        1.40      0.200 setosa
## 6        5.40       3.90        1.70      0.400 setosa
dim(data)
## [1] 150   5


#####4.1.6 从互联网抓取数据#####
# 加载rstatscn包
if (!require("rstatscn")){
  install.packages("rstatscn")
}
## Loading required package: rstatscn
## Warning: package 'rstatscn' was built under R version 3.5.3
library("rstatscn")

# 查询数据库信息
db_list <- statscnDbs()
dim(db_list)
## [1] 11  2
head(db_list)
##   dbcode              description
## 1   hgnd    national data, yearly
## 2   hgjd national data,  quaterly
## 3   hgyd   national data, monthly
## 4   fsnd    province data, yearly
## 5   fsjd  province data, quaterly
## 6   fsyd   province data, monthly

# 获取国家信息
country_list <- statscnRegions(dbcode = "gjnd")
head(country_list)
##   regCode         name
## 1     141         越南
## 2     144       东帝汶
## 3     145   哈萨克斯坦
## 4     146 吉尔吉斯斯坦
## 5     147   塔吉克斯坦
## 6     148   土库曼斯坦
# 获取省信息
province_list <- statscnRegions(dbcode = "fsnd")
head(province_list)
##   regCode         name
## 1  110000       北京市
## 2  120000       天津市
## 3  130000       河北省
## 4  140000       山西省
## 5  150000 内蒙古自治区
## 6  210000       辽宁省
# 获取主要城市信息
city_list <- statscnRegions(dbcode = "csnd")
head(city_list)
##   regCode     name
## 1  110000     北京
## 2  120000     天津
## 3  130100   石家庄
## 4  140100     太原
## 5  150100 呼和浩特
## 6  210100     沈阳

# 查看国家宏观年度数据库（库号hgnd）涉及的统计指标
category_list1 <- statscnQueryZb(dbcode = "hgnd")
head(category_list1)
##   dbcode  id isParent                 name pid wdcode
## 1   hgnd A01     TRUE                 综合         zb
## 2   hgnd A02     TRUE         国民经济核算         zb
## 3   hgnd A03     TRUE                 人口         zb
## 4   hgnd A04     TRUE       就业人员和工资         zb
## 5   hgnd A05     TRUE 固定资产投资和房地产         zb
## 6   hgnd A06     TRUE         对外经济贸易         zb

category_list2 <- statscnQueryZb(dbcode = "hgnd",zb = 'A01')
head(category_list2)
##   dbcode    id isParent                   name pid wdcode
## 1   hgnd A0101    FALSE               行政区划 A01     zb
## 2   hgnd A0102    FALSE 人均主要工农业产品产量 A01     zb
## 3   hgnd A0103     TRUE             法人单位数 A01     zb
## 4   hgnd A0104     TRUE         企业法人单位数 A01     zb
## 5   hgnd A0105     TRUE           民族自治地方 A01     zb

data1<-statscnQueryData(zb = 'A0101',
                        dbcode = 'hgnd')
head(data1)
##                2018年 2017年 2016年 2015年 2014年 2013年 2012年 2011年
## 地级区划数(个)    333    334    334    334    333    333    333    332
## 地级市数(个)      293    294    293    291    288    286    285    284
## 县级区划数(个)   2851   2851   2851   2850   2854   2853   2852   2853
## 市辖区数(个)      970    962    954    921    897    872    860    857
## 县级市数(个)      375    363    360    361    361    368    368    369
## 县数(个)         1335   1355   1366   1397   1425   1442   1453   1456
##                2010年 2009年
## 地级区划数(个)    333    333
## 地级市数(个)      283    283
## 县级区划数(个)   2856   2858
## 市辖区数(个)      853    855
## 县级市数(个)      370    367
## 县数(个)         1461   1464
dim(data1)

data2 <- statscnQueryData(zb = 'A010106',
                          dbcode = "fsyd",
                          rowcode='zb',colcode='sj',
                          moreWd=list(name = 'reg',value = '440000'))
head(data2)
##                                              2019年7月 2019年6月 2019年5月
## 食品类居民消费价格指数(上年同期=100)            0.0000    0.0000    0.0000
## 粮食类居民消费价格指数(上年同期=100)          100.6375  100.5809  100.4356
## 畜肉类居民消费价格指数(上年同期=100)          105.3735  103.5549  102.3973
## 肉禽及其制品类居民消费价格指数(上年同期=100)    0.0000    0.0000    0.0000
## 蛋类居民消费价格指数(上年同期=100)            103.6596  102.7662  101.7257
## 水产品类居民消费价格指数(上年同期=100)        102.1779  102.0257  101.8764
##                                              2019年4月 2019年3月 2019年2月
## 食品类居民消费价格指数(上年同期=100)            0.0000   0.00000   0.00000
## 粮食类居民消费价格指数(上年同期=100)          100.3574 100.32446 100.43911
## 畜肉类居民消费价格指数(上年同期=100)          101.6128 101.03895 100.84068
## 肉禽及其制品类居民消费价格指数(上年同期=100)    0.0000   0.00000   0.00000
## 蛋类居民消费价格指数(上年同期=100)            100.4125  99.62983  99.87855
## 水产品类居民消费价格指数(上年同期=100)        101.5563 101.41681 102.16266
##                                              2019年1月 2018年12月
## 食品类居民消费价格指数(上年同期=100)            0.0000    0.00000
## 粮食类居民消费价格指数(上年同期=100)          100.4003  102.11325
## 畜肉类居民消费价格指数(上年同期=100)          101.8189   96.33392
## 肉禽及其制品类居民消费价格指数(上年同期=100)    0.0000    0.00000
## 蛋类居民消费价格指数(上年同期=100)            101.7191  108.49721
## 水产品类居民消费价格指数(上年同期=100)        104.0871  104.89600
##                                              2018年11月 2018年10月
## 食品类居民消费价格指数(上年同期=100)            0.00000    0.00000
## 粮食类居民消费价格指数(上年同期=100)          102.18463  102.16622
## 畜肉类居民消费价格指数(上年同期=100)           95.82573   95.34807
## 肉禽及其制品类居民消费价格指数(上年同期=100)    0.00000    0.00000
## 蛋类居民消费价格指数(上年同期=100)            109.04896  109.30128
## 水产品类居民消费价格指数(上年同期=100)        104.96366  105.03740
##                                              2018年9月 2018年8月 2018年7月
## 食品类居民消费价格指数(上年同期=100)            0.0000   0.00000   0.00000
## 粮食类居民消费价格指数(上年同期=100)          102.1385 102.21005 102.31274
## 畜肉类居民消费价格指数(上年同期=100)           94.9503  94.59361  94.34499
## 肉禽及其制品类居民消费价格指数(上年同期=100)    0.0000   0.00000   0.00000
## 蛋类居民消费价格指数(上年同期=100)            109.4827 109.87400 109.92633
## 水产品类居民消费价格指数(上年同期=100)        105.1818 105.26589 105.52589
dim(data2)
## [1]  8 13


if (!require("OECD")){
  install.packages("OECD")
}
## Loading required package: OECD
## Warning: package 'OECD' was built under R version 3.5.3
library("OECD")

# 获取数据集列表及信息
dataset_list <- get_datasets()
head(dataset_list)
## # A tibble: 6 x 2
##   id          title
##   <fct>       <fct>
## 1 QNA         Quarterly National Accounts
## 2 PAT_IND     Patent indicators
## 3 SNA_TABLE11 11. Government expenditure by function (COFOG)
## 4 EO78_MAIN   Economic Outlook No 78 - December 2005 - Annual Projections ~
## 5 ANHRS       Average annual hours actually worked per worker
## 6 GOV_DEBT    Central Government Debt
# 模糊检索数据集列表信息
search_result <- search_dataset(string = "unemployment", data = dataset_list)
head(search_result)
## # A tibble: 6 x 2
##   id              title
##   <fct>           <fct>
## 1 DUR_I           Incidence of unemployment by duration
## 2 DUR_D           Unemployment by duration
## 3 AVD_DUR         Average duration of unemployment
## 4 AEO2012_CH6_FI~ Figure 4: Youth and adult unemployment
## 5 AEO2012_CH6_FI~ Figure 29: Youth employment and unemployment by educatio~
## 6 AEO2012_CH6_FI~ Figure 19: The trade off between vulnerable employment a~
# 查看数据集结构
dataset <- "DUR_I"
dataset_structure <- get_data_structure(dataset)
str(dataset_structure,max.level = 1)
## List of 12
##  $ VAR_DESC       :'data.frame': 12 obs. of  2 variables:
##  $ COUNTRY        :'data.frame': 53 obs. of  2 variables:
##  $ TIME           :'data.frame': 51 obs. of  2 variables:
##  $ SEX            :'data.frame': 3 obs. of  2 variables:
##  $ AGE            :'data.frame': 7 obs. of  2 variables:
##  $ DURATION       :'data.frame': 5 obs. of  2 variables:
##  $ FREQUENCY      :'data.frame': 1 obs. of  2 variables:
##  $ OBS_STATUS     :'data.frame': 15 obs. of  2 variables:
##  $ UNIT           :'data.frame': 316 obs. of  2 variables:
##  $ POWERCODE      :'data.frame': 32 obs. of  2 variables:
##  $ REFERENCEPERIOD:'data.frame': 92 obs. of  2 variables:
##  $ TIME_FORMAT    :'data.frame': 5 obs. of  2 variables:
head(dataset_structure$COUNTRY)
##    id          label
## 1 AUS      Australia
## 2 AUT        Austria
## 3 BEL        Belgium
## 4 CAN         Canada
## 5 CZE Czech Republic
## 6 DNK        Denmark
# 抽取OECD国家，男性，25-54岁之间的数据
filter_list1 <- list(COUNTRY = "OECD", SEX = "MEN", AGE = "2554")
data1 <- get_dataset(dataset = dataset, filter = filter_list1)
head(data1)
## # A tibble: 6 x 8
##   COUNTRY SEX   AGE   DURATION FREQUENCY TIME_FORMAT obsTime obsValue
##   <chr>   <chr> <chr> <chr>    <chr>     <chr>       <chr>      <dbl>
## 1 OECD    MEN   2554  UN1      A         P1Y         1983        15.5
## 2 OECD    MEN   2554  UN1      A         P1Y         1984        17.1
## 3 OECD    MEN   2554  UN1      A         P1Y         1985        16.4
## 4 OECD    MEN   2554  UN1      A         P1Y         1986        15.7
## 5 OECD    MEN   2554  UN1      A         P1Y         1987        14.9
## 6 OECD    MEN   2554  UN1      A         P1Y         1988        14.6
# 抽取所有国家的数据
filter_list2 <- list(COUNTRY=c(dataset_structure$COUNTRY[,1]))
data2 <- get_dataset(dataset = dataset, filter = filter_list2)
head(data2)
## # A tibble: 6 x 8
##   COUNTRY SEX   AGE   DURATION FREQUENCY TIME_FORMAT obsTime obsValue
##   <chr>   <chr> <chr> <chr>    <chr>     <chr>       <chr>      <dbl>
## 1 AUS     MW    1519  UN1      A         P1Y         1978        20.0
## 2 AUS     MW    1519  UN1      A         P1Y         1979        19.3
## 3 AUS     MW    1519  UN1      A         P1Y         1980        21.0
## 4 AUS     MW    1519  UN1      A         P1Y         1981        22.8
## 5 AUS     MW    1519  UN1      A         P1Y         1982        21.4
## 6 AUS     MW    1519  UN1      A         P1Y         1983        16.3


library("rvest")
## Warning: package 'rvest' was built under R version 3.5.3
## Loading required package: xml2
## Warning: package 'xml2' was built under R version 3.5.3
url<-"https://cran.r-project.org/web/packages/available_packages_by_name.html"
x <- read_html(x = url)
# 获取页面结构
html_structure(x)

# 获取页面标签名称
html_name(x)

# 获取页面子节点信息
html_children(x)

# 获取页面属性信息
html_attrs(x)

library("rvest")
# 抽取R包名、标题信息
package_list <- html_nodes(x = x, css = "table")%>%
  html_table(header = F, fill = TRUE, trim=T)%>%
  as.data.frame()
head(package_list)
##         X1
## 1
## 2       A3
## 3    aaSEA
## 4   abbyyR
## 5      abc
## 6 abc.data
##                                                                         X2
## 1                                                                     <NA>
## 2 Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels
## 3                                  Amino Acid Substitution Effect Analyser
## 4                  Access to Abbyy Optical Character Recognition (OCR) API
## 5                         Tools for Approximate Bayesian Computation (ABC)
## 6              Data Only: Tools for Approximate Bayesian Computation (ABC)
# 抽取R包链接信息
library("stringi")
package_url<-data.frame(name=html_nodes(x,"table")%>%
                          html_nodes(css = "a")%>%
                          html_text(),  # 抽取链接标题（R包名）
                        url=html_nodes(x,css = "table")%>%
                          html_nodes(css = "a")%>%   # 抽取链接地址
                          stringi::stri_extract(regex = '(?<=href=\").*?(?=\")')%>%
                          stringi::stri_replace_all_fixed(pattern  = "../..",
                                                          replacement = "https://cran.r-project.org"))
head(package_url)
##       name                                                         url
## 1       A3       https://cran.r-project.org/web/packages/A3/index.html
## 2    aaSEA    https://cran.r-project.org/web/packages/aaSEA/index.html
## 3   abbyyR   https://cran.r-project.org/web/packages/abbyyR/index.html
## 4      abc      https://cran.r-project.org/web/packages/abc/index.html
## 5 abc.data https://cran.r-project.org/web/packages/abc.data/index.html
## 6  ABC.RAP  https://cran.r-project.org/web/packages/ABC.RAP/index.html
package_infor<-na.omit(merge(x=as.data.frame(package_list),
                             y=package_url,
                             by.x="X1",
                             by.y = "name"))

head(package_infor)
##         X1
## 1       A3
## 2    aaSEA
## 3   abbyyR
## 4      abc
## 5 abc.data
## 6  ABC.RAP
##                                                                         X2
## 1 Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels
## 2                                  Amino Acid Substitution Effect Analyser
## 3                  Access to Abbyy Optical Character Recognition (OCR) API
## 4                         Tools for Approximate Bayesian Computation (ABC)
## 5              Data Only: Tools for Approximate Bayesian Computation (ABC)
## 6                                 Array Based CpG Region Analysis Pipeline
##                                                           url
## 1       https://cran.r-project.org/web/packages/A3/index.html
## 2    https://cran.r-project.org/web/packages/aaSEA/index.html
## 3   https://cran.r-project.org/web/packages/abbyyR/index.html
## 4      https://cran.r-project.org/web/packages/abc/index.html
## 5 https://cran.r-project.org/web/packages/abc.data/index.html
## 6  https://cran.r-project.org/web/packages/ABC.RAP/index.html


url<-"https://cran.r-project.org/web/packages/A3/index.html"

# 获取A3包介绍页面解析数据
x <- read_html(url)

# 获取A3包功能描述信息
description<-html_node(x = x,css = "p") %>%
  html_text()
print(description)

# 获取A3包详细信息
details<-html_nodes(x = x,css = "table")%>%
  `[`(1)%>%
  html_table(header = F,fill = TRUE,trim=T)%>%
  as.data.frame()%>%
  dplyr::filter(X1%in%c("Version:","Depends:","Published:","Suggests:","Author:"))
head(details)

GetPackageDetail<-function(url){
  x <- read_html(url)
  description<-html_node(x = x,css = "p") %>%
    html_text()
  details<-html_nodes(x = x,css = "table")%>%
    `[`(1)%>%
    html_table(header = F,fill = TRUE,trim=T)%>%
    as.data.frame()
  details[,1]<-stringi::stri_replace_all_fixed(details[,1],pattern  = ":",replacement = "")
  rownames(details)<-c(details[,1])
  keywords<-c("Version","Depends","Imports","Published",
              "Suggests","Author","Maintainer","Contact",
              "License","NeedsCompilation","SystemRequirements")

  out_tmp<-cbind(keywords,NA)
  rownames(out_tmp)<-keywords
  out_tmp[c(intersect(keywords,details$X1)),2]=details[(intersect(keywords,details$X1)),2]


  out<-rbind(c("Description",description),
             out_tmp)
  colnames(out)<-c("keywords","value")
  return(out)
}
# 函数测试
GetPackageDetail(url = "https://cran.r-project.org/web/packages/A3/index.html")


GetPackageInforFromCRAN<-function(url="https://cran.r-project.org"{
  x <- read_html(x = paste0(url,"/web/packages/available_packages_by_name.html"))
  package_list <- html_nodes(x = x, css = "table")%>%
    html_table(header = F, fill = TRUE, trim=T)%>%
    as.data.frame()
  package_url<-data.frame(name=html_nodes(x,"table")%>%
                            html_nodes(css = "a")%>%
                            html_text(),  # 抽取链接标题（R包名）
                          url=html_nodes(x,css = "table")%>%
                            html_nodes(css = "a")%>%   # 抽取链接地址
                            stringi::stri_extract(regex = '(?<=href=\").*?(?=\")')%>%
                            stringi::stri_replace_all_fixed(pattern  = "../..",
                                                            replacement = url))

  package_infor<-na.omit(merge(x=package_list,
                               y=package_url,
                               by.x="X1",
                               by.y = "name"))
  out<-NULL
  for ( i in 1:nrow(package_infor)){
    cat("开始抓取[",package_infor[i,1],"]包的信息数据，请等待...","\n")
    go<-try({
      tmp<-GetPackageDetail(url = as.character(package_infor[i,3]))
    })

    if ("try-error"%in%class(go)){
      cat("[",package_infor[i,1],"]包的信息数据抓取失败！","\n")
      next
    }else{
      out<-rbind(out,
                 as.character(c(package_infor[i,],tmp[,2])))
      cat("[",package_infor[i,1],"]包的信息数据抓取成功！","\n")
    }
    rm(tmp);gc() #清理无用变量，释放内存
  }

  colnames(out)<-c("PackageName","Title","Url",
                   "Version","Depends","Imports","Published",
                   "Suggests","Author","Maintainer","Contact",
                   "License","NeedsCompilation","SystemRequirements")
  cat("R包信息抓取汇总：成功抓取",nrow(out),"个包，",nrow(package_infor)-nrow(out),"个包抓取失败！","\n")
  return(out)
}
# 函数测试
package_infor<-GetPackageInforFromCRAN(url="https://cran.r-project.org")
head(package_infor)
dim(package_infor)

#####4.2.1 写入R系统格式数据#####
# 将iris数据集保存为rds文件
saveRDS(object = iris, file = "iris.rds")

# 将iris数据集保存为RData文件
save(list=c("iris"),file = "iris.RData")

file.exists(c("iris.rds","iris.RData"))
## [1] TRUE TRUE


#####4.2.2 写入文本文件#####
write.csv(x=iris,
          file = "iris.csv",
          append = FALSE,
          row.names = FALSE,
          fileEncoding = "GBK")
## Warning in write.csv(x = iris, file = "iris.csv", append = FALSE, row.names
## = FALSE, : attempt to set 'append' ignored
write.table(x=iris,
            file = "iris.txt",
            append = FALSE,
            row.names = FALSE,
            sep = ",",
            fileEncoding = "GBK")

iris1<-read.csv("iris.csv")
iris2<-read.table("iris.txt",sep=",",header = T)

# 验证数据一致性
identical(iris,iris1)
## [1] TRUE
identical(iris,iris2)
## [1] TRUE

#####4.2.3 写入Excel文件#####
openxlsx::write.xlsx(x = iris,
                     file = "iris_openxlsx.xlsx",
                     asTable = TRUE)

iris3 <- openxlsx::read.xlsx(xlsxFile = "iris_openxlsx.xlsx")

# 验证数据一致性
identical(iris,iris3)
## [1] FALSE
str(iris3)
## 'data.frame':    150 obs. of  5 variables:
##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ Species     : chr  "setosa" "setosa" "setosa" "setosa" ...
str(iris)
## 'data.frame':    150 obs. of  5 variables:
##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

#####4.2.4 写入数据库#####
# 将iris数据集写入SQLServer
SQLServer <- RODBC::odbcConnect(dsn = 'RToSQLServer',uid = 'liuy',pwd = 'Ly123456')
RODBC::sqlQuery(channel = SQLServer,
                query = "drop table iris")
## character(0)
RODBC::sqlSave(channel = SQLServer,
               dat = iris,
               tablename = 'iris',
               append = F,
               rownames = FALSE,
               colnames = FALSE,
               verbose = FALSE,
               safer = FALSE,
               addPK = TRUE)

data1<-RODBC::sqlQuery(channel = SQLServer,
                       query = "select * from iris")
# 将iris数据集写入MySQL
MySQL <- RODBC::odbcConnect(dsn = 'RToMySQL',uid = 'liuy',pwd = 'liuyadmin123456')
RODBC::sqlSave(channel = MySQL,
               dat = iris,
               tablename = 'iris',
               append = F,
               rownames = FALSE,
               colnames = FALSE,
               verbose = FALSE,
               safer = FALSE,
               addPK = TRUE)
data2<-RODBC::sqlQuery(channel = MySQL,
                       query = "select * from iris")

# 将iris数据集写入PostgreSQL
PostgreSQL <- RODBC::odbcConnect(dsn = 'RToPostgreSQL',uid = 'liuy',pwd = 'liuyadmin123456')
RODBC::sqlSave(channel = PostgreSQL,
               dat = iris,
               tablename = 'iris',
               append = F,
               rownames = FALSE,
               colnames = FALSE,
               verbose = FALSE,
               safer = FALSE,
               addPK = TRUE)
data3<-RODBC::sqlQuery(channel = PostgreSQL,
                       query = "select * from iris")

# 验证写入效果
str(iris)
## 'data.frame':    150 obs. of  5 variables:
##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
str(data1)
## 'data.frame':    150 obs. of  5 variables:
##  $ SepalLength: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ SepalWidth : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ PetalLength: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ PetalWidth : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ Species    : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
str(data2)
## 'data.frame':    150 obs. of  5 variables:
##  $ sepallength: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ sepalwidth : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ petallength: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ petalwidth : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ species    : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
str(data3)
## 'data.frame':    150 obs. of  5 variables:
##  $ sepallength: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ sepalwidth : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ petallength: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ petalwidth : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ species    : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
# 关闭数据库连接
RODBC::odbcCloseAll()



