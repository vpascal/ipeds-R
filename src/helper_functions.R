library(httr)
library(config)
library(readr)
library(readxl)
library(dplyr)



download_from_ipeds <- function(url, folder){

  if (!file.exists(folder)) {
    dir.create(folder)
  }
  
  
config <- get(file = 'src/config.yml')
 for (url in config$url) {
   
   dest <- strsplit(url,'/')[[1]][7]
   dest <- paste0(folder,'/',dest)
   GET(url, write_disk(dest, overwrite = TRUE), progress()) 
   
 }  
  
  for (url in config$url_data_dict) {
    
    dest <- strsplit(url,'/')[[1]][7]
    dest <- paste0(folder,'/',dest)
    GET(url, write_disk(dest, overwrite = TRUE), progress()) 
    
  }
 cat('Downloaded!')
}

combine_names <- function(x,y){

  
  config <- get(file = 'src/config.yml')
  
  data_x <- read_csv(x,show_col_types = FALSE)
  data_x <- data_x |> select(all_of(config$vars_to_keep))
  names_x <- names(data_x) 
  
  year <- stringr::str_extract(pattern = '\\d{4}',x)
  
  data_y <- read_xlsx(y,sheet = 'varlist')
  names_y <- data.frame(names = data_y$varname, label = data_y$varTitle)
  
  
  temp <- na.omit(names_y$label[names_x %in% names_y$names])
  names_x[names_x %in% names_y$names] <- temp
  
  names(data_x)<- names_x
  data_x$years <- year
  data_x
  
}
