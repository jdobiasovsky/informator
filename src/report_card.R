generate_report_card_bydate <- function(data,from,to,doctypes,visibility){
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



