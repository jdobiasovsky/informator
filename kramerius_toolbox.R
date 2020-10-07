# Tools for working with kramerius index and getting other data from the digital library
library(readr)
library(jsonlite)
library(solrium)
library(readr)
source("./config.R")


harvest_index <- function(){
  # Get required data 
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
  df <- read_csv("./data/index.csv", col_types = cols(X1 = col_integer(), 
                                                  fedora.model = col_character(), created_date = col_datetime(), 
                                                  dostupnost = col_character(), pages_count = col_double(),
                                                  collection = col_character()))
  return(df)
}


collection_info <- function(){
  df <- tibble(flatten(stream_in(file("http://kramerius1.ntkcz.cz:8080/search/api/v5.0/vc")))) %>% 
    select(pid,descs.en,numberOfDocs) %>% 
    rename(number.of.docs = numberOfDocs)
  return(df)
}


filter_collection <- function(data, collection_id){
  if (collection_id == "any"){
    return(filter(data,!is.na(collection)))
  } else if (collection_id == "none") {
    return(filter(data, is.na(collection)))
  } else {
    return(filter(data,!is.na(collection) & collection == collection_id))
  } 
}
