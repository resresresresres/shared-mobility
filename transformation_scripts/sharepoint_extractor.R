library(Microsoft365R)
library(readxl)
setwd("C:/Users/abigl/Documents/shared-mobility")

#connect to Sharepoint
options(microsoft365r_use_cli_app_id = TRUE)

path <- read_excel("C:/Users/abigl/Documents/shared-mobility/Overview.xlsx", sheet = "Paths")
days <- read_excel("C:/Users/abigl/Documents/shared-mobility/Overview.xlsx", sheet = "Days")

for (j in 1:length(path$Folderpath)) {
  folderpath <- path$Folderpath[j]
  filepath <- path$Filepath[j]

  site <- get_sharepoint_site("MScWi - BINA Arbeit")
  drv <- site$get_drive("Dokumente")
  shp <- drv$list_files(folderpath)
  
  
  for (k in 1:length(days[[j]])) {
    day <- toString(days[k, j])
  
  #define which day to extract
  c <- grep(day, shp$name, value = TRUE)
  
  #download all files for the defined day
  for (i in 1:length(c)) {
    drv$download_file(paste0(filepath, c[i]), overwrite = TRUE)
  }
  
  #merge all file to a list
  files <- list.files(path=getwd(), pattern="\\.csv")         
  
  dfList <- sapply(day, function(p){
    dfs <- lapply(list.files(path=getwd(),
                             pattern=p, full.names=TRUE), read.csv)
    do.call(rbind, dfs)   
  }, simplify=FALSE)
  
  #output the list to one csv
  out <- mapply(function(d,n) write.csv(d, file=paste0(n,".csv"), row.names=FALSE), 
                dfList, names(dfList), SIMPLIFY=FALSE)
  
  #delete the downloaded files
  unlink(c)

  }
}