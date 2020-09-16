source("./visualisation.R", echo = FALSE)
source("./index_tools.R", echo = FALSE)
index <- load_index()

## server.R ##
function(input,output){
  # print date of harvested index
  output$version <- renderText({
    paste("Index version:", read_file("./.last_harvest"))
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