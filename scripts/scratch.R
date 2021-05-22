

x <- vaccination_data %>% 
    filter(date >= "2021-05-01") 

x %>%
    ggplot(mapping = aes(x = date)) + 
    geom_line(mapping = aes(y = actuals.vaccinationsInitiated), color = "red") + 
    geom_line(mapping = aes(y = actuals.vaccinationsCompleted)) + 
    geom_point(mapping = aes(y = actuals.vaccinationsInitiated), color = "red") +
    geom_point(mapping = aes(y = actuals.vaccinationsCompleted)) + 
    lims(y = c(min(x$actuals.vaccinationsCompleted), NA))


data %>% 
    select(date, contains("vaccination")) %>% 
    filter(!is.na(actuals.vaccinationsInitiated)) %>% 
    ggplot(mapping = aes(x = date, y = metrics.vaccinationsInitiatedRatio)) +
    geom_col() + 
    lims(y = c(0, 1))

new_data <- get_county_data()

