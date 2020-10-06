## Configuration file to allow customisation of separate instances
# url of kramerius core along with standard query parser
SCHEME <- "http"
SOLR_HOST <- "kramerius1.ntkcz.cz"
SOLR_PORT <- 8983
SOLR_PATH <- "solr/kramerius/select"

# harvest following fedora models
FEDORA_MODELS <- c("page", "monograph", "periodicalitem", "periodicalvolume")

# harvest following fields
FIELD_LIST <- c("PID","fedora.model","created_date","dostupnost", "pages_count", "collection")

# total number of rows to harvest, should be larger than number of all document types in kramerius
# for example NTL has ~2500 documents --> kramerius size should be >= 2500
KRAMERIUS_SIZE <- 1000000

