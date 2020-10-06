source("./config.R")
source("./visualisation.R", echo = FALSE)
source("./kramerius_toolbox.R", echo = FALSE)
source("./report_card.R", echo = FALSE)
index <- load_index()
collections <- collection_info()

## server.R ##
function(input,output){
  screen_height <- reactive({
    screen_settings_height(input$zoom)
  })
  
  screen_width <- reactive({
    screen_settings_width(input$zoom)
  })
  
  # print date of harvested index
  output$version <- renderText({
    paste("Index version:", read_file("./.last_harvest"))
  })
  
  # growth tab plot
  output$growth_graph <- renderPlot({
    new_docs_growth(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
  }, height = screen_height)
  
  # composition tab plot
  output$composition_graph <- renderPlot({
    digital_library_composition(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
  }, height = screen_height)
  
  # report card
  output$report_card <- renderDataTable(
    generate_report_card(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
  )
  
  # display sidebar selection elsewhere
  output$filter_from <- renderPrint(input$daterange[1])
  output$filter_to <- renderPrint(input$daterange[2])
  
  eventReactive(input$update, {
    print("Updating index...")
    harvest_index()
    index <- load_index()
  })
}
