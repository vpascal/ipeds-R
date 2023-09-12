library(purrr)
library(readr)

source('src/helper_functions.R')

# lets download files and data dictionaries and store them in a destination folder
download_from_ipeds(folder = 'ipeds_raw_data')

# let's unzip the files and put in another folder
files <- dir(path = 'ipeds_raw_data/',full.names = TRUE)

walk(files,unzip, exdir ='unzipped_files')

# data dictionaries are in Excel files and raw data are in csv files.
# We can stack and combine these files extracting only some variables. We will exclude
# imputed values and those with professional degrees such as medicine, optometry, etc.

files <- dir(path = 'unzipped_files', pattern = 'csv', full.names = TRUE)
dicts <- dir(path = 'unzipped_files', pattern = 'xlsx', full.names = TRUE)

result <- map2_df(files, dicts,combine_names)
# export
write_csv(result,'final_data_file_ipeds.csv')
