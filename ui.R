library(shinybusy)
library(shinythemes)
collections <- collection_info()

## ui.R ##
fluidPage(title = "Informator", theme = shinytheme("united"),
  add_busy_spinner(spin = "bounce", color = "white"),
  navbarPage(title = "Informator", id = "main_navbar", selected = "Digitisation", fluid = TRUE),
    sidebarLayout(
      sidebarPanel(
        # Input for date, doctype filters etc.
        dateRangeInput(
          inputId = "daterange",
          label = "Pick date range:",
          start = Sys.Date()-365,
          end = Sys.Date()
          ),
        
        # Selection which doctypes to display
        checkboxGroupInput(
          inputId = "doctypes",
          label = "Select document types to display:",
          choices = c("Monographs" = "monograph",
                      "Periodical items" = "periodicalitem",
                      "Periodical volumes" = "periodicalvolume"),
          
          selected = c("monograph", "periodicalitem")
          ),
        
        # Filter by visibility
        checkboxGroupInput(
          inputId = "visibility",
          label = "Select visibility",
          choices = c("Public" = "public", "Private" = "private"),
          selected = c("public","private")
          ),
      
        radioButtons(
          inputId = "collection_selector",
          label = "Collections",
          choiceNames = c("All", "Documents without collection", collections$descs.en),
          choiceValues = c("any", "none", collections$pid)
        )
      ),
      
      mainPanel(
        # main panel displaying graphs based on sidebar selection
        radioButtons(inputId = "zoom", label = "Zoom", choices = c("large", "medium", "small", "auto"),inline = TRUE,selected = "large"),
        tabsetPanel(
          tabPanel(
            title = "Growth", 
            plotOutput(outputId = "growth_graph")
            ), 
          tabPanel(title = "Composition",
                   splitLayout(cellWidths = c("50%", "50%"),
                     plotOutput("composition_doctypes"),
                     plotOutput("composition_visibility"))
                   ),
  
          tabPanel(
            title = "Report card",
            h3("Digital library contents"),
            dataTableOutput("report_card_overview"),
            dataTableOutput("report_card_bydate")
          )
        )
      )
  )
)

