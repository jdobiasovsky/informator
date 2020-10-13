## server.R ##
function(input,output){
  # load necessary data for visualisation
  show_modal_spinner(spin = "semipolar", text = "Please wait, preparing data...", color = "#e95420")
  index <- get_index()
  collections <- collection_info()
  remove_modal_spinner()
  
  # retrieve user graph size selection if it changes from default
  screen_height <- reactive({
    screen_settings_height(input$zoom)
  })
  
  screen_width <- reactive({
    screen_settings_width(input$zoom)
  })
  
  # Prepare graphs for the Growth tab
  output$growth_graph <- renderPlot({
    if (input$collection_selector == "any"){
      new_docs_growth(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)  
    } else if (input$collection_selector == "none"){
      new_docs_growth(filter_collection(index,collection_id = "none"), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    } else {
      new_docs_growth(filter_collection(index,collection_id = input$collection_selector), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    }
    
  }, height = screen_height)
  
  # Prepare pie charts for Composition tab plot
  output$composition_doctypes <- renderPlot({
    
    if (input$collection_selector == "any"){
      composition_doctypes_graph(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)  
    } else if (input$collection_selector == "none"){
      composition_doctypes_graph(filter_collection(index,collection_id = "none"), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    } else {
      composition_doctypes_graph(filter_collection(index,collection_id = input$collection_selector), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    }
  })
  
  output$composition_visibility <- renderPlot({
    if (input$collection_selector == "any"){
      composition_visibility_graph(index, input$daterange[1], input$daterange[2], input$doctypes)  
    } else if (input$collection_selector == "none"){
      composition_visibility_graph(filter_collection(index,collection_id = "none"), input$daterange[1], input$daterange[2], input$doctypes)
    } else {
      composition_visibility_graph(filter_collection(index,collection_id = input$collection_selector), input$daterange[1], input$daterange[2], input$doctypes)
    }
  })
  
  # Prep report card grouped by date 
  output$report_card_bydate <- renderDataTable(
    if (input$collection_selector == "any"){
      generate_report_card_bydate(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)  
    } else if (input$collection_selector == "none"){
      generate_report_card_bydate(filter_collection(index,collection_id = "none"), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    } else {
      generate_report_card_bydate(filter_collection(index,collection_id = input$collection_selector), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    },
    options = list(pageLength = 10)
    )
  
  
  # Prep frequency of doctypes report card
  output$report_card_overview <- renderDataTable(
    if (input$collection_selector == "any"){
      generate_report_card_overview(index, input$daterange[1], input$daterange[2], input$doctypes, input$visibility)  
    } else if (input$collection_selector == "none"){
      generate_report_card_overview(filter_collection(index,collection_id = "none"), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    } else {
      generate_report_card_overview(filter_collection(index,collection_id = input$collection_selector), input$daterange[1], input$daterange[2], input$doctypes, input$visibility)
    }
  )
  
  # display sidebar selection elsewhere if needed
  output$filter_from <- renderPrint(input$daterange[1])
  output$filter_to <- renderPrint(input$daterange[2])
}
