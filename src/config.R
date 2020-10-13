## Configuration file to allow customisation of separate instances

KRAMERIUS_API <- "https://kramerius.techlib.cz/search/api/v5.0/"

# harvest following fedora models
FEDORA_MODELS <- c("monograph", "periodicalitem", "periodicalvolume") # "page"

# harvest following fields
FIELD_LIST <- c("PID", "collection","fedora.model","created_date","dostupnost")

# total number of rows to harvest, should be larger than number of all document types in kramerius
# for example NTL has ~2500 documents --> kramerius size should be >= 2500, please make sure you include larger number if you plan on viewing fedora.model "page"
KRAMERIUS_SIZE <- 1000000

