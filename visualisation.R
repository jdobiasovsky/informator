library(ggplot2)
library(plotrix)
library(dplyr)
library(lubridate)

new_docs_hist <- function(index,from,to,doctypes,visibility){
  index <- index %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) 
  
  ggplot(index,aes(created_date)) + 
  geom_histogram() + 
  scale_x_datetime(breaks = "years", date_labels = "%Y") +
  labs(title = "Digital library growth") + 
  xlab("Year") +
  ylab("Documents added")
}

new_docs_growth <- function(index, from, to, doctypes, visibility){
  no_of_docs_before <- index %>% filter(created_date < from) %>% nrow()
  
  index <- index %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) %>% 
    group_by(created_date=floor_date(created_date, "month")) %>% 
    tally() %>% 
    mutate(total_docs = cumsum(n)+no_of_docs_before)
  
    
  return(
    ggplot(index,aes(created_date, total_docs, label = n)) + 
      geom_line() +
      geom_point(aes(created_date,total_docs))) + 
      labs(title = "Digital library growth") + 
      xlab("Year") +
      ylab("Documents added")
  }


digital_library_composition <- function(index, from, to, doctypes,visibility){
  index <- index %>% 
    filter(dostupnost %in% visibility) %>%
    filter(fedora.model %in% doctypes) %>%
    filter(created_date > from & created_date < to) %>% 
    group_by(fedora.model) %>%
    tally()
  
  return(
    pie3D(index$n, labels = index$fedora.model, main = "Digital library composition", explode=0.1, radius=.9, labelcex = 1.2,  start=0.7)
  )
}
