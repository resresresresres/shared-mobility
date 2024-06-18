library(data.table)
library(dplyr)

dir <- "C:/Users/abigl/Documents/shared-mobility"
files<-list.files(path=dir, pattern="*.csv", full.names = TRUE)

for (i in 1:length(files)) {
  df <- fread(files[i])
  name <- basename(files[i])
  df <- distinct(df, subset(df, select = -c(extract_time)), .keep_all = TRUE)
  write.csv(df, files[i], quote = FALSE, row.names = FALSE, fileEncoding = "UTF-8")
  rm(df)
  
}