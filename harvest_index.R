# Script to harvest new solr index
library(urltools)
library(solrium)
source("./config.R")

  
# establish connection to solr
conn <- SolrClient$new(host = SOLR_HOST, path = SOLR_PATH, port = SOLR_PORT, scheme = SCHEME)

# harvest index
index <- conn$search(params = list(q = '*:*', rows = KRAMERIUS_SIZE,
                                   fl = paste(FIELD_LIST, collapse = ","), 
                                   fq = paste("fedora.model:", paste(FEDORA_MODELS, collapse = " OR "), sep = "")))
write.csv(index, "./index.csv") 


