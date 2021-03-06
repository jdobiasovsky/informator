# Set global variables required by app prior to loading
library(shiny)
library(shinybusy)
library(shinythemes)
source("./src/config.R")
source("./src/kramerius_toolbox.R")
source("./src/report_card.R")
source("./src/visualisation.R")

collections <- collection_info()
index <- get_index()
