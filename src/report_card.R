# functions to prep tables of data to display as reports
library(dplyr)

generate_report_card_bydate <- function(data,from,to,doctypes,visibility){
  # Prepare tibble containing digital library growth by date in table format
  # @param data: data.frame or tibble with data fetched from index
  # @param from: string or datetime value for narrowing data from start
  # @param to: string or datetime value for narrowing data to certain point
  # @param doctypes: display data for selected document types (see config for possible values)
  # @param visibility: filter documents by their visibility settings c("private","public")
  data <- data %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to)
  
  data$created_date <- format(data$created_date, "%Y-%m-%d")

  report_card <- data %>% 
    group_by(created_date) %>% 
    count(created_date, fedora.model) %>%
    select(Date = created_date, Type = fedora.model, Count = n) %>%
    arrange(desc(Date)) 
    
  return(report_card)
}

generate_report_card_overview <- function(data,from,to,doctypes,visibility){
  # Sum all documents within selected parameters into single number count and return table.
  # @param data: data.frame or tibble with data fetched from index
  # @param from: string or datetime value for narrowing data from start
  # @param to: string or datetime value for narrowing data to certain point
  # @param doctypes: display data for selected document types (see config for possible values)
  # @param visibility: filter documents by their visibility settings c("private","public")
    data <- index %>% 
      filter(dostupnost %in% visibility) %>%
      filter(fedora.model %in% doctypes) %>%
      filter(created_date > from & created_date < to) 
    
    report_card <- data %>% 
      group_by(fedora.model) %>%
      count(fedora.model) %>%
      select(Type = fedora.model, Count = n)
    
    return(report_card)
}



