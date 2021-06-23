#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RSQLite)
library(tidyverse)
library(lubridate)
library(plotly)


connection <- dbConnect(RSQLite::SQLite(), "data/COVID.db")

x <- tbl(connection, "county") %>% collect()

dbDisconnect(connection)

vaccination_data <- x %>% 
    mutate(date = date %>% ymd()) %>% 
    select(date, state, county, contains("vaccination"))

MiamiDadeData <- x %>% filter(county == "Miami-Dade County")



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("COVID Vacciation Dashboard"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
    #         sliderInput("bins",
    #                     "Number of bins:",
    #                     min = 1,
    #                     max = 50,
    #                     value = 30)
            dateRangeInput("date_range", "Date range:",
                           start  = "2021-02-17",
                           end    = "2021-03-17",
                           min    = "2021-02-17",
                           max    = "2021-05-20",
                           format = "mm/dd/yy",
                           separator = " - "),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("miami_dade_county_plot"),
           plotlyOutput("fl_county_vaccination_plot"),
           plotlyOutput("florida_vaccination_totals"),
           plotlyOutput("vaccination_rt_line_plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    # dataRange <- input$date_range #TODO, not working
    output$miami_dade_county_plot <- renderPlotly({
        #PLOT
        miami_dade_county_plot <- MiamiDadeData %>% 
            mutate(date = date %>% ymd()) %>% 
            select(date, county, contains("vaccination")) %>% 
            filter(!is.na(metrics_vaccinations_completed_ratio)) %>% 
            
            # Date Filter
            # filter(date >= dataRange[1] & date <= dataRange[2]) %>% TODO NOT WORKING

            ggplot(mapping = aes(x = date, y = metrics_vaccinations_completed_ratio, color = county)) + 
            geom_line() + 
            geom_line(mapping = aes(y = metrics_vaccinations_initiated_ratio), color = "blue") +
            geom_hline(yintercept = 0.5) +
            lims(y = c(0, 1)) + 
            theme_bw() + 
            theme(legend.position = "none") + 
            labs(
                title = "Miami Dade County Vaccinations Completed and Initiated", 
                subtitle = "Percentage of Total Population ",
                x = "Date",
                y = "PCT Vaccinations of Population"
            )
        
        ggplotly(miami_dade_county_plot)
    })
    
    output$fl_county_vaccination_plot <- renderPlotly({
        fl_county_vaccination_plot <- vaccination_data %>% 
            filter(!is.na(metrics_vaccinations_completed_ratio)) %>% 
            filter(state == "FL") %>% 
            ggplot(mapping = aes(x = date, y = metrics_vaccinations_completed_ratio, color = county)) + 
            geom_line() + 
            geom_hline(yintercept = 0.5, linetype = "dashed", alpha = 0.5) +
            lims(y = c(0, 0.55)) + 
            theme_bw() +
            theme(legend.position = "none")+ 
            labs(
                title = "Florida Counties Vaccinations Completed", 
                subtitle = "Percentage of Total Population of each County",
                x = "Date",
                y = "PCT Vaccinations Completed for County"
            )
        
        ggplotly(fl_county_vaccination_plot)
    })
    
    output$florida_vaccination_totals <- renderPlotly({
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
            theme_bw() + 
            labs(
                title = "Vaccinations Started Vs Vaccinations Completed", 
                y = "Total Vaccinations (Millions)", 
                x = "Date"
            )
        
        ggplotly(florida_vaccination_totals)
    })
    
    output$vaccination_rt_line_plot <- renderPlotly({
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
            theme_minimal() + 
            labs(
                title = "Trend of Vaccination Rates", 
                x = "Date", 
                y = "Number of Vaccinations"
            )
        
        ggplotly(vaccination_rt_line_plot)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
