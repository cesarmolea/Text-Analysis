# PCR Project
# Convert pdf files to text files
# Date: November, 2020

###################################
###### Pre-process             ####
###################################



if (!require("rvest")) install.packages("rvest"); library("rvest")
if (!require("magrittr")) install.packages("magrittr"); library("magrittr")
if (!require("stringr")) install.packages("stringr"); library("stringr")
if (!require("combinat")) install.packages("combinat"); library("combinat")
if (!require("lubridate")) install.packages("lubridate"); library("lubridate")
if (!require("pdftools")) install.packages("pdftools"); library("pdftools")
if (!require("RCurl")) install.packages("RCurl"); library("RCurl")
if (!require("gtools")) install.packages("gtools"); library("gtools")
if (!require("tm")) install.packages("tm"); library("tm")
if (!require("qdap")) install.packages("qdap"); library("qdap")
if (!require("dplyr")) install.packages("dplyr"); library("dplyr")
if (!require("tidytext")) install.packages("tidytext"); library("tidytext")
if (!require("SnowballC")) install.packages("SnowballC"); library("SnowballC")
if (!require("RWeka")) install.packages("RWeka"); library("RWeka")
if (!require("doParallel")) install.packages("doParallel"); library("doParallel")
if (!require("foreach")) install.packages("foreach"); library("foreach")
if (!require("iterators")) install.packages("iterators"); library("iterators")
if (!require("parallel")) install.packages("parallel"); library("parallel")
#if (!require("tidyverse")) install.packages("tidyverse"); library("tidyverse")
if (!require("tm")) install.packages("tm"); library("tm")
if (!require("pdftools")) install.packages("pdftools"); library("pdftools")
if (!require("tabulizer")) install.packages("tabulizer"); library("tabulizer")
if (!require("qpdf")) install.packages("qpdf"); library("qpdf")
if (!require("purrr")) install.packages("purrr"); library("purrr")

#############################################
### 1.Set directory                      ####
#############################################
path <- "C:/Users/CESARMO/OneDrive - Inter-American Development Bank Group/Desktop/NLP_IDB/NLP_IDB"
setwd(path)
#############################################
### 1. Reading the pdf files     ####
#############################################

# We read the .pdf files
list.files() # to see the subfolders that we have
files <- list.files(paste0(path,"/", "pdf"), pattern = "\\.pdf", full.names = T)
outlist <- rep(list(list()), length(files))


docs <- Corpus(DirSource(paste0(path,"/", "pdf")),  
               readerControl = list(reader = readPDF, language = "spanish"))

# We use the do parallel command to make it quicker, since we have a lot of files
usecores <- detectCores() -1
cl <- makeCluster(usecores)
registerDoParallel(cl)

outlist <- foreach (i = 1:length(docs)) %dopar%  { 
  library(pdftools)
  library(magrittr)
  library(tidyverse)
  library(tm)
  docs[[i]]$content[-c(1:5)] # we get rid of first 5 pages of the PCR
} 

new_path <- paste0(path,"/", "all_data")

# Convert the list into dataframe and then keep it as texts files
foreach (i = 1:length(docs)) %dopar% { 
  df <- as.data.frame(outlist[[i]])
  name <- as.character(substr(docs[[i]]$meta[5], 1, 8))
  write.table(df, file = paste0(new_path, "/", name, ".txt"), sep = "\t", row.names = FALSE)
} 


# Extra
dfs_text <- map(files, ~ pdf_text(.x)[1:5])
test <- which(test%in%dfs_text[[1]])
x <- list("a", "b", "c", "d", "e"); # example list
x <- x[-2];       # without 2nd element
x <- x[-c(2, 3)];

