collections <- collection_info()

## ui.R ##
fluidPage(
  titlePanel("Hello World!"),
  textOutput(outputId = "version"),
  
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
        choices = c("Pages" = "page",
                    "Monographs" = "monograph",
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
        inputId = "collections_mode",
        label = "Collections",
        choiceNames = c("All", "Documents without collection", collections$descs.en),
        choiceValues = c("All", NA, collections$pid)
      ),
      actionButton(inputId = "update", "Update index (might take a while)")
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
                 plotOutput("composition_graph")
                 ),

        tabPanel(
          title = "Report card",
          h3("Digital library contents"),
          dataTableOutput("report_card")
        )
      )
    )
  )
)
