library(shiny)

ui <- source('ui.R', local = TRUE)
server <-source('server.R')


shinyApp(ui,server)