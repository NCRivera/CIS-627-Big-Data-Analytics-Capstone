library(tidyverse)
library(lubridate)
library(gganimate)

source(file = "scripts/functions_scripts.R")

vaccination_data <- get_county_data(cnty = NULL) %>% 
    mutate(date = date %>% ymd())

x <- vaccination_data %>% 
    select(date, county, contains("vaccination")) %>% 
    filter(!is.na(actuals.vaccinationsInitiated)) %>% 
    

vaccination_data

# x <- vaccination_data %>% 
#     filter(date >= "2021-05-01") 

x %>%
    ggplot(mapping = aes(x = date)) + 
    geom_line(mapping = aes(y = actuals.vaccinationsInitiated, color = county)) + 
    geom_line(mapping = aes(y = actuals.vaccinationsCompleted, color = county)) + 
    geom_point(mapping = aes(y = actuals.vaccinationsInitiated, color = county)) +
    geom_point(mapping = aes(y = actuals.vaccinationsCompleted, color = county)) + 
    lims(y = c(min(x$actuals.vaccinationsCompleted), NA))


x %>% 
    ggplot(mapping = aes(x = date, y = actuals.vaccinationsInitiated, size = metrics.vaccinationsCompletedRatio))


x %>% 
    ggplot(mapping = aes(x = metrics.vaccinationsInitiatedRatio, y = metrics.vaccinationsCompletedRatio, colour, color = county)) +
    geom_point(show.legend = FALSE) +
    labs(title = 'Date: {frame_time}', x = 'Vaccinations Initiated', y = 'Vaccinations Completed') +
    transition_time(date) +
    ease_aes('linear')

x %>% 
    ggplot(mapping = aes(x = date, y = actuals.vaccinationsInitiated, size = metrics.vaccinationsCompletedRatio, color = county)) +
    geom_point(show.legend = FALSE) +
    scale_y_log10() +
    labs(title = 'Date: {frame_time}', x = 'Date', y = 'Vaccinations Initiated') +
    transition_time(date) +
    ease_aes('linear')


x %>% 
    ggplot(mapping = aes(x = county, y = metrics.vaccinationsInitiatedRatio)) + 
    geom_col() + 
    labs(title = 'Date: {frame_time}', x = 'County', y = 'Vaccinations Completed PCT') +
    transition_time(date) +
    ease_aes('linear')

    # geom_point(alpha = 0.7, show.legend = FALSE) +
    # scale_colour_manual(values = country_colors) +
    # scale_size(range = c(2, 12)) +
    # scale_x_log10() +
    # facet_wrap(~continent) +
    # Here comes the gganimate specific bits
    # labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +

data %>% 
    select(date, contains("vaccination")) %>% 
    filter(!is.na(actuals.vaccinationsInitiated)) %>% 
    ggplot(mapping = aes(x = date, y = metrics.vaccinationsInitiatedRatio)) +
    geom_col() + 
    lims(y = c(0, 1))

new_data <- get_county_data()

