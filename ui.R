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
        
        selected = c("monograph", "periodicalitem", "periodicalvolume")
      ),
      
      # Filter by visibility
      checkboxGroupInput(
        inputId = "visibility",
        label = "Select visibility",
        choices = c("Public" = "public", "Private" = "private"),
        selected = c("public","private")
      )
    ),
  
    
    mainPanel(
      # main panel displaying graphs based on what 
      tabsetPanel(
        tabPanel(
          title = "Growth", 
          plotOutput(outputId = "growth_graph")
          ), 
        tabPanel(title = "Composition",
                 plotOutput("composition_graph")
                 ), 
        tabPanel("Etc.")
      )
    )
  ),
  actionButton(inputId = "update", "Update index (might take a while)")
)
