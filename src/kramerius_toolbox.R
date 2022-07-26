# Tools for working with kramerius index and getting other data from the digital library
library(readr)
library(jsonlite)
library(readr)
library(xml2)
library(dplyr)

get_index <- function(){
  # query kramerius api with parameters from config
  q = "*:*"
  fl = paste(FIELD_LIST, collapse = ",")
  fq = paste(paste("fedora.model:", FEDORA_MODELS, sep = ""), collapse = "%20OR%20")
  rows = format(KRAMERIUS_SIZE,scientific=FALSE)
  constructed_query <- paste0(c("?q=",q,"fq=", fq, "fl=", fl, "rows=",rows,"wt=xml"),c("", "&"), collapse = "")
  
  
  print("Fetching index...")
  request <- paste(KRAMERIUS_API,"search",constructed_query,sep = "")
  data <- read_xml(request)
  
  # find document nodes in response
  docs <- xml_find_all(data,"//doc")
  
  # create list of nodesets of each document
  vals <- lapply(docs, function(x){xml_children(x)})

  # create data.frame for each node, bind them together into single large dataframe (each row - one document)
  # TODO: optimise for vector operations
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


collection_info <- function(){
  # pull json data about collections from kramerius API, return as tibble
  
  print("Fetching collection info...")
  df <- tibble(flatten(stream_in(file(paste(KRAMERIUS_API,"vc", sep = ""))))) %>% 
    select(pid,descs.en,numberOfDocs) %>% 
    rename(number.of.docs = numberOfDocs)
  return(df)
}


filter_collection <- function(data, collection_id){
  # filter specific collection from provided data
  # @param data: data to filter from
  # @param collection_id: collection identifier (can be found using collection_info())
  
  if (collection_id == "any"){
    return(filter(data,!is.na(collection)))
  } else if (collection_id == "none") {
    return(filter(data, is.na(collection)))
  } else {
    return(filter(data, collection == collection_id))
  } 
}
