# Tools for harvesting kramerius index and working with it

harvest_index <- function(){
  source("./config.R")
  library(solrium)
  library(readr)
  # establish connection to solr
  conn <- SolrClient$new(host = SOLR_HOST, path = SOLR_PATH, port = SOLR_PORT, scheme = SCHEME)
  
  # harvest index
  index <- conn$search(params = list(q = '*:*', rows = KRAMERIUS_SIZE,
                                     fl = paste(FIELD_LIST, collapse = ","), 
                                     fq = paste(paste("fedora.model:", FEDORA_MODELS, sep = ""), collapse = " OR ")))
  write.csv(index, "./data/index.csv") 
  writeLines(as.character(Sys.Date()),"./.last_harvest", sep = "")
}  

load_index <- function(){
  index <- read_csv("./data/index.csv", col_types = cols(X1 = col_integer(), 
                                                  fedora.model = col_character(), created_date = col_datetime(), 
                                                  dostupnost = col_character(), pages_count = col_double()))
  return(index)
}