# single file shiny app for demo purposes without having to harvest index again)
source("../visualisation.R", echo = FALSE)
source("../index_tools.R", echo = FALSE)
index <- read_csv("./index.csv", col_types = cols(X1 = col_integer(), 
                                                       fedora.model = col_character(), created_date = col_datetime(), 
                                                       dostupnost = col_character(), pages_count = col_double()))

## ui.R ##
ui <- fluidPage(
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


## server.R ##
server <- function(input,output){
  # print date of harvested index
  output$version <- renderText({
    paste("DEMO")
  })
  # growth tab plot
  output$growth_graph <- renderPlot({
    new_docs_growth(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
  })
  
  # composition tab plot
  output$composition_graph <- renderPlot({
    digital_library_composition(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
  })
  
  eventReactive(input$update, {
    print("Updating index...")
    harvest_index()
    index <- load_index()
  })
}

shinyApp(ui,server)