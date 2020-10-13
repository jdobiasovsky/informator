# Functions to create graphs for display across the app
library(ggplot2)
library(plotrix)
library(dplyr)
library(lubridate)

screen_settings_height <- function(selection){
  # Returns height in pixels for given selection
  # @param selection: string passed from ui
  if (selection == "auto"){
    return("auto")
  } else if (selection == "large") {
    return(768)
  } else if (selection == "medium") {
    return(640)
  } else if (selection == "small") {
    return(256)
  }
}

screen_settings_width<- function(selection){
  # Returns height in pixels for given selection. Currently not used
  # @param selection: string passed from ui
  if (selection == "auto"){
    return("auto")
  } else if (selection == "large") {
    return(1280)
  } else if (selection == "medium") {
    return(640)
  } else if (selection == "small") {
    return(308)
  }
}

new_docs_hist <- function(data,from,to,doctypes,visibility){
  # Create histogram of yearly growth
  # @param data: data.frame or tibble with data fetched from index
  # @param from: string or datetime value for narrowing data from start
  # @param to: string or datetime value for narrowing data to certain point
  # @param doctypes: display data for selected document types (see config for possible values)
  # @param visibility: filter documents by their visibility settings c("private","public")
  data <- data %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) 
  return(
    ggplot(data,aes(created_date)) + 
    geom_histogram() + 
    scale_x_datetime(breaks = "years", date_labels = "%Y") +
    labs(title = "Digital library growth") + 
    xlab("Year") +
    ylab("Documents added"))
}

new_docs_growth <- function(data, from, to, doctypes, visibility){
  # Draw line graph displaying new documents over time
  # @param data: data.frame or tibble with data fetched from index
  # @param from: string or datetime value for narrowing data from start
  # @param to: string or datetime value for narrowing data to certain point
  # @param doctypes: display data for selected document types (see config for possible values)
  # @param visibility: filter documents by their visibility settings c("private","public")
  
  no_of_docs_before <- data %>%
      filter(dostupnost %in% visibility) %>%
      filter(fedora.model %in% doctypes) %>%
      filter(created_date < from) %>% nrow()
  
  data <- data %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) %>% 
    group_by(created_date=floor_date(created_date, "month")) %>% 
    tally() %>% 
    mutate(total_docs = cumsum(n)+no_of_docs_before)
  
    
  return(
    ggplot(data,aes(created_date, total_docs, label = n)) + 
      geom_line() +
      geom_point(aes(created_date,total_docs))) + 
      labs(title = "Digital library growth") + 
      xlab("Year") +
      ylab("Documents added")
  }


composition_doctypes_graph <- function(data, from, to, doctypes, visibility){
  # Pie chart showing composition by document types
  # @param data: data.frame or tibble with data fetched from index
  # @param from: string or datetime value for narrowing data from start
  # @param to: string or datetime value for narrowing data to certain point
  # @param doctypes: display data for selected document types (see config for possible values)
  # @param visibility: filter documents by their visibility settings c("private","public")
  
  data <- data %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) %>% 
    group_by(fedora.model) %>%
    tally()
  
  return(
    pie3D(data$n, labels = data$fedora.model, main = "Document types", explode=0.1, radius=.9, labelcex = 1.2,  start=0.7)
    )
}

composition_visibility_graph <- function(data,from,to, doctypes){
  # Pie chart of composition by visibility
  # @param data: data.frame or tibble with data fetched from index
  # @param from: string or datetime value for narrowing data from start
  # @param to: string or datetime value for narrowing data to certain point
  # @param doctypes: display data for selected document types (see config for possible values)
  # @param visibility: filter documents by their visibility settings c("private","public")
  data <- data %>% 
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) %>% 
    group_by(dostupnost) %>%
    tally()
  
  return(
    pie3D(data$n, labels = data$dostupnost, main = "Document visibility", explode=0.1, radius=.9, labelcex = 1.2,  start=0.7)
    )
}

