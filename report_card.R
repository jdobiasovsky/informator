library(janitor)
library(scales)

generate_report_card <- function(data,from,to,doctypes,visibility){
    data <- data %>% 
      filter(dostupnost %in% visibility) %>%
      filter(fedora.model %in% doctypes) %>%
      filter(created_date > from & created_date < to) 
    
    report_card <- tabyl(data$fedora.model, sort = TRUE)
    report_card$percent <-percent(report_card$percent)
    colnames(report_card) <- c("Type", "Count", "Percent")
    return(report_card)
}
