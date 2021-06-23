library(RSQLite)
library(tidyverse)
library(lubridate)
library(plotly)

# FUNCTIONS ----
connection <- dbConnect(RSQLite::SQLite(), "data/COVID.db")

x <- tbl(connection, "county") %>% collect()

vaccination_data <- x %>% 
    mutate(date = date %>% ymd()) %>% 
    select(date, state, county, contains("vaccination"))

MiamiDadeData <- x %>% filter(county == "Miami-Dade County")

tibble(tbl(connection, "county"))


miami_dade_county_plot <- MiamiDadeData %>% 
    mutate(date = date %>% ymd()) %>% 
    select(date, county, contains("vaccination")) %>% 
    filter(!is.na(metrics_vaccinations_completed_ratio)) %>% 
    ggplot(mapping = aes(x = date, y = metrics_vaccinations_completed_ratio, color = county)) + 
    geom_line() + 
    geom_hline(yintercept = 0.5) +
    lims(y = c(0, 0.75)) + 
    theme_minimal()


fl_county_vaccination_plot <- vaccination_data %>% 
    filter(!is.na(metrics_vaccinations_completed_ratio)) %>% 
    filter(state == "FL") %>% 
    ggplot(mapping = aes(x = date, y = metrics_vaccinations_completed_ratio, color = county)) + 
    geom_line() + 
    geom_hline(yintercept = 0.5) +
    lims(y = c(0, 0.55)) + 
    theme_minimal() +
    theme(legend.position = "none")

ggplotly(miami_dade_county_plot)
ggplotly(fl_county_vaccination_plot)

florida_vaccination_totals <- vaccination_data %>% 
    filter(state == "FL") %>% 
    group_by(date) %>% 
    summarise(
        total_vaccinations_started  = sum(actuals_vaccinations_initiated), 
        total_vaccinations_complete = sum(actuals_vaccinations_completed) 
    ) %>% 
    filter(!is.na(total_vaccinations_started)) %>% 
    ggplot(mapping = aes(x = date, y = total_vaccinations_started)) +
    geom_line(color = "red") + 
    geom_line(mapping = aes(y = total_vaccinations_complete), color = "blue") + 
    scale_y_continuous(labels = scales::number_format(scale = 1e-6, suffix = "M")) + 
    theme_bw()

ggplotly(florida_vaccination_totals)




florida_vaccination_totals_df <- vaccination_data %>% 
    filter(state == "FL") %>% 
    group_by(date) %>% 
    summarise(
        total_vaccinations_started  = sum(actuals_vaccinations_initiated), 
        total_vaccinations_complete = sum(actuals_vaccinations_completed) 
    ) %>% 
    filter(!is.na(total_vaccinations_started)) %>%
    mutate(
        total_vacc_change_ini = total_vaccinations_complete - lag(total_vaccinations_complete, n = 1), 
        total_vacc_change_com = total_vaccinations_started - lag(total_vaccinations_started, n = 1)
    )


vaccination_rt_line_plot <- florida_vaccination_totals_df %>%
    ggplot(mapping = aes(x = date, y = total_vacc_change_com)) + 
    geom_line() + 
    geom_smooth() +
    scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "K")) + 
    theme_minimal()


vaccination_rt_bar_plot <- florida_vaccination_totals_df %>%
    ggplot(mapping = aes(x = date, y = total_vacc_change_com)) + 
    geom_col(color = "white", fill = "black") + 
    geom_smooth(se = F, color = "red", linetype = "dashed", size = 2) + 
    scale_y_continuous(labels = scales::number_format(scale = 1e-3, suffix = "K"))
    

ggplotly(vaccination_rt_line_plot)
ggplotly(vaccination_rt_bar_plot)


dbDisconnect(connection)
