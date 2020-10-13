# Tools for working with kramerius index and getting other data from the digital library
library(readr)
library(jsonlite)
library(solrium)
library(readr)
library(xml2)
source("./config.R")


get_index <- function(){
  # query kramerius api with parameters from config
  q = "*:*"
  fl = paste(FIELD_LIST, collapse = ",")
  fq = paste(paste("fedora.model:", FEDORA_MODELS, sep = ""), collapse = "%20OR%20")
  rows = format(KRAMERIUS_SIZE,scientific=FALSE)
  
  constructed_query <- paste0(c("?q=",q,"fq=", fq, "fl=", fl, "rows=",rows),c("", "&"), collapse = "")
  request <- paste(KRAMERIUS_API,constructed_query,sep = "")
  data <- read_xml(request)
  
  # find document nodes in response
  docs <- xml_find_all(data,"//doc")
  
  # create list of nodesets of each document
  vals <- lapply(docs, function(x){xml_children(x)})

  # create data.frame for each node, bind them together into single large dataframe (each row - one document)
  index <- bind_rows(lapply(vals, function(nodeset){
    # converts nodeset to data.frame with colnames based on values of xml_attr(name_attr)
    node_values <- xml_text(nodeset)
    node_names <- xml_attr(nodeset,"name")
    df <- data.frame(matrix(node_values, ncol = length(node_values), dimnames = list(NULL,node_names)), stringsAsFactors = FALSE)
    return(df)}))
  
  # convert to tibble and set column types
  index <- as_tibble(type_convert(index))
  
  return(index)
}





solr_harvest_index_ <- function(){
  # establish connection to solr
  conn <- SolrClient$new(host = SOLR_HOST, path = SOLR_PATH, port = SOLR_PORT, scheme = SCHEME)
  
  # harvest index
  index <- conn$search(params = list(q = '*:*', rows = KRAMERIUS_SIZE,
                                     fl = paste(FIELD_LIST, collapse = ","), 
                                     fq = paste(paste("fedora.model:", FEDORA_MODELS, sep = ""), collapse = " OR ")))
  write.csv(index, "./data/index.csv") 
  writeLines(as.character(Sys.Date()),"./.last_harvest", sep = "")
}  


solr_load_index <- function(){
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
